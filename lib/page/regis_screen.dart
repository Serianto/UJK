import 'package:absensi/model/register_model.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class RegisScreen extends StatefulWidget {
  const RegisScreen({super.key});

  @override
  State<RegisScreen> createState() => _RegisScreenState();
}

class _RegisScreenState extends State<RegisScreen> {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: <Widget>[
        Lottie.asset('asset/daftar.json', fit: BoxFit.cover, repeat: true),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 12,
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Consumer<RegisterModel>(
                    builder: (context, registerProvider, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.app_registration, color: Colors.cyan, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Registrasi',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Nama
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Nama wajib diisi.' : null,
                          ),
                          const SizedBox(height: 12),

                          // Email
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Email wajib diisi.' : null,
                          ),
                          const SizedBox(height: 12),

                          // Password
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Password wajib diisi.' : null,
                          ),
                          const SizedBox(height: 20),

                          // Tombol Registrasi
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: registerProvider.isLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        registerProvider.register(
                                          context,
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: registerProvider.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Daftar',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),

                          // Error Message
                          if (registerProvider.errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                registerProvider.errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Sudah punya akun?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: dua,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: <Widget>[
  //         Lottie.asset(
  //           'asset/daftar.json',
  //         ),
  //         Center(
  //           child: SingleChildScrollView(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Card(
  //               elevation: 8,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0),
  //               ),
  //               color: const Color.fromARGB(255, 255, 255, 255),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Form(
  //                   key: formKey,
  //                   child: Consumer<RegisterModel>(
  //                     builder: (context, registerProvider, child) {
  //                       return Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //                           Text(
  //                             'Registrasi',
  //                             style: TextStyle(
  //                               fontSize: 24,
  //                               fontWeight: FontWeight.bold,
  //                               color: Color.fromARGB(255, 105, 200, 212),
  //                             ),
  //                           ),
  //                           SizedBox(height: 20),
  //                           TextFormField(
  //                             controller: nameController,
  //                             decoration: InputDecoration(
  //                               labelText: 'Nama',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                             validator: (value) {
  //                               if (value == null || value.isEmpty) {
  //                                 return 'Nama wajib diisi.';
  //                               }
  //                               return null;
  //                             },
  //                           ),
  //                           SizedBox(height: 10),
  //                           TextFormField(
  //                             controller: emailController,
  //                             decoration: InputDecoration(
  //                               labelText: 'Email',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                             validator: (value) {
  //                               if (value == null || value.isEmpty) {
  //                                 return 'Email wajib diisi.';
  //                               }
  //                               return null;
  //                             },
  //                           ),
  //                           SizedBox(height: 10),
  //                           TextFormField(
  //                             controller: passwordController,
  //                             decoration: InputDecoration(
  //                               labelText: 'Password',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                             obscureText: true,
  //                             validator: (value) {
  //                               if (value == null || value.isEmpty) {
  //                                 return 'Password wajib diisi.';
  //                               }
  //                               return null;
  //                             },
  //                           ),
  //                           SizedBox(height: 10),
  //                           ElevatedButton(
  //                             onPressed:
  //                                 registerProvider.isLoading
  //                                     ? null
  //                                     : () {
  //                                       if (formKey.currentState!.validate()) {
  //                                         registerProvider.register(
  //                                           context,
  //                                           nameController.text,
  //                                           emailController.text,
  //                                           passwordController.text,
  //                                         );
  //                                       }
  //                                     },
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: Colors.grey[200],
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: 40,
  //                                 vertical: 15,
  //                               ),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(30),
  //                               ),
  //                             ),
  //                             child:
  //                                 registerProvider.isLoading
  //                                     ? CircularProgressIndicator()
  //                                     : Text('Registrasi'),
  //                           ),
  //                           if (registerProvider.errorMessage.isNotEmpty)
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 8.0),
  //                               child: Text(
  //                                 registerProvider.errorMessage,
  //                                 style: TextStyle(color: Colors.red),
  //                               ),
  //                             ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}