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
          final bool isButtonEnabled = absenProvider.status == 'masuk' ||
            (absenProvider.status == 'izin' && absenProvider.alasanIzin.trim().isNotEmpty);
          return Column(
            children: <Widget>[
              // Google Map Card
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('currentLocation'),
                                position: snapshot.data!,
                              ),
                            },
                            onMapCreated: (GoogleMapController controller) {
                              absenProvider.setMapController(controller);
                            },
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

              // Dropdown status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: lima,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: enam),
                ),
                child: DropdownButton<String>(
                  value: absenProvider.status,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['masuk', 'izin'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    absenProvider.setStatus(value!);
                  },
                ),
              ),

              // Alasan Izin
              if (absenProvider.status == 'izin') ...[
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Alasan Izin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    absenProvider.setAlasanIzin(value);
                  },
                ),
              ],

              const SizedBox(height: 24),

              // Tombol absen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: absenProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Absen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled ? satu : empat,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (!isButtonEnabled || absenProvider.isLoading)
                    ? null
                    : () async {
                        bool success = await absenProvider.checkIn(context);
                        if (success && context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                        }
                      },
                    ),
                  ),

              // Message Feedback
              if (absenProvider.message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    absenProvider.message,
                    style: TextStyle(
                      color: absenProvider.message.contains('berhasil')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
}