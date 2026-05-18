import 'package:flutter/material.dart';

class Tugas5 extends StatefulWidget {
  const Tugas5({super.key});

  @override
  State<Tugas5> createState() => _Tugas5State();
}

class _Tugas5State extends State<Tugas5> {
  bool elevButt = false;
  bool iconButt = false;
  bool textButt = false;
  bool contInkwell = false;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text("Interactive About Us"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //ElevatedButton
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  elevButt = !elevButt;
                  setState(() {});
                },
                child: Text("Klik Ini"),
              ),
              SizedBox(height: 10),
              Text(
                elevButt ? "Selamat Datang di DeeBee!" : " ",
                style: TextStyle(),
              ),

              //IconButton
              SizedBox(height: 20),
              Text(
                "Suka aplikasi ini? klik like di bawah ini",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      iconButt = !iconButt;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.thumb_up,
                      color: iconButt ? Colors.amber : Colors.grey,
                    ),
                  ),
                  Text(iconButt ? "Thank you!" : "< Klik icon ini"),
                ],
              ),

              //TextButton
              SizedBox(height: 30),
              Text(
                "Tentang Kami",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                textButt
                    ? "DeeBee adalah sebuah aplikasi belajar interaktif untuk mempelajari konsep database. Aplikasi ini menyediakan tantangan SQL yang dikemas dalam alur cerita yang menarik, sehingga proses belajar menjadi lebih interaktif dan menyenangkan. Pembelajaran dimulai dari materi dasar dan disusun secara bertahap, materi dikemas dalam bentuk level/chapter di mana setiap level berfokus pada topik SQL tertentu.\n"
                          "Dalam aplikasi, user berperan sebagai karyawan toko kelontong bernama DeeBee,  yang akan dipandu oleh karyawan senior (mentor) disana.\n"
                          "Manfaat yang didapat:\n"
                          "- Membantu memahami penerapan database dalam situasi nyata\n"
                          "- Latihan query SQL yang variatif dan bertahap\n"
                          "- Belajar SQL jadi lebih menarik dan tidak membosankan"
                    : "DeeBee adalah sebuah aplikasi belajar interaktif untuk mempelajari konsep database. Aplikasi ini...",
              ),
              TextButton(
                onPressed: () {
                  textButt = !textButt;
                  setState(() {});
                },
                child: Text(textButt ? "Sembunyikan" : "Selengkapnya"),
              ),

              //InkWell
              SizedBox(height: 30),
              InkWell(
                splashColor: Colors.red,
                onTap: () {
                  contInkwell = !contInkwell;
                  setState(() {});
                  print("HIDUP JOKOWI");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Text("Klik kotak ini"),
                ),
              ),
              SizedBox(height: 10),
              Text(
                contInkwell
                    ? "Terima kasih sudah memakai aplikasi DeeBee <3"
                    : " ",
              ),

              //GestureDetector
              SizedBox(height: 40),
              Text("Klik gambar di bawah ini"),
              GestureDetector(
                onTap: () {
                  counter++;
                  setState(() {});
                  print("Ditekan sekali");
                },
                onDoubleTap: () {
                  counter = counter + 2;
                  setState(() {});
                  print("Ditekan 2 kali");
                },
                onLongPress: () {
                  counter = counter + 3;
                  setState(() {});
                  print("Tahan lama");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/logodb.png", height: 200),
                ),
              ),
              Text("$counter", style: TextStyle(fontSize: 20)),
              Text("Tekan sekali: +1"),
              Text("Tekan dua kali: +2"),
              Text("Tekan lama: +3"),
              Text("Tekan floating button: -1"),
            ],
          ),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter--;
          setState(() {});
          print("Menekan floating button");
        },
        child: Icon(Icons.remove),
      ),
    );
  }
}
