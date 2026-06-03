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

      body: FutureBuilder<List<UserModelSql>>(
        future: DBHelper().getAllUsers(),
        builder: (context, snapshot) {
          // Menampilkan indikator loading saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menangani jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //tombol update
                      IconButton(
                        onPressed: () {
                          _showBottomSheet(context, user);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      //tombol delete
                      IconButton(
                        onPressed: () async {
                          if (user.id != null) {
                            await DBHelper().deleteUser(user.id!);
                            if (context.mounted) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data berhasil dihapus'),
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  //function tombol update
  void _showBottomSheet(BuildContext context, UserModelSql user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(text: user.password);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Kelola Pengguna',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Update
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (user.id != null) {
                        final updatedUser = UserModelSql(
                          id: user.id,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text,
                          avatarIndex: user.avatarIndex,
                        );
                        bool success = await DBHelper().updateUser(updatedUser);
                        if (success && context.mounted) {
                          Navigator.pop(context);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data berhasil diperbarui'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
