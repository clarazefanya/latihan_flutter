import 'package:flutter/material.dart';
import 'package:latihan_flutter/tugas1516flutter/views/history_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/home_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/izin_screen.dart';
import 'package:latihan_flutter/tugas1516flutter/views/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // List halaman yang diakses lewat Bottom Navigation Bar
  late final List<Widget> _pages;

  final homeKey = GlobalKey<HomeScreenState>();
  final historyKey = GlobalKey<HistoryScreenState>();

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(key: homeKey),
      HistoryScreen(key: historyKey),
      const IzinScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF); // Lavender Purple
    const unselectedColor = Color(0xFF7E7E8F);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 0) {
              homeKey.currentState?.loadDashboardData();
            }

            if (index == 1) {
              historyKey.currentState?.fetchFullHistory();
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: unselectedColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history_rounded),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quick_contacts_mail_outlined),
              activeIcon: Icon(Icons.quick_contacts_mail_rounded),
              label: 'Izin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
