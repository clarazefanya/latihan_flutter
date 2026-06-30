import 'package:flutter/material.dart';
import 'package:latihan_flutter/day35/services/auth_service.dart';
import 'package:latihan_flutter/day35/services/dio_client.dart';
import 'package:latihan_flutter/day35/services/token_storage.dart';
import 'package:latihan_flutter/day35/views/dashboard_screen.dart';
import 'package:latihan_flutter/day35/views/login_screen.dart';

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
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
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
    const primaryColor = Color(0xFF8C52FF); // Lavender Purple
    const backgroundColor = Color(0xFFF9F8FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo App
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                size: 80.0,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              "ABSENSI PPKD B6",
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E3A),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 60.0),
            // Loading Spinner
            const CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}
