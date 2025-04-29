import 'package:absensi/handler/user.dart';
import 'package:flutter/material.dart';

class RegisterModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> register(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    setLoading(true);
    try {
      final responseData = await _authService.register(name, email, password);
      if (responseData['message'] == 'Registrasi berhasil') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sukses'),
              content: const Text('Registrasi berhasil!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        Navigator.pop(context);
      } else {
        if (responseData['errors'] != null) {
          setErrorMessage(responseData['errors'].values.join('\n'));
        } else {
          setErrorMessage(responseData['message']);
        }
      }
    } catch (e) {
      setErrorMessage('Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }
}