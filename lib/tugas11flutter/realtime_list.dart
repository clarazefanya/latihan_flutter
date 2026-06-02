import 'package:flutter/material.dart';
import 'package:latihan_flutter/database/db_helper.dart';
import 'package:latihan_flutter/database/preference_handler.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/models/user_model_sql.dart';
import 'package:latihan_flutter/tugas11flutter/login_deebee.dart';
import 'package:latihan_flutter/tugas11flutter/register_deebee.dart';

class RealTimeList extends StatefulWidget {
  const RealTimeList({super.key});

  @override
  State<RealTimeList> createState() => _RealTimeListState();
}

class _RealTimeListState extends State<RealTimeList> {
  //logout
  void _prosesLogout() async {
    await PreferenceHandler.logOut();
    if (!mounted) return;
    context.pushAndRemoveAll(LoginDeeBee());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pengguna"),
        //tombol logout
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _prosesLogout();
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Berhasil Logout")));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Expanded(
        child: FutureBuilder<List<UserModelSql>>(
          future: DBHelper().getAllUsers(),
          builder: (context, snapshot) {
            // Menampilkan indikator loading saat menunggu data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Menangani jika terjadi error
            if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            }

            // Menangani jika data kosong atau tidak ada data
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data pengguna.'));
            }

            // Jika data berhasil didapatkan
            final daftarPengguna = snapshot.data!;

            return ListView.builder(
              itemCount: daftarPengguna.length,
              itemBuilder: (context, index) {
                final user = daftarPengguna[index];
                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(avatars[user.avatarIndex]),
                    ),
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user.email}'),
                        Text('Password: ${user.password}'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
