import 'dart:async';

import 'package:absensi/handler/widget.dart';
import 'package:absensi/model/home_model.dart';
import 'package:absensi/page/history_screen.dart';
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
  final String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());
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
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Consumer<HomeModel>(
              builder: (context, homeModel, _) {
                final profil = homeModel.profildata;
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [satu, enam],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  accountName: Text(
                    profil['name'] ?? 'Nama Pengguna',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  accountEmail: Text(
                    profil['email'] ?? 'email@domain.com',
                    style: const TextStyle(fontSize: 14),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 30,
                    backgroundImage: profil['photo'] != null
                        ? NetworkImage(profil['photo'])
                        : const AssetImage('asset/profil.png') as ImageProvider,
                  ),
                );
              },
            ),

            // Menu-item
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItem(
                    icon: Icons.person,
                    title: 'Profil',
                    onTap: () {
                      Navigator.pushNamed(context, '/users');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.history,
                    title: 'History',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );
                    },
                  ),
                  const Divider(thickness: 1, indent: 16, endIndent: 16),
                  DrawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                  ),
                ],
              ),
            ),
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

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_filled, size: 80, color: tiga),
                        const SizedBox(height: 16),
                        Text(
                          _timeString,
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Halo, ${homeModel.profildata['name']}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SavePage()));
                            },
                            icon: const Icon(Icons.fingerprint, size: 20),
                            label: const Text('Absen'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: satu,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: satu.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: bg,
    );
  }
}