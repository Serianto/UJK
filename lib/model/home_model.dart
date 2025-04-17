import 'package:absensi/handler/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeModel with ChangeNotifier {
  final _authservice = AuthService();
  final _userservice = UserService(); 

  Map<String, dynamic> _profildata = {};

  bool _isloading = true;
  String _errormessage = '';

  Map<String, dynamic> get profildata => _profildata;
  bool get isLoading => _isloading;
  String get errormessage => _errormessage;

  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  void setProfilData(Map<String, dynamic> value) {
    _profildata = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errormessage = value;
    notifyListeners();
  }

  Future<void> fetchProfil(BuildContext context) async {
    setLoading(true);
    try{
      final token = await _userservice.getToken();
      if(token == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      final response = await _authservice.getProfile();
      print('Profile API response: $response');
      setProfilData(response['data']);
    } catch (e) {
      setErrorMessage('Gagal: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      setLoading(false);
    }
  }
}