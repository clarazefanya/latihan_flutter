import 'package:flutter/material.dart';
import 'package:latihan_flutter/tugas7flutter.dart';
import 'package:latihan_flutter/tugas8flutter/tugas8_tentangaplikasi.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  //variabel untuk melacak tab mana yg sedang aktif
  int _currentIndex = 0;

  //list of widgets untuk menampung tampilan
  static const List<Widget> _pages = <Widget>[
    InputInteraktif(),
    TentangAplikasi()
  ];

  //mengubah value _currentIndex ketika tab diklik
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),

      //panggil navbar di dalam body
      body: Center(child: _pages.elementAt(_currentIndex)),


    );
  }
}