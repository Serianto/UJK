import 'package:absensi/page/home_screen.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('asset/login.json'),
                Center(child: Text('Login')),
                SizedBox(height: 20),
                Text('Email'),
                TextField(

                ),
                SizedBox(height: 20),
                Text('Password'),
                TextField(

                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) { return HomeScreen();
                       }
                     )
                    );
                  }, 
                  child: Text('Masuk')),
                SizedBox(height: 20),
                Text('Atau'),
                ElevatedButton(
                  onPressed: (){

                  }, 
                  child: Text('Daftar'))
              ],
            ),
          ),
        )
      ),
      backgroundColor: bg,
    );
  }
}