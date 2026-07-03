import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutter/tugas1516flutter/models/batch_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/profile_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/training_response.dart';
import 'package:latihan_flutter/tugas1516flutter/services/auth_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';
import 'package:latihan_flutter/tugas1516flutter/services/token_storage.dart';
import 'package:latihan_flutter/tugas1516flutter/views/detail_user_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/edit_profile_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthService _authService;
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _authService = AuthService(dio);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _dashboardDataFuture = _fetchDashboardData();
    });
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final responses = await Future.wait([
      _authService.getProfile(),
      _authService.getTrainings(),
      _authService.getBatches(),
    ]);

    return {
      'profile': responses[0] as ProfileResponse,
      'trainings': (responses[1] as TrainingResponse).data ?? [],
      'batches': (responses[2] as BatchResponse).data ?? [],
    };
  }

  String _getProfilePhotoUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    // Base URL server
    return "https://appabsensi.mobileprojp.com/$path";
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF); // Lavender Purple
    const accentColor = Color(0xFF7B2CBF);
    const backgroundColor = Color(0xFFF9F8FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        // foregroundColor: const Color(0xFF2E2E3A),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Gagal Memuat Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final user = (data['profile'] as ProfileResponse).data!;
          final trainings = data['trainings'] as List<TrainingModel>;
          final batches = data['batches'] as List<BatchModel>;

          // Cari relasi training & batch dengan memaksa perbandingan ke String
          final matchedTraining = trainings.firstWhere(
            (t) => t.id.toString() == user.trainingId.toString(),
            orElse: () => TrainingModel(title: "Pelatihan Tidak Ditemukan"),
          );

          final matchedBatch = batches.firstWhere(
            (b) => b.id.toString() == user.batchId.toString(),
            orElse: () => BatchModel(batchKe: "Batch Tidak Ditemukan"),
          );

          final imageUrl = _getProfilePhotoUrl(user.profilePhoto);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header dengan Custom Curved Background
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0),
                        ),
                      ),
                    ),
                    // Tombol Logout di Kanan Atas
                    // Positioned(
                    //   top: 40,
                    //   right: 16,
                    //   child: IconButton(
                    //     icon: const Icon(
                    //       Icons.logout_rounded,
                    //       color: Colors.white,
                    //     ),
                    //     onPressed: () async {
                    //       await TokenStorage.clearToken();
                    //       if (context.mounted) {
                    //         Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const LoginScreen(),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),
                    // Judul Dashboard
                    // const Positioned(
                    //   top: 48,
                    //   // left: 24,
                    //   child: Text(
                    //     "Profil Saya",
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // Foto Profil Mengambang
                    Positioned(
                      bottom: -50,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(54),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    width: 108,
                                    height: 108,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.person,
                                          size: 54,
                                          color: primaryColor,
                                        ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 54,
                                  color: primaryColor,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64.0),
                // Nama User
                Text(
                  user.name ?? "Nama Tidak Tersedia",
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E2E3A),
                  ),
                ),
                const SizedBox(height: 4.0),
                // Email User
                Text(
                  user.email ?? "Email Tidak Tersedia",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF7E7E8F),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Card Pelatihan & Angkatan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.school_outlined,
                                color: primaryColor,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Pelatihan",
                                style: TextStyle(
                                  color: Color(0xFF7E7E8F),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                matchedTraining.title ?? "-",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E2E3A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.groups_outlined,
                                color: primaryColor,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Angkatan/Batch",
                                style: TextStyle(
                                  color: Color(0xFF7E7E8F),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                matchedBatch.batchKe ?? "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E2E3A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28.0),
                // Daftar Menu Navigasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.edit_outlined,
                        title: "Edit Profil & Foto",
                        subtitle: "Ubah nama atau perbarui foto profil Anda",
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(user: user),
                            ),
                          );
                          if (result == true) {
                            _loadData();
                          }
                        },
                      ),
                      const SizedBox(height: 12.0),
                      _buildMenuItem(
                        icon: Icons.account_circle_outlined,
                        title: "Detail Akun Lengkap",
                        subtitle: "Lihat informasi biodata pendaftaran",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailUserScreen(
                                user: user,
                                trainingName: matchedTraining.title,
                                batchName: matchedBatch.batchKe,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      // Tombol logout
                      TextButton(
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  "Apakah kamu yakin ingin keluar dari akun ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Ya"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldLogout == true) {
                            await TokenStorage.clearToken();

                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          // side: BorderSide(color: primaryColor, width: 2),
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded),
                            SizedBox(width: 5),
                            Text("Logout"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF8C52FF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Color(0xFF2E2E3A),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF7E7E8F),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
