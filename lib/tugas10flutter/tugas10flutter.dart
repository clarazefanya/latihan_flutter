import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas10flutter/halaman_konfirmasi.dart';

class Tugas10Pendaftaran extends StatefulWidget {
  const Tugas10Pendaftaran({super.key});

  @override
  State<Tugas10Pendaftaran> createState() => _Tugas10State();
}

class _Tugas10State extends State<Tugas10Pendaftaran> {
  //global key: kunci untuk mengakses dan memvalidasi
  final _formKey = GlobalKey<FormState>();
  //variabel controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController kotaAsalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00224F),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            //tulisan sign up
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            //hello, please sign up
            Text(
              "Hello!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Please sign up",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 107),

            //form textfield
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //nama lengkap
                    loginTxtField(
                      hintTxt: "Nama Lengkap",
                      iconTxtField: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama lengkap wajib diisi";
                        }
                        return null;
                      },
                      controller: nameController,
                    ),
                    SizedBox(height: 35),

                    //email
                    loginTxtField(
                      hintTxt: "Email",
                      iconTxtField: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email wajib diisi";
                        } else if (!value.contains('@')) {
                          return "Email harus mengandung karakter @";
                        }
                        return null;
                      },
                      controller: emailController,
                    ),
                    SizedBox(height: 35),

                    //nomor HP
                    loginTxtField(
                      hintTxt: "Nomor HP (Opsional)",
                      iconTxtField: Icons.phone,
                      validator: (value) {
                        return null;
                      },
                      controller: phoneController,
                    ),
                    SizedBox(height: 35),

                    //data tambahan (kota asal)
                    loginTxtField(
                      hintTxt: "Kota Asal",
                      iconTxtField: Icons.place,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kota asal wajib diisi";
                        }
                        return null;
                      },
                      controller: kotaAsalController,
                    ),
                    SizedBox(height: 35),

                    //daftar button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 56),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //valid
                          //tampilkan AlertDialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Berhasil"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berhasil membuat akun."),
                                  SizedBox(height: 10),
                                  Text("Nama Lengkap: ${nameController.text}"),
                                  Text("Email: ${emailController.text}"),
                                  Text(
                                    "Nomor HP: ${phoneController.text.isEmpty ? "-" : phoneController.text}",
                                  ),
                                  Text("Kota asal: ${kotaAsalController.text}"),
                                ],
                              ),
                              actions: [
                                //ke halaman konfirmasi
                                TextButton(
                                  onPressed: () => context.pushAndRemoveAll(
                                    HalamanKonfirmasi(
                                      namaLengkap: nameController.text,
                                      kotaAsal: kotaAsalController.text,
                                    ),
                                  ),
                                  child: Text("Lanjut"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          //tidak valid
                          //tampilkan toast message
                          Fluttertoast.showToast(
                            msg: "Silakan periksa kembali",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text(
                        "Daftar",
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

  //reusable textfield
  TextFormField loginTxtField({
    required String hintTxt,
    required IconData iconTxtField,
    required String? Function(String?)? validator,
    required TextEditingController controller,
  }) {
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
      validator: validator,
      controller: controller,
    );
  }
}
