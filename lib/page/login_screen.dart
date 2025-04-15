import 'dart:convert';

import 'package:absensi/api/api.dart';
import 'package:absensi/handler/absent.dart';
import 'package:absensi/page/home_screen.dart';
import 'package:absensi/page/regis_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> _name, _token;

  @override
  void initState() {
    _token = _prefs.then((SharedPreferences prefs){
      return prefs.getString('token') ?? '';
    });
    
    _name = _prefs.then((SharedPreferences prefs){
      return prefs.getString('name') ?? '';
    });
    super.initState();
  }

  checkToken(token, name) async{
    String tokenStr = await token;
    String nameStr = await name;
    if (tokenStr != '' && nameStr != ''){
      Future.delayed(Duration(seconds: 2), () async{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyWidget())).then((value){
          setState(() {});
        });
      });
    }
  }

  Future login(email, password) async{
    Login? login;
    Map<String, String> body = {'email' : email, 'password' : password};
    var response = await myHttp.post(Uri.parse(Api.baseUrl + Api.login),
    body: body);

    if(response.statusCode == 401){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ada yang salah')));
    } else {
      login = Login.fromJson(json.decode(response.body));
      print('Hasil' + response.body);
      saveUser(login.email, login.password);
    }
  }

  Future saveUser(token, name) async{         
    try{
      print('Disini' + token + ' | ' + name);
      final SharedPreferences pref = await _prefs;
      pref.setString('name', name);
      pref.setString('token', token);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyWidget())).then((value){
        setState(() {});
      });
    } catch(err){
      print('Error :' + err.toString());
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
                Center(child: Text('Login')),
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
                  onPressed: () {
                    login(emailController.text, passwordController.text);
                  }, 
                  child: Text('Masuk')),
                
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisScreen())) , 
                  child: Text('Register'))
              ],
            ),
          ),)),
    );
  }
}