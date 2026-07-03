import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_flutter/tugas1516flutter/services/auth_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';
import 'package:latihan_flutter/tugas1516flutter/services/token_storage.dart';
import 'package:latihan_flutter/tugas1516flutter/views/login_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/main_navigation_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen35 extends StatefulWidget {
  const SplashScreen35({super.key});

  @override
  State<SplashScreen35> createState() => _SplashScreen35State();
}

class _SplashScreen35State extends State<SplashScreen35> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _authService = AuthService(dio);
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Memberi sedikit jeda agar animasi Splash terlihat
    await Future.delayed(const Duration(seconds: 2));

    try {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        // Validasi token dengan fetch data profil
        await _authService.getProfile();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        }
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      // Jika terjadi error (misalnya 401 Unauthenticated atau kendala jaringan)
      // Bersihkan token yang tidak valid dan arahkan ke Login
      await TokenStorage.clearToken();
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blob kiri atas
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Blob kanan bawah
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.18),
                            blurRadius: 35,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/hadir-logo.png",
                        width: 110,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Judul
                    Text(
                      "Hadir",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2B2B38),
                        letterSpacing: 1,
                      ),
                    ),

                    // const SizedBox(height: 10),

                    // // Tagline
                    // Text(
                    //   "Absensi Jadi Lebih Mudah",
                    //   style: GoogleFonts.plusJakartaSans(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //     color: const Color(0xFF7B7B88),
                    //   ),
                    // ),
                    const SizedBox(height: 70),

                    // Loading
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: primaryColor,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
