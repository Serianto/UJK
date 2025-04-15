import 'package:absensi/handler/absent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  User? user;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _token = _pref.then((SharedPreferences prefs){
      return prefs.getString('token') ?? '';
    });

    _name = _pref.then((SharedPreferences prefs){
      return prefs.getString('name') ?? '';
    });
  }

  Future getData() async{
    final Map<String, String> headers = {
      'Authorization' : 'Bearer' + await _token
    };
    var response = await myHttp.get(Uri.parse(uri),
    headers: headers);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: , 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else{
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: future, builder: builder)
                  ],
                ),))
          }
        },),
    );
  }
}