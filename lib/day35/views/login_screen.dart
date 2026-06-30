import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutter/day35/services/auth_service.dart';
import 'package:latihan_flutter/day35/services/dio_client.dart';
import 'package:latihan_flutter/day35/services/token_storage.dart';
import 'package:latihan_flutter/day35/views/dashboard_screen.dart';
import 'package:latihan_flutter/day35/views/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscure = true;

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _authService = AuthService(dio);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login({
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      });

      if (response.data != null && response.data!.token != null) {
        // Simpan token menggunakan TokenStorage (flutter_secure_storage)
        await TokenStorage.saveToken(response.data!.token!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? "Login Berhasil!"),
              backgroundColor: const Color(0xFF00BFA5), // Soft teal
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Pindah ke halaman Dashboard dan bersihkan stack navigasi
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      } else {
        throw Exception("Token tidak ditemukan di response.");
      }
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan koneksi";
      if (e.response != null && e.response!.data != null) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF5252), // Soft Red
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF); // Lavender Purple
    const accentColor = Color(0xFF7B2CBF); // Darker Lavender
    const backgroundColor = Color(0xFFF9F8FD); // Very light lavender-grey

    return Scaffold(
      backgroundColor: backgroundColor,
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
                const SizedBox(height: 60.0),
                // Logo & Header Section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_person_outlined,
                      size: 64.0,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  "Selamat Datang!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E2E3A),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Silakan masuk untuk melanjutkan ke akun Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Color(0xFF7E7E8F)),
                ),
                const SizedBox(height: 48.0),
                // Form Card
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Input
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: const TextStyle(
                              color: Color(0xFF7E7E8F),
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: primaryColor,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF6F5FB),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF5252),
                                width: 1.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF5252),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            final emailRegExp = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegExp.hasMatch(value.trim())) {
                              return "Masukkan format email yang valid";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Password Input
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(
                              color: Color(0xFF7E7E8F),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: primaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF7E7E8F),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF6F5FB),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF5252),
                                width: 1.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF5252),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.length < 8) {
                              return "Password minimal 8 karakter";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32.0),
                        // Submit Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            elevation: 3.0,
                            shadowColor: primaryColor.withValues(alpha: 0.3),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36.0),
                // Sign Up Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum punya akun? ",
                      style: TextStyle(color: Color(0xFF7E7E8F)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
