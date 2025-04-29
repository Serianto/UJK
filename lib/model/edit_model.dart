import 'package:absensi/handler/user.dart';
import 'package:absensi/model/home_model.dart';
import 'package:absensi/model/profil_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditModel with ChangeNotifier {
    final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _message = '';

  bool get isLoading => _isLoading;
  String get message => _message;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  Future<void> editProfile(BuildContext context, String name, String email) async {
  setLoading(true);
  try {
    final response = await _authService.updateProfile(name, email);
    setMessage(response['message']);

    if (response['message'].toLowerCase().contains('berhasil')) {
      await Provider.of<ProfilModel>(context, listen: false).fetchProfile(context);
      await Provider.of<HomeModel>(context, listen: false).fetchProfil(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Profil berhasil diubah, silakan login ulang."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  } catch (e) {
    setMessage('Gagal memperbarui profil: $e');
  } finally {
    setLoading(false);
  }
}

  // Future<bool> editProfile(BuildContext context, String name, String email) async {
  //   setLoading(true);
  //   try {
  //     final response = await _authService.updateProfile(name, email);
  //     setMessage(response['message']);

  //     if (response['message'] == '') {
  //       // Refresh profil
  //       await Provider.of<ProfilModel>(context, listen: false).fetchProfile(context);
  //       await Provider.of<HomeModel>(context, listen: false).fetchProfil(context);
  //       return true; // Berhasil
  //     }
  //   } catch (e) {
  //     setMessage('Gagal memperbarui profil: $e');
  //   } finally {
  //     setLoading(false);
  //   }
  //   return false; // Gagal
  // }


// Future<void> editProfile(BuildContext context, String name) async {
//   setLoading(true);
//   try {
//     final response = await _authService.updateProfile(name);
//     setMessage(response['message']);

//     if (response['message'] == '') {
//       // Refresh profil di layar profil
//       await Provider.of<ProfilModel>(context, listen: false).fetchProfile(context);

//       // Refresh profil di HomeScreen
//       await Provider.of<HomeModel>(context, listen: false).fetchProfil(context);

//       // Tutup halaman edit
//       Navigator.pop(context);
//     }
//   } catch (e) {
//     setMessage('Gagal memperbarui profil: $e');
//   } finally {
//     setLoading(false);
//   }
// }
}