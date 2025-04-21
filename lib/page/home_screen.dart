import 'dart:async';

import 'package:absensi/model/home_model.dart';
import 'package:absensi/page/save_page.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _timeString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeString = _formatDateTime(DateTime.now());
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeModel>(context, listen: false).fetchProfil(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Absensi')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<HomeModel>(
                builder: (context, homeModel, _) {
                  final profil = homeModel.profildata;
                  return UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: dua,
                      gradient: LinearGradient(
                        colors: [tujuh, lima],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    accountName: Text(
                      profil['name'] ?? 'Nama Pengguna',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      profil['email'] ?? 'email@domain.com',
                      style: const TextStyle(fontSize: 14),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: profil['photo'] != null
                          ? NetworkImage(profil['photo']) // URL dari API
                          : const AssetImage('asset/profil.png') as ImageProvider,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.pushNamed(context, '/users');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  //Navigator.pushNamed(context, routeName);
                },
              )
            ],
          ),
        ),
      body: Consumer<HomeModel>(
        builder: (context, homeModel, child) {
          if (homeModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (homeModel.errormessage.isNotEmpty) {
            return Center(child: Text('Error: ${homeModel.errormessage}'));
          }

          if (homeModel.profildata.isEmpty) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time_filled, size: 80, color: tiga),
                  const SizedBox(height: 20),
                  Text(
                    _timeString,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Halo, ${homeModel.profildata['name']}!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SavePage()));
                      },
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Absen'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: bg,
    );
  }
}