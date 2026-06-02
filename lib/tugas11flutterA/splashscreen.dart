import 'package:flutter/material.dart';
import 'package:latihan_flutter/database/preference_handler.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas11flutter/login_deebee.dart';
import 'package:latihan_flutter/tugas11flutter/realtime_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));
    bool isLogin = PreferenceHandler.isLogin;
    if (!mounted) return;

    if (isLogin) {
      context.pushReplacement(RealTimeList()); //halaman home
    } else {
      context.pushReplacement(LoginDeeBee()); //halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logodb.png"),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
