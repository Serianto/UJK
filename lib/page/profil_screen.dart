import 'package:absensi/handler/user.dart';
import 'package:absensi/page/edit_screen.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
    final AuthService _authservice = AuthService();
    Map<String, dynamic> _profildata = {};
    bool _isLoading = true;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchprofil();
  }

  Future<void> _fetchprofil() async {
    try{
      final response = await _authservice.getProfile();
      setState(() {
      _profildata = response['data'];
      _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat profil : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profil')),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama : ${_profildata['name']}'),
              Text('Email : ${_profildata['email']}'),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen()));
                }, 
                child: Text('Edit'))
            ],),)
    );
  }
}