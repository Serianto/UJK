import 'dart:convert';

import 'package:absensi/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService{
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

class AuthService{
  final UserService _userService = UserService();

  Future<Map<String, dynamic>> getProfil() async{
    final token = await _userService.getToken();
    final response = await http.get(Uri.parse(Api.baseUrl + Api.user),
    headers : {'Authorization' : 'Bearer $token'}
    );
    return json.decode(response.body);
  }
}