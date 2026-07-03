import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutter/tugas1516flutter/models/batch_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/training_response.dart';
import 'package:latihan_flutter/tugas1516flutter/services/auth_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';
import 'package:latihan_flutter/tugas1516flutter/services/token_storage.dart';
import 'package:latihan_flutter/tugas1516flutter/views/main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender; // "L" or "P"
  int? _selectedTrainingId;
  int? _selectedBatchId;

  bool _isLoading = false;
  bool _isLoadingDropdowns = true;
  bool _isObscure = true;

  List<TrainingModel> _trainings = [];
  List<BatchModel> _batches = [];

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _authService = AuthService(dio);
    _fetchDropdownData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchDropdownData() async {
    try {
      // Mengambil data pelatihan dan angkatan (batch) secara paralel
      final responses = await Future.wait([
        _authService.getTrainings(),
        _authService.getBatches(),
      ]);

      final trainingRes = responses[0] as TrainingResponse;
      final batchRes = responses[1] as BatchResponse;

      setState(() {
        _trainings = trainingRes.data ?? [];
        _batches = batchRes.data ?? [];
        _isLoadingDropdowns = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDropdowns = false;
      });
      _showErrorSnackBar("Gagal mengambil data pelatihan & angkatan: $e");
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null) {
      _showErrorSnackBar("Silakan pilih jenis kelamin Anda");
      return;
    }
    if (_selectedTrainingId == null) {
      _showErrorSnackBar("Silakan pilih pelatihan");
      return;
    }
    if (_selectedBatchId == null) {
      _showErrorSnackBar("Silakan pilih angkatan/batch");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.register({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "jenis_kelamin": _selectedGender,
        "profile_photo":
            "", // default kosong saat registrasi sesuai requirement
        "batch_id": _selectedBatchId,
        "training_id": _selectedTrainingId,
      });

      if (response.data != null && response.data!.token != null) {
        // Simpan token menggunakan TokenStorage (flutter_secure_storage)
        await TokenStorage.saveToken(response.data!.token!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? "Registrasi Berhasil!"),
              backgroundColor: const Color(0xFF00BFA5), // Soft teal
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Pindah ke Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        }
      } else {
        throw Exception("Token tidak ditemukan di response registrasi.");
      }
    } on DioException catch (e) {
      String errorMessage = "Gagal melakukan registrasi";
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
      appBar: AppBar(
        title: const Text(
          "Daftar Akun",
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
        child: _isLoadingDropdowns
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryColor),
                    SizedBox(height: 16.0),
                    Text(
                      "Memuat data pelatihan...",
                      style: TextStyle(color: Color(0xFF7E7E8F)),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Buat Akun Baru",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E2E3A),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      const Text(
                        "Lengkapi data diri Anda untuk memulai absensi",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF7E7E8F),
                        ),
                      ),
                      const SizedBox(height: 28.0),
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
                              // Name Input
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Nama Lengkap",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF7E7E8F),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
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
                                    return "Nama tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
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
                              const SizedBox(height: 20.0),
                              // Gender Selection (Radio Buttons)
                              const Text(
                                "Jenis Kelamin",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E2E3A),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedGender = 'L';
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 3.0,
                                          horizontal: 3.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedGender == 'L'
                                              ? primaryColor.withValues(
                                                  alpha: 0.08,
                                                )
                                              : const Color(0xFFF6F5FB),
                                          border: Border.all(
                                            color: _selectedGender == 'L'
                                                ? primaryColor
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: 'L',
                                              groupValue: _selectedGender,
                                              activeColor: primaryColor,
                                              onChanged: (val) {
                                                setState(() {
                                                  _selectedGender = val;
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Laki-laki",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF2E2E3A),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedGender = 'P';
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 3.0,
                                          horizontal: 3.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedGender == 'P'
                                              ? primaryColor.withValues(
                                                  alpha: 0.08,
                                                )
                                              : const Color(0xFFF6F5FB),
                                          border: Border.all(
                                            color: _selectedGender == 'P'
                                                ? primaryColor
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: 'P',
                                              groupValue: _selectedGender,
                                              activeColor: primaryColor,
                                              onChanged: (val) {
                                                setState(() {
                                                  _selectedGender = val;
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Perempuan",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF2E2E3A),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              // Training Dropdown
                              DropdownButtonFormField<int>(
                                initialValue: _selectedTrainingId,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: "Pilih Pelatihan",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF7E7E8F),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.school_outlined,
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
                                ),
                                items: _trainings.map((training) {
                                  return DropdownMenuItem<int>(
                                    value: training.id,
                                    child: Text(
                                      training.title ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTrainingId = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? "Pelatihan wajib dipilih"
                                    : null,
                              ),
                              const SizedBox(height: 16.0),
                              // Batch Dropdown
                              DropdownButtonFormField<int>(
                                initialValue: _selectedBatchId,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: "Pilih Angkatan / Batch",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF7E7E8F),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.groups_outlined,
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
                                ),
                                items: _batches.map((batch) {
                                  // Menggunakan title jika name kosong sebagai fallback
                                  final displayTitle =
                                      batch.batchKe ?? "Batch ${batch.id}";
                                  return DropdownMenuItem<int>(
                                    value: batch.id,
                                    child: Text(displayTitle),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBatchId = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? "Angkatan wajib dipilih"
                                    : null,
                              ),
                              const SizedBox(height: 32.0),
                              // Submit Register Button
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  elevation: 3.0,
                                  shadowColor: primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
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
                                        "Daftar",
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
                      const SizedBox(height: 32.0),
                      // Redirect to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah punya akun? ",
                            style: TextStyle(color: Color(0xFF7E7E8F)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Masuk Di Sini",
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
