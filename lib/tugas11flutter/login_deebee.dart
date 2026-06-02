import 'package:flutter/material.dart';
import 'package:latihan_flutter/components/colors.dart';
import 'package:latihan_flutter/components/components.dart';
import 'package:latihan_flutter/database/db_helper.dart';
import 'package:latihan_flutter/database/preference_handler.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas11flutter/realtime_list.dart';
import 'package:latihan_flutter/tugas11flutter/register_deebee.dart';

class LoginDeeBee extends StatefulWidget {
  const LoginDeeBee({super.key});

  @override
  State<LoginDeeBee> createState() => _LoginDeeBeeState();
}

class _LoginDeeBeeState extends State<LoginDeeBee> {
  //validator form
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function button login
  void login() async {
    //jalankan validator Form
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    //panggil database helper, read
    final pengguna = await DBHelper().loginUser(
      emailController.text.trim(),
      passwordController.text,
    );

    //cek apakah widget masih terpasang (mounted) sebelum menggunakan context
    if (!mounted) return;

    //cek hasil login
    if (pengguna != null) {
      //LOGIN BERHASIL
      //ubah status menjadi setLogin(true), lanjut ke halaman realtime_list
      await PreferenceHandler.setLogin(true);
      if (!mounted) return;
      context.pushReplacement(RealTimeList());
    } else {
      //LOGIN GAGAL
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email atau password salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 118),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Image.asset(
                "assets/images/logodb-transparan.png",
                height: 128,
                width: 128,
              ),
              //nama app
              Text(
                "DeeBee",
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 24),

              //selamat datang
              Text(
                "Selamat Datang di DeeBee!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              //subtext masuk dan lanjutkan
              Text.rich(
                TextSpan(
                  text: "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.borderBrown,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " dan lanjutkan progres belajarmu.",
                      style: TextStyle(
                        color: AppColors.borderBrown,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              //input form login
              Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //email
                    Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.email_outlined,
                      hinttext: 'example@email.com',
                      textFieldCont: emailController,
                      textFieldVal: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email wajib diisi";
                        } else if (!value.contains('@')) {
                          return "Email harus mengandung '@'";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    //password
                    Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.lock_outline,
                      hinttext: 'Password',
                      isPassword: true,
                      textFieldCont: passwordController,
                      textFieldVal: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password wajib diisi";
                        } else if (value.length < 8) {
                          return "Password terlalu singkat";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    //button masuk
                    ButtonComponent(
                      text: "Masuk",
                      bgcolor: AppColors.primaryHoney,
                      onPressed: login,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              //belum punya akun?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.borderBrown,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(RegisterDeeBee());
                    },
                    child: Text(
                      "Daftar disini",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7C5800),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
