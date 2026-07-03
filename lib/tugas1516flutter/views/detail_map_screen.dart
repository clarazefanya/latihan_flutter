import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutter/tugas1516flutter/services/attendance_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';

class DetailMapScreen extends StatefulWidget {
  final bool isCheckIn; // true = Check In, false = Check Out

  const DetailMapScreen({super.key, required this.isCheckIn});

  @override
  State<DetailMapScreen> createState() => _DetailMapScreenState();
}

class _DetailMapScreenState extends State<DetailMapScreen> {
  late final AttendanceService _attendanceService;

  GoogleMapController? _mapController;
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _attendanceService = AttendanceService(createDioClient());
    _getCurrentLocation();
  }

  // Mendapatkan lokasi saat ini dengan akurasi tinggi
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;

        // Tambahkan penanda (marker) di koordinat pengguna
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: 'Lokasi Anda',
              snippet: '${position.latitude}, ${position.longitude}',
            ),
          ),
        );
      });

      // Dapatkan address setelah berhasil mendapatkan lat lng
      await _getAddressFromLatLng(position.latitude, position.longitude);

      // Gerakkan kamera peta ke lokasi pengguna secara halus
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          17.0, // Zoom level yang cukup dekat agar akurat
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Gagal mendapatkan koordinat GPS terbaru.", isError: true);
    }
  }

  // Mengambil alamat dari Lat Lng
  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        setState(() {
          _currentAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
          ].where((e) => e != null && e.isNotEmpty).join(", ");
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Alamat tidak tersedia";
      });
    }
  }

  // Proses pengiriman koordinat ke endpoint API
  Future<void> _processAttendance() async {
    if (_currentPosition == null) return;

    setState(() => _isSubmitting = true);

    try {
      // 1. Dapatkan alamat riil secara otomatis berdasarkan koordinat GPS (Reverse Geocoding)
      String currentAddress = "Jakarta"; // Default fallback
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        if (placemarks.isNotEmpty) {
          // final place = placemarks.first;
          currentAddress = _currentAddress ?? "Jakarta";
        }
      } catch (_) {
        // Jika geocoding gagal/timeout, biarkan memakai default "Jakarta"
      }

      // 2. Siapkan variabel waktu & tanggal sekarang
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final formattedTime = DateFormat('HH:mm').format(now);

      String successMessage = "";

      // 3. Cabang logic pengiriman data sesuai spesifikasi payload masing-masing API
      if (widget.isCheckIn) {
        final payloadCheckIn = {
          "attendance_date": formattedDate,
          "check_in": formattedTime,
          "check_in_lat": _currentPosition!.latitude,
          "check_in_lng": _currentPosition!.longitude,
          "check_in_address": currentAddress,
          "status": "masuk",
        };

        final response = await _attendanceService.checkIn(payloadCheckIn);
        successMessage = response.message;
      } else {
        final payloadCheckOut = {
          "attendance_date": formattedDate,
          "check_out": formattedTime,
          "check_out_lat": "${_currentPosition!.latitude}",
          "check_out_lng": "${_currentPosition!.longitude}",
          "check_out_location":
              "${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
          "check_out_address": currentAddress,
        };

        final response = await _attendanceService.checkOut(payloadCheckOut);
        successMessage = response.message;
      }

      _showSnackBar(successMessage, isError: false);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on DioException catch (e) {
      String errorMsg = "Gagal memproses absensi.";
      if (e.response?.data != null) {
        errorMsg = e.response!.data['message'] ?? errorMsg;
      }
      _showSnackBar(errorMsg, isError: true);
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFFF5252)
            : const Color(0xFF00BFA5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF);
    final actionColor = widget.isCheckIn
        ? const Color(0xFF00BFA5)
        : Colors.orange;
    final actionTitle = widget.isCheckIn ? "Check In" : "Check Out";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Konfirmasi Lokasi $actionTitle",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2E2E3A),
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          // 1. Google Maps View (Layar Penuh)
          _currentPosition == null && _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition?.latitude ?? -6.2000,
                      _currentPosition?.longitude ?? 106.8166,
                    ),
                    zoom: 12.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (_currentPosition != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          17.0,
                        ),
                      );
                    }
                  },
                ),

          // 2. Tombol Custom untuk Reset/Arahkan Ulang Kamera ke Lokasi GPS Terkini
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: "btn_gps",
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),

          // 3. Floating Card Detail Koordinat & Tombol Konfirmasi Absen di Bagian Bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_rounded,
                        color: primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "LOKASI SAAT INI",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7E7E8F),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _currentPosition == null
                      ? const Text(
                          "Mencari lokasi...",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        )
                      : Text(
                          "Latitude: ${_currentPosition!.latitude}\nLongitude: ${_currentPosition!.longitude}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E2E3A),
                          ),
                        ),
                  _currentAddress == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Alamat: $_currentAddress",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2E2E3A),
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),

                  // Tombol Utama Eksekusi API Absensi
                  ElevatedButton(
                    onPressed:
                        (_isLoading ||
                            _isSubmitting ||
                            _currentPosition == null)
                        ? null
                        : _processAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            "Konfirmasi $actionTitle",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
