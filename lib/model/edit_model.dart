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

Future<void> editProfile(BuildContext context, String name) async {
  setLoading(true);
  try {
    final response = await _authService.updateProfile(name);
    setMessage(response['message']);

    if (response['message'] == '') {
      // Refresh profil di layar profil
      await Provider.of<ProfilModel>(context, listen: false).fetchProfile(context);

      // Refresh profil di HomeScreen
      await Provider.of<HomeModel>(context, listen: false).fetchProfil(context);

      // Tutup halaman edit
      Navigator.pop(context);
    }
  } catch (e) {
    setMessage('Gagal memperbarui profil: $e');
  } finally {
    setLoading(false);
  }
}
}