import 'package:absensi/handler/user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SaveModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _status = 'masuk';
  String _alasanIzin = '';
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  String _message = '';
  String _lastAbsenStatus = '';
  String _lastAlasanIzin = '';
  DateTime? _lastAbsenTime;

  // Riwayat absen
  List<AbsenHistoryItem> _history = [];

  // Koordinat kantor
  static const double kantorLatitude = -6.210881;
  static const double kantorLongitude = 106.812942;
  static const double allowedRadius = 100;

  bool get isLoading => _isLoading;
  String get status => _status;
  String get alasanIzin => _alasanIzin;
  LatLng? get currentLocation => _currentLocation;
  GoogleMapController? get mapController => _mapController;
  String get message => _message;
  String get lastAbsenStatus => _lastAbsenStatus;
  String get lastAlasanIzin => _lastAlasanIzin;
  DateTime? get lastAbsenTime => _lastAbsenTime;
  List<AbsenHistoryItem> get history => _history; // Riwayat absen

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setAlasanIzin(String value) {
    _alasanIzin = value;
    notifyListeners();
  }

  void setCurrentLocation(LatLng? value) {
    _currentLocation = value;
    notifyListeners();
  }

  void setMapController(GoogleMapController? value) {
    _mapController = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void removeHistoryAt(int index) {
  _history.removeAt(index);
  notifyListeners();
  }

  void clearHistory() {
  _history.clear();
  notifyListeners();
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setCurrentLocation(LatLng(position.latitude, position.longitude));
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Fungsi untuk mengecek absen
  Future<bool> checkIn(BuildContext context) async {
    setLoading(true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double checkInLat = position.latitude;
      double checkInLng = position.longitude;
      String checkInAddress = 'Lokasi Tidak Diketahui';

      if (_status == 'masuk') {
        double distance = Geolocator.distanceBetween(
          checkInLat,
          checkInLng,
          kantorLatitude,
          kantorLongitude,
        );

        if (distance > allowedRadius) {
          setMessage(
            'Anda berada di luar radius absensi (${distance.toStringAsFixed(2)} m).',
          );
          setLoading(false);
          return false;
        }
      } else if (_status == 'izin' && _alasanIzin.isEmpty) {
        setMessage('Alasan izin wajib diisi.');
        setLoading(false);
        return false;
      }

      final response = await _authService.checkIn(
        checkInLat.toString(),
        checkInLng.toString(),
        checkInAddress,
        _status,
        alasanIzin: _status == 'izin' ? _alasanIzin : null,
      );

      setMessage(response['message']);

      // Jika berhasil absen, simpan riwayat
      if (response['message'].toString().toLowerCase().contains('berhasil')) {
        _lastAbsenStatus = _status;
        _lastAlasanIzin = _alasanIzin;
        _lastAbsenTime = DateTime.now();

        // Simpan ke riwayat absen
        _history.add(AbsenHistoryItem(
          status: _status,
          alasan: _status == 'izin' ? _alasanIzin : null,
          waktu: DateTime.now(),
        ));

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      setMessage('Terjadi kesalahan: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> checkOut(BuildContext context) async {
  setLoading(true);

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double checkOutLat = position.latitude;
    double checkOutLng = position.longitude;
    String checkOutAddress = 'Lokasi Tidak Diketahui';

    double distance = Geolocator.distanceBetween(
      checkOutLat,
      checkOutLng,
      kantorLatitude,
      kantorLongitude,
    );

    if (distance > allowedRadius) {
      setMessage(
        'Anda berada di luar radius absensi keluar (${distance.toStringAsFixed(2)} m).',
      );
      setLoading(false);
      return false;
    }

    final response = await _authService.checkOut(
      checkOutLat.toString(),
      checkOutLng.toString(),
      checkOutAddress,
    );

    setMessage(response['message']);

    if (response['message'].toString().toLowerCase().contains('berhasil')) {
      _lastAbsenStatus = 'keluar';
      _lastAlasanIzin = '';
      _lastAbsenTime = DateTime.now();

      _history.add(AbsenHistoryItem(
        status: 'keluar',
        alasan: null,
        waktu: DateTime.now(),
      ));

      notifyListeners();
      return true;
    }

    return false;
  } catch (e) {
    setMessage('Terjadi kesalahan: $e');
    return false;
  } finally {
    setLoading(false);
  }
}
}


class AbsenHistoryItem {
  final String status;
  final String? alasan;
  final DateTime waktu;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;

  AbsenHistoryItem({
    required this.status,
    this.alasan,
    required this.waktu,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
  });

  factory AbsenHistoryItem.fromJson(Map<String, dynamic> json) {
    return AbsenHistoryItem(
      status: json['status'],
      alasan: json['alasan'],
      waktu: DateTime.parse(json['waktu']),
      checkInLat: json['check_in_lat'] != null ? json['check_in_lat'].toDouble() : null,
      checkInLng: json['check_in_lng'] != null ? json['check_in_lng'].toDouble() : null,
      checkOutLat: json['check_out_lat'] != null ? json['check_out_lat'].toDouble() : null,
      checkOutLng: json['check_out_lng'] != null ? json['check_out_lng'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'alasan': alasan,
      'waktu': waktu.toIso8601String(),
      'check_in_lat': checkInLat,
      'check_in_lng': checkInLng,
      'check_out_lat': checkOutLat,
      'check_out_lng': checkOutLng,
    };
  }
}


