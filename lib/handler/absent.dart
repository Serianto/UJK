import 'dart:convert';

class Register {
  String name;
  String email;
  String password;

  Register({
    required this.name,
    required this.email,
    required this.password,
  });

  factory Register.fromJson(Map<String, dynamic> json){
    return Register(
      name: json ['name'] ?? '',
      email: json ['email'] ?? '',
      password: json ['password'] ?? '',
    );
  }
  
  Map<String, dynamic> ToJson(){
    return{
      'name' : name,
      'email' : email,
      'password' : password,
    };
  }
}

class Login {
  final String token;
  final String email;
  final String name;
  final String password;  // Menambahkan field password

  Login({
    required this.token,
    required this.email,
    required this.name,
    required this.password,  // Pastikan password juga diberikan saat konstruktor
  });

  // Mengupdate factory method fromJson untuk menangani password
  factory Login.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'] ?? {}; // Mengatasi jika 'user' tidak ada atau null

    return Login(
      token: json['data']['token'] ?? '', // Pastikan token tidak null
      email: user['email'] ?? '', // Pastikan email tidak null
      name: user['name'] ?? '', // Pastikan name tidak null
      password: '',  // Biasanya password tidak dikirimkan dalam response, jadi beri nilai default kosong
    );
  }

  // Method toJson untuk mengonversi objek Login kembali ke format JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'name': name,
      'password': password, // Menambahkan password saat konversi ke JSON
    };
  }
}

// Login loginFromJson(String str) => Login.fromJson(jsonDecode(str));
// String loginToJson(Login data) => json.encode(data.toJson());

// class Login{
//   String email;
//   String password;

//   Login({
//     required this.email,
//     required this.password,
//   });

//   Map<String, dynamic> toJson(){
//     return{
//       'email' : email,
//       'password' : password,
//     };
//   }

//   factory Login.fromJson(Map<String, dynamic> json) {
//     return Login(
//       email: json['email'],
//       password: json['password'],
//     );
//   }

// }

class Checkin{
  String checkInLat;
  String checkInLng; 
  String checkInAddress;
  String status;
  String alasanIzin;

  Checkin({
    required this.checkInLat,
    required this.checkInLng,
    required this.checkInAddress,
    required this.status,
    required this.alasanIzin,
  });

  Map<String, dynamic> toMap(){
    return{
      'checkInLat' : checkInLat,
      'checkInLng' : checkInLng,
      'checkInAdress' : checkInAddress,
      'status' : status,
      'alasanizin' : alasanIzin,
    };
  }
}

class Checkout{
  String checkOutLat;
  String checkOutLng;
  String checkOutLocation;
  String checkOutAddress;

  Checkout({
    required this.checkOutLat,
    required this.checkOutLng,
    required this.checkOutLocation,
    required this.checkOutAddress,
  });

  Map<String, dynamic> toMap(){
    return{
      'checkOutLat' : checkOutLat,
      'checkOutLng' : checkOutLng,
      'checkOutLocation' : checkOutLocation,
      'checkOutAddress' : checkOutAddress,
    };
  }
}

class Delete{
  String name;
  String email;
  String password;

  Delete({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap(){
    return{
      'name' : name,
      'email' : email,
      'password' : password,
    };
  }
}

class Profil{}

class Edit{
  String name;

  Edit({
    required this.name,
  });

  Map<String, dynamic> toMap(){
    return{
      'name' : name,
    };
  }
}

class History{
  String email;
  String password;

  History({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap(){
    return{
      'email' : email,
      'password' : password,
    };
  }
}

class User{
  String email;
  String password;

  User({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap(){
    return{
      'email' : email,
      'password' : password,
    };
  }
}