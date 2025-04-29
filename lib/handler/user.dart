import 'dart:convert';

import 'package:absensi/api/api.dart';
import 'package:absensi/handler/login.dart';
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

class AuthService {
  final UserService _userService = UserService();

  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Api.baseUrl + Api.login),
      body: {'email': email, 'password': password},
    );
    print('API Login Response Body: ${response.body}');
    final loginResponse = LoginResponse.fromJson(json.decode(response.body));

    if (loginResponse.data != null) {
      await _userService.saveToken(loginResponse.data!.token);
    }

    return loginResponse;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(Api.baseUrl + Api.register),
      body: {'name': name, 'email': email, 'password': password},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> checkIn(
    String checkInLat,
    String checkInLng,
    String checkInAddress,
    String status, {
    String? alasanIzin,
  }) async {
    final token = await _userService.getToken();
    final response = await http.post(
      Uri.parse(Api.baseUrl + Api.checkin),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_in_lat': checkInLat,
        'check_in_lng': checkInLng,
        'check_in_address': checkInAddress,
        'status': status,
        if (alasanIzin != null) 'alasan_izin': alasanIzin,
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> checkOut(
    String checkOutLat,
    String checkOutLng,
    String checkOutAddress,
  ) async {
    final token = await _userService.getToken();
    final response = await http.post(
      Uri.parse(Api.baseUrl + Api.checkout),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'check_out_address': checkOutAddress,
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _userService.getToken();
    final response = await http.get(
      Uri.parse(Api.baseUrl + Api.profile_edit),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateProfile(String name, String email) async {
    final token = await _userService.getToken();
    final response = await http.put(
      Uri.parse(Api.baseUrl + Api.profile_edit),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded', // penting jika pakai form body
      },
      body: {
        'name': name,
        'email': email,
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getAbsenHistory(String startDate) async {
    final token = await _userService.getToken();
    final response = await http.get(
      Uri.parse(
        Api.baseUrl + Api.history + '?start=$startDate',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
}