import 'package:absensi/model/save_model.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  Future<LatLng?>? _locationFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationFuture = Provider.of<SaveModel>(context, listen: false).getCurrentLocation();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Absen'),
      backgroundColor: bg,
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<SaveModel>(
        builder: (context, absenProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Lokasi Anda Saat Ini :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: FutureBuilder<LatLng?>(
                      future: _locationFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Gagal mendapatkan lokasi: ${snapshot.error}'),
                          );
                        } else if (snapshot.data != null) {
                          return GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: snapshot.data!,
                              zoom: 16,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('currentLocation'),
                                position: snapshot.data!,
                              ),
                            },
                            onMapCreated: (controller) => absenProvider.setMapController(controller),
                          );
                        } else {
                          return const Center(child: Text('Lokasi belum tersedia.'));
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: absenProvider.isLoading && absenProvider.status == 'masuk'
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.login),
                      label: const Text('Absen Masuk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: satu,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: absenProvider.isLoading
                          ? null
                          : () async {
                              absenProvider.setStatus('masuk');
                              bool success = await absenProvider.checkIn(context);
                              if (success && context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: absenProvider.isLoading && absenProvider.status == 'keluar'
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.logout),
                      label: const Text('Absen Keluar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: absenProvider.isLoading
                          ? null
                          : () async {
                              absenProvider.setStatus('keluar');
                              bool success = await absenProvider.checkOut(context);
                              if (success && context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              }
                            },
                    ),
                  ),
                ],
              ),
              if (absenProvider.message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    absenProvider.message,
                    style: TextStyle(
                      color: absenProvider.message.contains('berhasil') ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
    )
    // body: Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Consumer<SaveModel>(
    //     builder: (context, absenProvider, child) {
    //       return Column(
    //         children: <Widget>[
    //           // Google Map Card
    //           Expanded(
    //             flex: 2,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(12),
    //               child: Card(
    //                 elevation: 4,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(12),
    //                 ),
    //                 child: FutureBuilder<LatLng?>(
    //                   future: _locationFuture,
    //                   builder: (context, snapshot) {
    //                     if (snapshot.connectionState == ConnectionState.waiting) {
    //                       return const Center(child: CircularProgressIndicator());
    //                     } else if (snapshot.hasError) {
    //                       return Center(
    //                         child: Text('Gagal mendapatkan lokasi: ${snapshot.error}'),
    //                       );
    //                     } else if (snapshot.data != null) {
    //                       return GoogleMap(
    //                         initialCameraPosition: CameraPosition(
    //                           target: snapshot.data!,
    //                           zoom: 15,
    //                         ),
    //                         markers: {
    //                           Marker(
    //                             markerId: const MarkerId('currentLocation'),
    //                             position: snapshot.data!,
    //                           ),
    //                         },
    //                         onMapCreated: (GoogleMapController controller) {
    //                           absenProvider.setMapController(controller);
    //                         },
    //                       );
    //                     } else {
    //                       return const Center(child: Text('Lokasi belum tersedia.'));
    //                     }
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 24),
    //           SizedBox(
    //             width: double.infinity,
    //             child: ElevatedButton.icon(
    //               icon: const Icon(Icons.login),
    //               label: absenProvider.isLoading && absenProvider.status == 'masuk'
    //                   ? const SizedBox(
    //                       height: 20,
    //                       width: 20,
    //                       child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
    //                     )
    //                   : const Text('Absen Masuk'),
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: satu,
    //                 padding: const EdgeInsets.symmetric(vertical: 14),
    //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //               ),
    //               onPressed: absenProvider.isLoading
    //                   ? null
    //                   : () async {
    //                       absenProvider.setStatus('masuk');
    //                       bool success = await absenProvider.checkIn(context);
    //                       if (success && context.mounted) {
    //                         Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    //                       }
    //                     },
    //             ),
    //           ),

    //           const SizedBox(height: 12),

    //           // Tombol Absen Keluar
    //           SizedBox(
    //             width: double.infinity,
    //             child: ElevatedButton.icon(
    //               icon: const Icon(Icons.logout),
    //               label: absenProvider.isLoading && absenProvider.status == 'keluar'
    //                   ? const SizedBox(
    //                       height: 20,
    //                       width: 20,
    //                       child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
    //                     )
    //                   : const Text('Absen Keluar'),
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: Colors.blue,
    //                 padding: const EdgeInsets.symmetric(vertical: 14),
    //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //               ),
    //               onPressed: absenProvider.isLoading
    //                   ? null
    //                   : () async {
    //                       absenProvider.setStatus('keluar');
    //                       bool success = await absenProvider.checkOut(context);
    //                       if (success && context.mounted) {
    //                         Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    //                       }
    //                     },
    //             ),
    //           ),
    //           const SizedBox(height: 12),
    //           if (absenProvider.message.isNotEmpty)
    //             Padding(
    //               padding: const EdgeInsets.only(top: 12.0),
    //               child: Text(
    //                 absenProvider.message,
    //                 style: TextStyle(
    //                   color: absenProvider.message.contains('berhasil')
    //                       ? Colors.green
    //                       : Colors.red,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //         ],
    //       );
    //     },
    //   ),
    // ),
  );
}
}