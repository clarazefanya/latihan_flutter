import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';

class HistoryDetailScreen extends StatelessWidget {
  final AbsenModel absenData;

  // Menerima data utuh dari halaman list lewat constructor
  const HistoryDetailScreen({super.key, required this.absenData});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF);
    final dateStr = absenData.attendanceDate != null
        ? DateFormat(
            'EEEE, d MMMM yyyy',
            'id_ID',
          ).format(absenData.attendanceDate!)
        : '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FD),
      appBar: AppBar(
        title: const Text(
          "Detail Absensi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF2E2E3A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Info Utama (Tanggal & Status)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 48,
                    color: absenData.status?.toLowerCase() == 'masuk'
                        ? const Color(0xFF00BFA5)
                        : absenData.status?.toLowerCase() == 'izin'
                        ? Colors.orange
                        : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Status: ${(absenData.status ?? '-').toUpperCase()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: absenData.status?.toLowerCase() == 'masuk'
                          ? const Color(0xFF00BFA5)
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card Log Data Check In
            _buildSectionCard(
              title: "Log Check In (Masuk)",
              icon: Icons.login_rounded,
              iconColor: const Color(0xFF00BFA5),
              children: [
                _buildDetailRow("Waktu Check In", absenData.checkInTime ?? "-"),
                _buildDetailRow("Latitude", "${absenData.checkInLat ?? '-'}"),
                _buildDetailRow("Longitude", "${absenData.checkInLng ?? '-'}"),
                _buildDetailRow("Koordinat", absenData.checkInLocation ?? "-"),
                _buildDetailRow(
                  "Alamat",
                  absenData.checkInAddress ?? "-",
                  isLongText: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card Log Data Check Out
            _buildSectionCard(
              title: "Log Check Out (Pulang)",
              icon: Icons.logout_rounded,
              iconColor: Colors.orange,
              children: [
                _buildDetailRow(
                  "Waktu Check Out",
                  absenData.checkOutTime ?? "-",
                ),
                _buildDetailRow("Latitude", "${absenData.checkOutLat ?? '-'}"),
                _buildDetailRow("Longitude", "${absenData.checkOutLng ?? '-'}"),
                _buildDetailRow("Koordinat", absenData.checkOutLocation ?? "-"),
                _buildDetailRow(
                  "Alamat",
                  absenData.checkOutAddress ?? "-",
                  isLongText: true,
                ),
              ],
            ),

            // Tampilkan info izin hanya jika data alasan_izin ada isinya (tidak null)
            if (absenData.alasanIzin != null) ...[
              const SizedBox(height: 16),
              _buildSectionCard(
                title: "Informasi Khusus Keterangan",
                icon: Icons.info_outline_rounded,
                iconColor: Colors.blue,
                children: [
                  _buildDetailRow(
                    "Alasan Izin",
                    absenData.alasanIzin!,
                    isLongText: true,
                  ),
                ],
              ),
            ],
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF2E2E3A),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: isLongText
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF7E7E8F), fontSize: 13),
            ),
          ),
          const Text(" :  "),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E2E3A),
                fontSize: 13,
              ),
              textAlign: isLongText ? TextAlign.right : TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
