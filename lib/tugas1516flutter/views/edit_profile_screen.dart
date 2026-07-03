import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latihan_flutter/tugas1516flutter/models/user_model.dart';
import 'package:latihan_flutter/tugas1516flutter/services/auth_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  File? _selectedImage;
  String? _base64Image;

  bool _isLoading = false;

  late final AuthService _authService;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    final dio = createDioClient();
    _authService = AuthService(dio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();

        // Dapatkan ekstensi file untuk mime type
        final extension = pickedFile.path.split('.').last.toLowerCase();
        final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

        setState(() {
          _selectedImage = file;
          _base64Image = "data:$mimeType;base64,${base64Encode(bytes)}";
        });
      }
    } catch (e) {
      _showErrorSnackBar("Gagal mengambil gambar: $e");
    }
  }

  void _showImagePickerOptions() {
    const primaryColor = Color(0xFF8C52FF);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Ubah Foto Profil",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E2E3A),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Kamera",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_library_outlined,
                              color: primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Galeri",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final futures = <Future>[];

      // Jika nama berubah, panggil updateProfile
      if (_nameController.text.trim() != widget.user.name) {
        futures.add(
          _authService.updateProfile({"name": _nameController.text.trim()}),
        );
      }

      // Jika foto profil diubah, panggil updateProfilePhoto
      if (_base64Image != null) {
        futures.add(
          _authService.updateProfilePhoto({"profile_photo": _base64Image}),
        );
      }

      if (futures.isNotEmpty) {
        await Future.wait(futures);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profil berhasil diperbarui!"),
              backgroundColor: Color(0xFF00BFA5),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Beri sinyal balik 'true' ke DashboardScreen untuk reload data
          Navigator.pop(context, true);
        }
      } else {
        // Tidak ada perubahan yang dilakukan
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      String errorMessage = "Gagal memperbarui profil";
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
        backgroundColor: const Color(0xFFFF5252),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getProfilePhotoUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    return "https://appabsensi.mobileprojp.com/$path";
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF);
    const backgroundColor = Color(0xFFF9F8FD);
    final currentPhotoUrl = _getProfilePhotoUrl(widget.user.profilePhoto);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
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
                const SizedBox(height: 20),
                // Foto Profil dengan Interaksi Ubah Gambar
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 64,
                          backgroundColor: primaryColor.withValues(alpha: 0.08),
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!) as ImageProvider
                              : (currentPhotoUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        currentPhotoUrl,
                                      )
                                    : null),
                          child:
                              _selectedImage == null && currentPhotoUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: primaryColor,
                                )
                              : null,
                        ),
                      ),
                      // Tombol ikon kamera di pojok kanan bawah
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                // Form Name Input
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Nama Lengkap",
                            labelStyle: const TextStyle(
                              color: Color(0xFF7E7E8F),
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
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
                        const SizedBox(height: 32.0),
                        // Save Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
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
                                  "Simpan Perubahan",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
