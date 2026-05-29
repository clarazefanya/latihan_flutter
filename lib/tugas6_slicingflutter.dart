import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan_flutter/database/preference_handler.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas8flutter/tugas8flutter.dart';

class SlicingFlutter extends StatefulWidget {
  const SlicingFlutter({super.key});

  @override
  State<SlicingFlutter> createState() => _SlicingFlutterState();
}

class _SlicingFlutterState extends State<SlicingFlutter> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00224F),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            //login dan button back
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 2),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // height: 2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            //hello welcome back
            Text(
              "Hello Welcome Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Welcome back please\nsign in again",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 107),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //email textfield & password textfield
                    loginTxtField("Email", Icons.email),
                    SizedBox(height: 35),
                    loginTxtField("Password", Icons.lock),
                    SizedBox(height: 35),

                    //login button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 56),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          print("Sudah memenuhi syarat");
                          //tugas11flutterA: ubah status menjadi setLogin(true) lalu arahkan ke Home.
                          await PreferenceHandler.setLogin(true);
                          if (!mounted) return;
                          //ke halaman home
                          context.pushReplacement(BottomNavBar());
                        } else {
                          print("Belum memenuhi syarat");
                          //toast message
                          Fluttertoast.showToast(
                            msg: "Silakan periksa kembali",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          //snackbar
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text("Silakan periksa kembali")),
                          // );
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: const Color(0xFF00224F),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 56),

            //or
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: const Color(0xFF12325E),
                    thickness: 0.8,
                  ),
                ), //garis kiri

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "or",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),

                Expanded(
                  child: Divider(
                    color: const Color(0xFF12325E),
                    thickness: 0.8,
                  ),
                ), //garis kanan
              ],
            ),
            SizedBox(height: 21),

            //facebook button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF11325C),
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook, color: Colors.white),
                  SizedBox(width: 5),
                  Text("Facebook", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 14),

            //gmail button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF11325C),
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/iconGoogle.png"),
                  SizedBox(width: 5),
                  Text("Gmail", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 16),

            //already have an account
            Text.rich(
              TextSpan(
                text: "Already have an account?",
                style: TextStyle(fontSize: 12, color: Colors.white),
                children: [
                  TextSpan(
                    text: " Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decorationColor: Colors.blue,
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField loginTxtField(String hintTxt, IconData iconTxtField) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintTxt,
        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
        prefixIcon: Icon(iconTxtField, color: const Color(0xFFC4C4C4)),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF12325D)),
        ),
      ),
      validator: (value) {
        if (hintTxt == "Email") {
          if (value == null || value.isEmpty) {
            return "Email tidak boleh kosong";
          } else if (!value.contains('@')) {
            return "Format email tidak valid";
          }
        } else if (hintTxt == "Password") {
          if (value == null || value.isEmpty) {
            return "Password tidak boleh kosong";
          } else if (value.length < 6) {
            return "Password terlalu singkat";
          }
        }
        return null;
      },
    );
  }
}
