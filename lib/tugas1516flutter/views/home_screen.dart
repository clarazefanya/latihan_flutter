import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_stats_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_today_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/history_absen_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/profile_response.dart';
import 'package:latihan_flutter/tugas1516flutter/services/attendance_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/auth_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';
import 'package:latihan_flutter/tugas1516flutter/views/detail_map_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final AttendanceService _attendanceService;
  late final AuthService _authService;

  bool _isLoading = true;
  String _userName = "Pengguna";
  AbsenModel? _todayAbsen;
  AbsenStatsModel? _stats;
  List<AbsenModel> _recentHistory = [];

  // State untuk kontrol filter statistik
  String _selectedStatFilter = 'all'; // Pilihan: 'all', 'year', 'range'
  final _statYearController = TextEditingController();
  final _statStartDateController = TextEditingController();
  final _statEndDateController = TextEditingController();
  bool _isStatLoading = false; // Loading lokal khusus widget statistik

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    final dio = createDioClient();
    _attendanceService = AttendanceService(dio);
    _authService = AuthService(dio);
    loadDashboardData();
  }

  // Helper tulisan greeting dinamis
  String _getGreetingText() {
    final hour = DateTime.now().hour;

    if (hour >= 1 && hour < 11) {
      return "Selamat Pagi,";
    } else if (hour >= 11 && hour < 15) {
      return "Selamat Siang,";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat Sore,";
    } else {
      return "Selamat Malam,";
    }
  }

  Future<void> loadDashboardData() async {
    setState(() => _isLoading = true);
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // Future khusus untuk endpoint absen today
      final todayFuture = () async {
        try {
          return await _attendanceService.getToday(todayStr);
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) {
            // Anggap belum ada absensi hari ini
            return AbsenTodayResponse(
              message: e.response?.data['message'],
              data: null,
            );
          }
          rethrow;
        }
      }();

      // Mengambil data profile, status hari ini, statistik, dan riwayat secara paralel
      final results = await Future.wait([
        _authService.getProfile(),
        todayFuture,
        _attendanceService.getStats(),
        _attendanceService.getHistory(),
      ]);

      final profileRes = results[0] as ProfileResponse;
      final todayRes = results[1] as AbsenTodayResponse;
      final statsRes = results[2] as AbsenStatsResponse;
      final historyRes = results[3] as HistoryAbsenResponse;

      setState(() {
        _userName = profileRes.data?.name ?? "Pengguna";
        _todayAbsen = todayRes.data;
        _stats = statsRes.data;

        // Ambil maksimal 3 riwayat absen terakhir untuk preview di Home
        final allHistory = historyRes.data ?? [];
        _recentHistory = allHistory.take(3).toList();

        //kolom input statistik disetel ulang ke default
        _selectedStatFilter = 'all';
        _statYearController.clear();
        _statStartDateController.clear();
        _statEndDateController.clear();

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar("Gagal memuat data dashboard", isError: true);
    }
  }

  // Fungsi utama untuk memicu reload statistik berdasarkan filter yang dipilih
  Future<void> _loadFilteredStats() async {
    // Jika pilih all, langsung tembak tanpa parameter
    if (_selectedStatFilter == 'all') {
      _fetchStatsData(_attendanceService.getStats());
      return;
    }
    // Jika pilih tahun, validasi dulu lalu tembak getStatsByYear
    if (_selectedStatFilter == 'year') {
      final yearInt = int.tryParse(_statYearController.text);
      if (yearInt == null) {
        _showSnackBar("Harap masukkan tahun yang valid", isError: true);
        return;
      }
      _fetchStatsData(_attendanceService.getStatsByYear(yearInt));
      return;
    }

    // Jika pilih rentang tanggal, validasi lalu tembak getStatsByDateRange
    if (_selectedStatFilter == 'range') {
      if (_statStartDateController.text.isEmpty ||
          _statEndDateController.text.isEmpty) {
        _showSnackBar("Harap isi kedua tanggal rentang waktu", isError: true);
        return;
      }
      _fetchStatsData(
        _attendanceService.getStatsByDateRange(
          _statStartDateController.text,
          _statEndDateController.text,
        ),
      );
    }
  }

  // Helper function untuk eksekusi Future API statistik secara dinamis
  Future<void> _fetchStatsData(Future<AbsenStatsResponse> apiCall) async {
    setState(() => _isStatLoading = true);
    try {
      final res = await apiCall;
      setState(() {
        _stats = res.data;
        _isStatLoading = false;
      });
    } catch (e) {
      setState(() => _isStatLoading = false);
      _showSnackBar("Gagal memuat statistik terbaru", isError: true);
    }
  }

  // Helper untuk DatePicker filter statistik
  Future<void> _selectStatDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Fungsi navigasi ke halaman Detail Lokasi (Google Maps) sekalian proses Absen
  Future<void> _navigateToMapAndAbsen(bool isCheckIn) async {
    // Trigger Geolocator terlebih dahulu sebelum pindah ke detail maps screen
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      // Pindah ke halaman peta dan tunggu respons balik saat halaman di-pop
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailMapScreen(isCheckIn: isCheckIn),
        ),
      );

      // Jika absensi sukses dilakukan di halaman peta, segarkan data Dashboard secara otomatis
      if (result == true) {
        loadDashboardData();
      }
    } catch (e) {
      _showSnackBar("Gagal mendapatkan izin lokasi", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFFF5252)
            : const Color(0xFF00BFA5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF); // Lavender Purple
    const backgroundColor = Color(0xFFF9F8FD);

    final todayDate = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadDashboardData,
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // padding: const EdgeInsets.symmetric(
            //   horizontal: 20.0,
            //   vertical: 20.0,
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    // Lapisan Latar Belakang Ungu Melengkung (Background Base)
                    Container(
                      height: 330, // Tinggi blok warna ungu atas
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0),
                        ),
                      ),
                    ),

                    // Lapisan Konten Utama (Greeting & Kotak Waktu Kerja)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1 & 2: Greeting & Nama User
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreetingText(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      // color: Color(
                                      //   0xFFE2D5FF,
                                      // ), // Ungu muda pudar halus
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          // 3 & 4: Kotak Informasi Waktu Kerja
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withValues(
                              //       alpha: 0.06,
                              //     ), // Shadow tipis alami
                              //     blurRadius: 15,
                              //     offset: const Offset(0, 8),
                              //   ),
                              // ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  todayDate,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7E7E8F),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // INFORMASI JAM CHECK IN DAN CHECK OUT HARI INI
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildTimeStatusBox(
                                      label: "Check In",
                                      time: _todayAbsen?.checkInTime ?? "--:--",
                                      icon: Icons.login_rounded,
                                      iconColor: const Color(0xFF00BFA5),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    _buildTimeStatusBox(
                                      label: "Check Out",
                                      time:
                                          _todayAbsen?.checkOutTime ?? "--:--",
                                      icon: Icons.logout_rounded,
                                      iconColor: Colors.orange,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Alur Conditional Button tetap dipertahankan di paling bawah
                                if (_todayAbsen?.checkInTime == null) ...[
                                  _buildAbsenButton(
                                    label: "Check In",
                                    icon: Icons.login_rounded,
                                    color: const Color(0xFF00BFA5),
                                    onPressed: () =>
                                        _navigateToMapAndAbsen(true),
                                  ),
                                ] else if (_todayAbsen?.checkOutTime ==
                                    null) ...[
                                  _buildAbsenButton(
                                    label: "Check Out",
                                    icon: Icons.logout_rounded,
                                    color: Colors.orange,
                                    onPressed: () =>
                                        _navigateToMapAndAbsen(false),
                                  ),
                                ] else ...[
                                  const Text(
                                    "Absensi Anda hari ini telah lengkap.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 5. List History Absen Beberapa Paling Terakhir
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Aktivitas Terakhir",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E2E3A),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(HistoryScreen());
                            },
                            child: const Text(
                              "Lihat Semua",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      _recentHistory.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                "Belum ada riwayat tercatat.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _recentHistory.length,
                              itemBuilder: (context, index) {
                                final log = _recentHistory[index];
                                final dateLog = log.attendanceDate != null
                                    ? DateFormat(
                                        'EEEE, d MMMM yyyy',
                                        'id_ID',
                                      ).format(log.attendanceDate!)
                                    : '-';
                                return Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFFF6F5FB),
                                      child: Icon(
                                        Icons.check_circle_outline_outlined,
                                        color: log.status == "masuk"
                                            ? const Color(0xFF00BFA5)
                                            : log.status == "izin"
                                            ? Colors.orange
                                            : Colors.grey,
                                      ),
                                    ),
                                    title: Text(
                                      dateLog,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Masuk: ${log.checkInTime ?? '--'} | Pulang: ${log.checkOutTime ?? '--'}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Text(
                                      // log.status ?? "Hadir",
                                      log.status == "masuk"
                                          ? "Hadir"
                                          : log.status == "izin"
                                          ? "Izin"
                                          : "-",
                                      style: TextStyle(
                                        color: log.status == "masuk"
                                            ? const Color(0xFF00BFA5)
                                            : log.status == "izin"
                                            ? Colors.orange
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 15),

                      // 6. Statistik
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Judul Statistik Absensi
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "Statistik Absensi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E2E3A),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 12),

                          // Dropdown Pilihan Tipe Filter Statistik
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedStatFilter,
                              isExpanded:
                                  true, // Agar teks di dalam dropdown terpotong rapi jika kepanjangan
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: "Pilih Filter",
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text(
                                    "Semua Waktu",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'year',
                                  child: Text(
                                    "Per Tahun",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'range',
                                  child: Text(
                                    "Rentang Waktu",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _selectedStatFilter = value;
                                });
                                if (value == 'all') {
                                  _loadFilteredStats();
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // TAMPILKAN INPUT SECARA KONDISIONAL BERDASARKAN SELEKSI DROPDOWN
                      if (_selectedStatFilter == 'year') ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _statYearController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Masukkan Tahun",
                                  labelStyle: TextStyle(fontSize: 14),
                                  hintText: "Contoh: 2026",
                                  hintStyle: TextStyle(fontSize: 14),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _loadFilteredStats,
                              child: const Icon(Icons.search),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ] else if (_selectedStatFilter == 'range') ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _statStartDateController,
                                readOnly: true,
                                onTap: () => _selectStatDate(
                                  context,
                                  _statStartDateController,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Awal",
                                  labelStyle: TextStyle(fontSize: 14),
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text("-", style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                controller: _statEndDateController,
                                readOnly: true,
                                onTap: () => _selectStatDate(
                                  context,
                                  _statEndDateController,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Akhir",
                                  labelStyle: TextStyle(fontSize: 14),
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _loadFilteredStats,
                              child: const Icon(Icons.search),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // TAMPILAN BOX STATISTIK (DIBUNGKUS LOADING STATE KONDISIONAL)
                      _isStatLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                _buildStatBox(
                                  "Total",
                                  "${_stats?.totalAbsen ?? 0}",
                                  Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                _buildStatBox(
                                  "Hadir",
                                  "${_stats?.totalMasuk ?? 0}",
                                  const Color(0xFF00BFA5),
                                ),
                                const SizedBox(width: 12),
                                _buildStatBox(
                                  "Izin",
                                  "${_stats?.totalIzin ?? 0}",
                                  Colors.orange,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAbsenButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _buildTimeStatusBox({
    required String label,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7E7E8F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E3A),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
