import 'package:flutter/material.dart';

class HalamanKonfirmasi extends StatefulWidget {
  final String namaLengkap;
  final String kotaAsal;

  //menerima data dari halaman sebelumnya
  const HalamanKonfirmasi({
    super.key,
    required this.namaLengkap,
    required this.kotaAsal,
  });

  @override
  State<HalamanKonfirmasi> createState() => _HalamanKonfirmasiState();
}

class _HalamanKonfirmasiState extends State<HalamanKonfirmasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Konfirmasi")),
      body: Center(
        child: Text(
          "Terima kasih, ${widget.namaLengkap} dari ${widget.kotaAsal} telah mendaftar.",
        ),
      ),
    );
  }
}
