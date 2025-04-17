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
              ),
            ),
          );
        }
      )
    );
  }
}