//import 'package:absensi/handler/absent.dart';
import 'package:absensi/handler/login.dart';
import 'package:absensi/handler/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isloading = false;
  String _errormessage = '';

  bool get isLoading => _isloading;
  String get errorMessage => _errormessage;

  void setLoading(bool value){
    _isloading = value;
    notifyListeners();
  }

  void setErrorMessage(String value){
    _errormessage = value;
    notifyListeners();
  }

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async{
    setLoading(true);
    try{
      LoginResponse response = await _authService.login(email, password);
      if(response.data != null){
        Navigator.pushReplacementNamed(context, '/home');
      }else{
        setErrorMessage(response.message);
      }
    }catch(e){
      setErrorMessage('Kesalahan : $e');
    }finally{
      setLoading(false);
    }
  }
}