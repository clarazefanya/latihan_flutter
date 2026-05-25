import 'package:flutter/material.dart';
import 'package:latihan_flutter/tugas9flutter/tugas9_data.dart';

class DataDinamis extends StatefulWidget {
  const DataDinamis({super.key});

  @override
  State<DataDinamis> createState() => _DataDinamisState();
}

class _DataDinamisState extends State<DataDinamis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Katalog Kategori Toko"),
        backgroundColor: Colors.lightBlue,
      ),

      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          //level 1
          Text(
            "Level 1: Pendekatan List Sederhana",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 4, 48, 71),
            ),
          ),
          SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: kategori.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(kategori[index]));
            },
          ),

          //level 2
          Text(
            "Level 2: Pendekatan List of Map",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 4, 48, 71),
            ),
          ),
          SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: kategoriMap.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: kategoriMap[index]["icon"],
                title: Text(kategoriMap[index]["nama"]),
              );
            },
          ),

          //level 3
          Text(
            "Level 3: Pendekatan Model (Professional Level)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 4, 48, 71),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: daftarProduk.length,
            itemBuilder: (context, index) {
              final data =
                  daftarProduk[index]; //bikin variable "data" utk memudahkan pemanggilan
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      //variable "data" dipanggil disini
                      Text(
                        data.nama,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Image.network(data.gambar),
                      SizedBox(height: 10),
                      Text(data.deskripsi),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
