//level 1
import 'package:flutter/material.dart';

List<String> kategori = [
  "Buah-buahan",
  "Sayuran",
  "Elektronik",
  "Pakaian Pria",
  "Pakaian Wanita",
  "Alat Tulis Kantor",
  "Buku & Majalah",
  "Peralatan Dapur",
  "Makanan Ringan",
  "Minuman",
  "Mainan Anak",
  "Peralatan Olahraga",
  "Produk Kesehatan",
  "Kosmetik",
  "Obat-obatan",
  "Aksesoris Mobil",
  "Perabot Rumah",
  "Sepatu & Sandal",
  "Barang Bekas",
  "Voucher & Tiket",
];

//level 2
List<Map<String, dynamic>> kategoriMap = [
  {"nama": "Buah-buahan", "icon": Icon(Icons.apple)},
  {"nama": "Sayuran", "icon": Icon(Icons.eco)},
  {"nama": "Elektronik", "icon": Icon(Icons.devices)},
  {"nama": "Pakaian Pria", "icon": Icon(Icons.checkroom)},
  {"nama": "Pakaian Wanita", "icon": Icon(Icons.dry_cleaning)},
  {"nama": "Alat Tulis Kantor", "icon": Icon(Icons.edit)},
  {"nama": "Buku & Majalah", "icon": Icon(Icons.menu_book)},
  {"nama": "Peralatan Dapur", "icon": Icon(Icons.kitchen)},
  {"nama": "Makanan Ringan", "icon": Icon(Icons.fastfood)},
  {"nama": "Minuman", "icon": Icon(Icons.local_drink)},
  {"nama": "Mainan Anak", "icon": Icon(Icons.toys)},
  {"nama": "Peralatan Olahraga", "icon": Icon(Icons.sports_soccer)},
  {"nama": "Produk Kesehatan", "icon": Icon(Icons.health_and_safety)},
  {"nama": "Kosmetik", "icon": Icon(Icons.face)},
  {"nama": "Obat-obatan", "icon": Icon(Icons.medication)},
  {"nama": "Aksesoris Mobil", "icon": Icon(Icons.directions_car)},
  {"nama": "Perabot Rumah", "icon": Icon(Icons.chair)},
  {"nama": "Sepatu & Sandal", "icon": Icon(Icons.hiking)},
  {"nama": "Barang Bekas", "icon": Icon(Icons.recycling)},
  {"nama": "Voucher & Tiket", "icon": Icon(Icons.confirmation_number)},
];

//level 3
class Produk {
  final String nama;
  final String gambar;
  final String deskripsi;

  Produk({required this.nama, required this.gambar, required this.deskripsi});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      nama: json['nama'],
      gambar: json['gambar'],
      deskripsi: json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'gambar': gambar, 'deskripsi': deskripsi};
  }
}

List<Produk> daftarProduk = [
  Produk(
    nama: "Atomic Habits",
    gambar: "https://cdn.gramedia.com/uploads/items/9780735211292.jpg",
    deskripsi:
        "Buku pengembangan diri tentang membangun kebiasaan kecil yang berdampak besar.",
  ),

  Produk(
    nama: "Majalah National Geographic",
    gambar: "https://cdn.gramedia.com/uploads/products/2-e6eng4e9.jpg",
    deskripsi:
        "Majalah berisi artikel, fotografi, dan pengetahuan tentang alam dan dunia.",
  ),

  Produk(
    nama: "Laskar Pelangi",
    gambar:
        "https://upload.wikimedia.org/wikipedia/id/thumb/8/8e/Laskar_pelangi_sampul.jpg/250px-Laskar_pelangi_sampul.jpg",
    deskripsi:
        "Novel karya Andrea Hirata tentang perjuangan pendidikan anak-anak Belitung.",
  ),

  Produk(
    nama: "Bumi",
    gambar: "https://www.gramedia.com/blog/content/images/2025/01/Bumi.png",
    deskripsi:
        "Novel fantasi karya Tere Liye mengenai petualangan di dunia paralel.",
  ),

  Produk(
    nama: "Majalah Bobo",
    gambar:
        "https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,f_auto,q_auto:best,w_640/v1634025439/01h4qywszfhzem8t3k79s6azz7.jpg",
    deskripsi:
        "Majalah anak berisi cerita, permainan, dan pengetahuan edukatif.",
  ),

  Produk(
    nama: "Rich Dad Poor Dad",
    gambar:
        "https://image.gramedia.net/rs:fit:0:0/plain/https://cdn.gramedia.com/uploads/items/9786020333175_rich-dad-poor-dad-_edisi-revisi_.jpg",
    deskripsi:
        "Buku finansial karya Robert Kiyosaki tentang cara memahami pengelolaan uang.",
  ),

  Produk(
    nama: "Harry Potter",
    gambar:
        "https://cdn.gramedia.com/uploads/items/9786020337647_harry-potter-dan-batu-bertuah-cover-baru.jpg",
    deskripsi: "Novel fantasi tentang petualangan penyihir muda di Hogwarts.",
  ),

  Produk(
    nama: "Majalah Tempo",
    gambar:
        "https://upload.wikimedia.org/wikipedia/id/3/3c/SampulMajalahTempo.jpg",
    deskripsi:
        "Majalah berita dan analisis mengenai isu politik, ekonomi, dan sosial.",
  ),

  Produk(
    nama: "Dilan 1990",
    gambar:
        "https://perpustakaan.jakarta.go.id/catalog-dispusip/uploaded_files/sampul_koleksi/original/Monograf/98364.jpg",
    deskripsi:
        "Novel remaja populer karya Pidi Baiq tentang kisah cinta masa sekolah.",
  ),

  Produk(
    nama: "Ensiklopedia Hewan",
    gambar:
        "https://cdn.gramedia.com/uploads/picture_meta/2022/11/29/qgrpw5q8yylslxzdzvmofq.jpeg",
    deskripsi:
        "Buku pengetahuan berisi informasi berbagai jenis hewan dari seluruh dunia.",
  ),
];
