import 'package:flutter/material.dart';

class ProfilSaya extends StatelessWidget {
  const ProfilSaya({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Saya"),
        backgroundColor: Colors.blue),
        
      body: Column(
        spacing: 5, //spasi antar baris
        children: [
          SizedBox(height: 5), //agar column tdk mepet AppBar

          //Nama Lengkap (Gunakan TextStyle dengan fontSize besar dan fontWeight tebal)
          Text("Clara Zefanya Putri Junaidi", 
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),

          //Row untuk menyandingkan Icon dengan nama kota tempat tinggal
          Row(
            mainAxisAlignment: MainAxisAlignment.center,  //row jadi center
            children: [
              Icon(Icons.location_on),
              Text("Jakarta Barat", 
              style: TextStyle(fontSize: 18)),
            ],
          ),

          //  Deskripsi singkat tentang diri Anda menggunakan Text
          //dengan ukuran font yang lebih kecil dan warna yang sedikit kontras (misal: abu-abu).
          Text("Peserta PPKD Jakarta Pusat dari kelas Mobile Programming (App Developer).",
            style: TextStyle(fontSize: 15, color: Colors.grey),
            textAlign: TextAlign.center) //text jadi center
        ],
      ),
    );
  }
}