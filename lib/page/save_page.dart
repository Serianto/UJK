import 'dart:convert';

import 'package:absensi/api/api.dart';
import 'package:absensi/handler/absent.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs){
      return prefs.getString('token') ?? '';
    });
  }

  Future<LocationData?> _currenctLocation() async {
    bool serviceEnable;
    PermissionStatus permissionGranted;

    Location location = new Location();

    serviceEnable = await location.serviceEnabled();

    if(!serviceEnable) {
      serviceEnable = await location.requestService();
      if(!serviceEnable) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied){
      permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted){
        return null;
      }
    }

    return await location.getLocation();
  }

  Future saveAbsen(latitude, longitude) async {
    Checkin checkin;
    Map<String, String> body = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString()
    };

    Map<String, String> headers = {'Authorization' : 'Bearer' + await _token};

    var response = await Http.post(Uri.parse(Api.baseUrl + Api.checkin),
    body: body,
    headers: headers);

    checkin = Checkin.fromJson(json.decode(response.body));

    if(checkin.success){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sukses')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi'),
      ),
      body: FutureBuilder<LocationData?>(
        future: _currenctLocation(), 
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            final LocationData currentLocation = snapshot.data;
            print('Uhuyy : ' + currentLocation.latitude.toString() + ' | ' + currentLocation.longitude.toString());
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: SfMaps(
                      layers: [
                        MapTileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          initialFocalLatLng: MapLatLng(
                            currentLocation.latitude!, 
                            currentLocation.longitude!),
                          initialZoomLevel: 15,
                          initialMarkersCount: 1,
                          markerBuilder: (BuildContext context, int index){
                            return MapMarker(
                              latitude: currentLocation.latitude!, 
                              longitude: currentLocation.longitude!,
                              child: Icon(Icons.location_on, color: dua));
                          },
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      saveAbsen(
                        currentLocation.latitude, 
                        currentLocation.longitude);
                    }, 
                    child: Text('Simpan'))
                ],
              )
            );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }
}