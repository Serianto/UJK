//import 'package:absensi/handler/absent.dart';
import 'package:absensi/handler/user.dart';
import 'package:absensi/model/home_model.dart';
import 'package:absensi/page/save_page.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<HomeModel>(context, listen: false).fetchProfil(context);
    });
    
  }
  // final UserService _userService = UserService();
  // final AuthService _authService = AuthService();
  // // Map<String, dynamic> _profilData = {};
  //bool _isLoading = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchProfil();
//   }

// Future<void> _fetchProfil() async {
//   try {
//     final token = await _userService.getToken();
//     if (token == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final response = await _authService.getProfile();
//     print('📥 Profil Response: $response');

//     setState(() {
//       _profilData = response['data']['user'];
//       _isLoading = false;
//     });
//   } catch (e) {
//     setState(() {
//       _isLoading = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color : tujuh, fontSize: 18)),
                decoration: BoxDecoration(color: lima)),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pushNamed(context, '/users');
              },
            )
          ],
        ),
      ),
      body: Consumer<HomeModel>(
        builder: (context, homeModel, child){
          if(homeModel.isLoading){
            return const Center(child: CircularProgressIndicator());
          } if(homeModel.errormessage.isNotEmpty){
            return Center(child: Text('Error: ${homeModel.errormessage}'));
          } if(homeModel.profildata.isEmpty){
            return const Center(child: Text('Data tidak tersedia'));
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Haloww, ${homeModel.profildata['name']}:)',
                  style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SavePage()));
                    }, 
                    child: Text('Absen'))
                ],
              ),),
          );
        })
    );
    }}