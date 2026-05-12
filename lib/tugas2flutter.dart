import 'package:flutter/material.dart';

class ProfilLengkap extends StatelessWidget {
  const ProfilLengkap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Header (AppBar)
      appBar: AppBar(
        title: Text("Profil Saya"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          // 2. Identitas Utama
          SizedBox(height: 10),
          Center(
            child: Text("Clara Zefanya Putri Junaidi", 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ))
          ),

          // 3. Detail Kontak (email)
          // Container, padding, column, row berisi Icon dan Text, SizedBox sbg jarak
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 5),
                      Text("myemail@gmail.com")
                    ],
                  ),
                  SizedBox(height: 5),

                  // 4. Informasi Pendukung (jumlah modul selesai, streak)
                  Row(
                    children: [
                      Icon(Icons.book),
                      SizedBox(width: 3),
                      Text("3 Modul Selesai"),
                      Spacer(),
                      Icon(Icons.fireplace),
                      SizedBox(width: 5),
                      Text("5 Hari Streak")
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          
          // 5. Statistik Horizontal (jumlah level selesai, XP)
          // Setiap Container dibungkus dengan Expanded
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Text("Level Selesai"),
                      SizedBox(height: 3),
                      Text("30")
                    ]
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Text("XP"),
                      SizedBox(height: 3),
                      Text("1000")
                    ]
                  ),
                ),
              ),
            ],
          ),

          // 6. Deskripsi Naratif
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Sedang mempelajari SQL dan PostgreSQL melalui latihan interaktif, quiz, dan simulasi query untuk meningkatkan kemampuan database development."),
          ),

          // 7. Visual Branding (logo app)
          SizedBox(height: 50),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logodb.png")
              )
            )
          )

        ],
      ),
    );
  }
}
