import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutter/database/preference_handler.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas6_slicingflutter.dart';

class InputInteraktif extends StatefulWidget {
  const InputInteraktif({super.key});

  @override
  State<InputInteraktif> createState() => _InputInteraktifState();
}

class _InputInteraktifState extends State<InputInteraktif> {
  //drawer
  String selectedMenu = "Syarat dan ketentuan";

  //variable inputWidget
  bool isChecked = false; //checkbox
  bool isOn = false; //switch
  String? selectedDropdown; //dropdown
  DateTime? selectedDate; //date picker
  TimeOfDay? selectedTime; //time picker

  //logout (tugas11flutterA)
  void _prosesLogout() async {
    await PreferenceHandler.logOut();
    if (!mounted) return;
    context.pushAndRemoveAll(SlicingFlutter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //jika switch on warna background menjadi gelap, jika off menjadi terang
      backgroundColor: isOn ? Colors.grey : Colors.white,

      //appbar
      appBar: AppBar(
        title: Text(
          "Input Interaktif",
          style: TextStyle(color: isOn ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        //jika switch on warna background menjadi gelap, jika off menjadi terang
        backgroundColor: isOn
            ? const Color.fromARGB(255, 11, 51, 85)
            : Colors.amber,
      ),

      //drawer
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("Drawer", style: TextStyle(fontSize: 20))),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text("Syarat & ketentuan"),
              onTap: () {
                setState(() {
                  selectedMenu = "Syarat dan ketentuan";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text("Mode Tampilan"),
              onTap: () {
                setState(() {
                  selectedMenu = "Mode Tampilan";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Kategori Produk"),
              onTap: () {
                setState(() {
                  selectedMenu = "Kategori Produk";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text("Pilih Tanggal"),
              onTap: () {
                setState(() {
                  selectedMenu = "Pilih Tanggal";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text("Atur Pengingat"),
              onTap: () {
                setState(() {
                  selectedMenu = "Atur Pengingat";
                });
                Navigator.pop(context);
              },
            ),
            //logout (tugas11flutterA)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                setState(() {
                  _prosesLogout();
                });
                Navigator.pop(context);
                // snackbar
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Berhasil Logout")));
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Syarat dan ketentuan (checkbox)
            if (selectedMenu == "Syarat dan ketentuan")
              syaratketentuanCheckbox(),
            //Mode tampilan (switch)
            if (selectedMenu == "Mode Tampilan") modetampilanSwitch(),
            //Kategori produk (dropdown)
            if (selectedMenu == "Kategori Produk") kategoriprodukDropdown(),
            //Pilih tanggal (date picker)
            if (selectedMenu == "Pilih Tanggal")
              pilihtanggalDatePicker(context),
            //Atur pengingat (time picker)
            if (selectedMenu == "Atur Pengingat")
              aturpengingatTimePicker(context),
          ],
        ),
      ),
    );
  }

  ///Syarat dan ketentuan (checkbox)
  Column syaratketentuanCheckbox() {
    return Column(
      children: [
        Text(
          "Saya menyetujui persyaratan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
        ),
        Text(
          isChecked
              ? "Pendaftaran diperbolehkan"
              : "Pendaftaran belum tersedia",
        ),
      ],
    );
  }

  ///Mode tampilan (switch)
  Column modetampilanSwitch() {
    return Column(
      children: [
        Text(
          "Aktifkan mode gelap",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Switch(
          value: isOn,
          onChanged: (bool? value) {
            setState(() {
              isOn = value ?? false;
            });
          },
        ),
      ],
    );
  }

  ///Kategori produk (dropdown)
  Column kategoriprodukDropdown() {
    return Column(
      children: [
        Text("Pilih kategori", style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedDropdown,
          hint: Text(
            "Pilih kategori",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          items: ["Elektronik", "Pakaian", "Makanan", "Lainnya"].map((
            String val,
          ) {
            return DropdownMenuItem(value: val, child: Text(val));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedDropdown = newValue;
            });
          },
        ),

        //Tampilkan hasil pilihan dalam teks
        Text("Anda memilih kategori: ${selectedDropdown ?? " "}"),
      ],
    );
  }

  ///Pilih tanggal (date picker)
  Column pilihtanggalDatePicker(BuildContext context) {
    return Column(
      children: [
        Text(
          "Pilih Tanggal Lahir",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1000),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });
            }
          },
          child: Text("Pilih tanggal"),
        ),
        //Tampilkan hasilnya dalam format: "Tanggal Lahir: DD-MM-YYYY"
        Text(
          "Tanggal lahir: ${DateFormat('dd-MM-yy').format(selectedDate ?? DateTime.now())}",
        ),
      ],
    );
  }

  ///Atur pengingat (time picker)
  Column aturpengingatTimePicker(BuildContext context) {
    return Column(
      children: [
        Text("Atur Pengingat", style: TextStyle(fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() {
                selectedTime = picked;
              });
            }
          },
          child: Text("Pilih jam"),
        ),
        //Tampilkan hasilnya dalam format: "Pengingat diatur pukul: HH:mm"
        Text(
          selectedTime == null
              ? "Pengingat belum diatur"
              : "Pengingat diatur pukul: ${selectedTime!.format(context)}",
        ),
      ],
    );
  }
}
