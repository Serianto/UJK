import 'package:absensi/page/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:absensi/model/profil_model.dart';
import 'package:provider/provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
    // final AuthService _authservice = AuthService();
    // Map<String, dynamic> _profildata = {};
    // bool _isLoading = true;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<ProfilModel>(context, listen:false).fetchProfile(context);
    });
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Profil'),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    ),
    body: Consumer<ProfilModel>(
      builder: (context, profilModel, child) {
        if (profilModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profilModel.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${profilModel.errorMessage}'));
        }

        if (profilModel.profileData.isEmpty) {
          return const Center(child: Text('Data profil tidak tersedia.'));
        }

        final profile = profilModel.profileData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                // Foto profil
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profile['photo'] != null
                      ? NetworkImage(profile['photo'])
                      : const AssetImage('asset/profil.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 16),

                // Nama dan Email
                Text(
                  profile['name'] ?? 'Nama tidak tersedia',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  profile['email'] ?? 'Email tidak tersedia',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 30),

                // Tombol Edit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
}