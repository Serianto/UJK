import 'package:absensi/model/edit_model.dart';
import 'package:absensi/model/home_model.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profil = Provider.of<HomeModel>(context, listen: false).profildata;
    _nameController.text = profil['name'] ?? '';
    _emailController.text = profil['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: dua,
        title: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<EditModel>(
            builder: (context, editProvider, child) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: dua.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.person_outline, size: 64, color: satu),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          labelStyle: TextStyle(color: dua),
                          filled: true,
                          fillColor: bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.person, color: satu),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: dua),
                          filled: true,
                          fillColor: bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.email, color: satu),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tiga,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: editProvider.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    editProvider.editProfile(
                                      context,
                                      _nameController.text,
                                      _emailController.text,
                                    );
                                  }
                                },
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (editProvider.isLoading)
                        const CircularProgressIndicator(color: satu),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
// class EditScreen extends StatefulWidget {
//   const EditScreen({super.key});

//   @override
//   State<EditScreen> createState() => _EditScreenState();
// }

// class _EditScreenState extends State<EditScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bg,
//       appBar: AppBar(
//         backgroundColor: dua,
//         title: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Consumer<EditModel>(
//             builder: (context, editProfileProvider, child) {
//               return Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: [
//                       BoxShadow(
//                         color: dua.withOpacity(0.2),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       const Icon(Icons.person_outline, size: 64, color: satu),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Nama Lengkap',
//                           labelStyle: TextStyle(color: dua),
//                           filled: true,
//                           fillColor: bg,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: const BorderSide(color: dua),
//                           ),
//                           prefixIcon: const Icon(Icons.person, color: satu),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Nama wajib diisi.';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           labelStyle: TextStyle(color: dua),
//                           filled: true,
//                           fillColor: bg,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           prefixIcon: const Icon(Icons.email, color: satu),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Email wajib diisi.';
//                           }
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
//                             return 'Format email tidak valid.';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: tiga,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: editProfileProvider.isLoading
//                               ? null
//                               : () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     final success = await editProfileProvider.editProfile(
//                                       context,
//                                       _nameController.text,
//                                       _emailController.text,
//                                     );

//                                     showDialog(
//                                       context: context,
//                                       builder: (_) => AlertDialog(
//                                         title: Text('Berhasil'),
//                                         content: Text(editProfileProvider.message),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context); // close dialog
//                                               if (success) {
//                                                 Navigator.pushNamedAndRemoveUntil(
//                                                   context,
//                                                   '/login',
//                                                   (route) => false,
//                                                 );
//                                               }
//                                             },
//                                             child: const Text('OK'),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 },
//                           icon: const Icon(Icons.save),
//                           label: const Text('Simpan'),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       if (editProfileProvider.isLoading)
//                         const CircularProgressIndicator(color: satu),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
// class EditScreen extends StatefulWidget {
//   const EditScreen({super.key});

//   @override
//   State<EditScreen> createState() => _EditScreenState();
// }

// class _EditScreenState extends State<EditScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: bg,
//     appBar: AppBar(
//       backgroundColor: dua,
//       title: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
//       iconTheme: const IconThemeData(color: Colors.white),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Consumer<EditModel>(
//           builder: (context, editProfileProvider, child) {
//             return Center(
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: dua.withOpacity(0.2),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     const Icon(Icons.person_outline, size: 64, color: satu),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Nama Lengkap',
//                         labelStyle: TextStyle(color: dua),
//                         filled: true,
//                         fillColor: bg,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide: const BorderSide(color: dua),
//                         ),
//                         prefixIcon: const Icon(Icons.person, color: satu),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Nama wajib diisi.';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: tiga,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: editProfileProvider.isLoading
//                             ? null
//                             : () {
//                                 if (_formKey.currentState!.validate()) {
//                                   editProfileProvider.editProfile(
//                                     context,
//                                     _nameController.text,
//                                   );
//                                 }
//                               },
//                         icon: const Icon(Icons.save),
//                         label: const Text('Simpan'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     if (editProfileProvider.isLoading)
//                       const CircularProgressIndicator(color: satu),
//                     if (editProfileProvider.message.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         // child: Text(
//                         //   editProfileProvider.message,
//                         //   style: TextStyle(
//                         //     color: editProfileProvider.message.toLowerCase().contains('berhasil mengubah nama, silahkan login ulang :)') ? empat : tujuh,
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         //   textAlign: TextAlign.center,
//                         // ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     ),
//   );
// }
// }