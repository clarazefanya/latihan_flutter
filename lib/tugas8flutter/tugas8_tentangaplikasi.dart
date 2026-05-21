import 'package:flutter/material.dart';

class TentangAplikasi extends StatefulWidget {
  const TentangAplikasi({super.key});

  @override
  State<TentangAplikasi> createState() => _TentangAplikasiState();
}

class _TentangAplikasiState extends State<TentangAplikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Text("Tentang Aplikasi"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            children: [
            Image.asset("assets/images/logodb.png"),
            Text("DeeBee adalah sebuah aplikasi belajar interaktif untuk mempelajari konsep database. Aplikasi ini menyediakan tantangan SQL yang dikemas dalam alur cerita yang menarik, sehingga proses belajar menjadi lebih interaktif dan menyenangkan. Pembelajaran dimulai dari materi dasar dan disusun secara bertahap, materi dikemas dalam bentuk level/chapter di mana setiap level berfokus pada topik SQL tertentu. Dalam aplikasi, user berperan sebagai karyawan toko kelontong bernama DeeBee,  yang akan dipandu oleh karyawan senior (mentor) disana.", textAlign: TextAlign.justify),
            SizedBox(height: 20),
            Text("Dibuat Oleh: Clara Zefanya Putri Junaidi"),
            SizedBox(height: 20),
            Text("Versi Aplikasi: 1.0.0")
          ],),
        ),
      ),

    );
  }
}