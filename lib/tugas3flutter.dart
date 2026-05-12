import 'package:flutter/material.dart';

class RegistrasidanGaleri extends StatelessWidget {
  const RegistrasidanGaleri({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text("Registrasi dan Galeri", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      //Bungkus seluruh Column utama dengan SingleChildScrollView
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Formulir Input Data
              Text(
                "Nama",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Contoh: emailkamu@gmail.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Minimal 8 digit",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Konfirmasi Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Konfirmasi Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 50),

              //Galeri Grid
              Text(
                "Galeri",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  //Di dalam setiap kotak Grid, gunakan widget Stack.
                  stackGrid("Selamat datang di DeeBee!"),
                  stackGrid("Tentang Kami"),
                  stackGrid("Intro: Apa itu Database?"),
                  stackGrid("Info: Jenis-jenis Database"),
                  stackGrid("DeeBee won Best App 2027 Awards"),
                  stackGrid("DeeBee Moments"),
                  stackGrid("DeeBee Community 2025"),
                  stackGrid("DeeBee Communnity 2026"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container stackGrid(String text) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Image.asset("assets/images/logodb-transparan.png", fit: BoxFit.fill),
          Container(
            width: double.infinity,
            color: Colors.white.withValues(alpha: 0.8),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
