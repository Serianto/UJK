import 'package:absensi/model/login_model.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'asset/login.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: bg,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Consumer<LoginModel>(
                        builder: (context, loginmodel, child){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Login',
                                ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'email',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'email isi';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: 'pasword',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'password isi';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: loginmodel.isLoading ? null : (){
                                  if(_formKey.currentState!.validate()){
                                    loginmodel.login(context, emailController.text, passwordController.text);
                                  }
                                }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: dua,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                ),
                                child: loginmodel.isLoading ? CircularProgressIndicator() : Text('Login'),
                                ),
                                if(loginmodel.errorMessage.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(loginmodel.errorMessage, style: TextStyle(color: tujuh))),

                                  TextButton(
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/register');
                                    }, child: Text('Regist'))
                            ],
                          );
                        })))
                ),
              ),
            )
        ],
      )
    );
  }
}