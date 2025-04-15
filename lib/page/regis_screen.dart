import 'dart:convert';

import 'package:absensi/api/api.dart';
import 'package:absensi/handler/absent.dart';
import 'package:absensi/page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as myHttp;
import 'package:shared_preferences/shared_preferences.dart';

class RegisScreen extends StatefulWidget {
  const RegisScreen({super.key});

  @override
  State<RegisScreen> createState() => _RegisScreenState();
}

class _RegisScreenState extends State<RegisScreen> {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> register(String name, String email, String password) async{
      Register? register;
      Map<String, String> body = {
        'name' : name,
        'email' : email,
        'password' : password,
      };

      var response = await myHttp.post(Uri.parse('${Api.baseUrl}${Api.register}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body);

      if(response.statusCode == 401){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ada yang salah')));
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        register = Register.fromJson(json.decode(response.body));
        saveUser(register.email, register.name, register.password);
      }
    }

    Future<void> saveUser(String email, String name, String password) async{
      try{
        final SharedPreferences pref = await _prefs;
        pref.setString('email', email);
        pref.setString('name', name);
        pref.setString('password', password);

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage())).then((value){
          setState(() {});
        });
      }catch(err){
        print('Error : $err');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('register')),
                SizedBox(height: 20),
                Text('Name'),
                TextField(
                  controller: nameController,
                ),
                SizedBox(height: 20),
                Text('Email'),
                TextField(
                  controller: emailController,
                ),
                SizedBox(height: 20),
                Text('Password'),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){
                    register(nameController.text, emailController.text, passwordController.text);
                  }, 
                  child: Text('Register'))
              ],
            ),
          ),)),
    );
  }
}