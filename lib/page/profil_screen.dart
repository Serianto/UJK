import 'package:absensi/page/edit_screen.dart';
import 'package:absensi/utils/color.dart';
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
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
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
                  // Avatar dengan Border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profile['photo'] != null
                          ? NetworkImage(profile['photo'])
                          : const AssetImage('asset/profil.png') as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama dan Email
                  Text(
                    profile['name'] ?? 'Nama tidak tersedia',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile['email'] ?? 'Email tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Card Informasi Profil
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.teal),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  profile['name'] ?? 'Tidak tersedia',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.teal),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  profile['email'] ?? 'Tidak tersedia',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Edit dengan Animasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text(
                        'Edit Profil',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                        shadowColor: Colors.tealAccent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditScreen(),
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
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Profil'),
//       centerTitle: true,
//       backgroundColor: bg,
//     ),
//     body: Consumer<ProfilModel>(
//       builder: (context, profilModel, child) {
//         if (profilModel.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (profilModel.errorMessage.isNotEmpty) {
//           return Center(child: Text('Error: ${profilModel.errorMessage}'));
//         }

//         if (profilModel.profileData.isEmpty) {
//           return const Center(child: Text('Data profil tidak tersedia.'));
//         }

//         final profile = profilModel.profileData;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Center(
//             child: Column(
//               children: [
//                 // Foto profil
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage: profile['photo'] != null
//                       ? NetworkImage(profile['photo'])
//                       : const AssetImage('asset/profil.png')
//                           as ImageProvider,
//                 ),
//                 const SizedBox(height: 16),

//                 // Nama dan Email
//                 Text(
//                   profile['name'] ?? 'Nama tidak tersedia',
//                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   profile['email'] ?? 'Email tidak tersedia',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 20),
//                 const SizedBox(height: 30),

//                 // Tombol Edit
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.edit),
//                     label: const Text('Edit Profil'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: enam,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
}