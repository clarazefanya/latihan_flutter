import 'package:flutter/material.dart';

class CreateSceneLevel extends StatelessWidget {
  const CreateSceneLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Scene Level", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text("Level: 1"),
            Text("Scene: 6"),
            SizedBox(height: 10),
            Text(
              "* wajib diisi",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            //Formulir Pengguna
            Row(
              children: [
                Text(
                  "Tipe Soal (Pilihan Ganda/Susun Kata/Tulis Query)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(" *", style: TextStyle(color: Colors.red)),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Tuliskan tipe soal",
                prefixIcon: Icon(Icons.task),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Text("Soal", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(" *", style: TextStyle(color: Colors.red)),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Tuliskan soal",
                prefixIcon: Icon(Icons.question_mark),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),

            Text(
              "Jawaban (Isi sesuai tipe soal)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text("Untuk Pilihan Ganda", style: TextStyle(fontSize: 13)),
            Row(
              children: [
                Text("A."),
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.abc),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text("B."),
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.abc),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text("C."),
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.abc),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Text(
              "Untuk Susun Kata dan Tulis Query",
              style: TextStyle(fontSize: 13),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            //daftar item (ListTile)
            Text("Daftar Scene", style: TextStyle(fontWeight: FontWeight.bold)),
            listTileScene(5, "Tulis Query"),
            listTileScene(4, "Tulis Query"),
            listTileScene(3, "Susun Kata"),
            listTileScene(2, "Susun Kata"),
            listTileScene(1, "Pilihan Ganda"),
          ],
        ),
      ),
    );
  }

  Container listTileScene(int scene, String tipeSoal) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.movie, color: Colors.amber),
        title: Text("Scene $scene"),
        subtitle: Text("Tipe Soal: $tipeSoal"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
