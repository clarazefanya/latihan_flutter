import 'package:flutter/material.dart';
import 'package:latihan_flutter/tugas1516flutter/models/user_model.dart';

class DetailUserScreen extends StatelessWidget {
  final UserModel user;
  final String? trainingName;
  final String? batchName;

  const DetailUserScreen({
    super.key,
    required this.user,
    this.trainingName,
    this.batchName,
  });

  // String _formatDate(DateTime? dateTime) {
  //   if (dateTime == null) return "-";
  //   try {
  //     return DateFormat.yMMMMd('id_ID').format(dateTime);
  //   } catch (_) {
  //     // Fallback jika formatting dengan id_ID gagal/locale belum di-load
  //     return DateFormat.yMMMMd().format(dateTime);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF);
    const backgroundColor = Color(0xFFF9F8FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Detail Informasi Akun",
          style: TextStyle(
            color: Color(0xFF2E2E3A),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF2E2E3A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Seksi 1: Data Personal
                _buildSectionHeader("Informasi Personal"),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        icon: Icons.person_outline_rounded,
                        label: "Nama Lengkap",
                        value: user.name ?? "-",
                      ),
                      const Divider(height: 24.0, thickness: 0.8),
                      _buildDetailItem(
                        icon: Icons.email_outlined,
                        label: "Alamat Email",
                        value: user.email ?? "-",
                      ),
                      const Divider(height: 24.0, thickness: 0.8),
                      _buildDetailItem(
                        icon: Icons.wc_outlined,
                        label: "Jenis Kelamin",
                        value: user.jenisKelamin == 'L'
                            ? "Laki-laki"
                            : (user.jenisKelamin == 'P' ? "Perempuan" : "-"),
                      ),
                      // const Divider(height: 24.0, thickness: 0.8),
                      // _buildDetailItem(
                      //   icon: Icons.calendar_today_outlined,
                      //   label: "Tanggal Terdaftar",
                      //   value: _formatDate(user.createdAt),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Seksi 2: Kelas & Angkatan
                _buildSectionHeader("Informasi Kelas & Pelatihan"),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        icon: Icons.school_outlined,
                        label: "Kelas Pelatihan",
                        // value: trainingName ?? "Pelatihan #${user.trainingId}",
                        value: trainingName!,
                      ),
                      const Divider(height: 24.0, thickness: 0.8),
                      _buildDetailItem(
                        icon: Icons.groups_outlined,
                        label: "Angkatan (Batch)",
                        value: batchName!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Seksi 3: Status Keamanan
                _buildSectionHeader("Status Akun"),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        icon: Icons.verified_user_outlined,
                        label: "Status Verifikasi Email",
                        value: user.emailVerifiedAt != null
                            ? "Terverifikasi"
                            : "Belum Terverifikasi",
                        valueColor: user.emailVerifiedAt != null
                            ? const Color(0xFF00BFA5)
                            : Colors.amber[800],
                      ),
                      // const Divider(height: 24.0, thickness: 0.8),
                      // _buildDetailItem(
                      //   icon: Icons.perm_identity_outlined,
                      //   label: "ID Pengguna",
                      //   value: user.id?.toString() ?? "-",
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7E7E8F),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    const primaryColor = Color(0xFF8C52FF);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 22.0),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF7E7E8F),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? const Color(0xFF2E2E3A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
