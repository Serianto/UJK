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

Login loginFromJson(String str) => Login.fromJson(jsonDecode(str));
String loginToJson(Login data) => json.encode(data.toJson());

class Login{
  String email;
  String password;

  Login({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson(){
    return{
      'email' : email,
      'password' : password,
    };
  }

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password'],
    );
  }

}

class Checkin {
  bool success;
  String checkInLat;
  String checkInLng;
  String checkInAddress;
  String status;
  String alasanIzin;

  Checkin({
    required this.success,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkInAddress,
    required this.status,
    required this.alasanIzin,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'checkInLat': checkInLat,
      'checkInLng': checkInLng,
      'checkInAddress': checkInAddress, // typo diperbaiki dari 'checkInAdress'
      'status': status,
      'alasanIzin': alasanIzin, // konsisten dengan camelCase
    };
  }

  factory Checkin.fromJson(Map<String, dynamic> json) {
    return Checkin(
      success: json['success'] ?? '',
      checkInLat: json['checkInLat'] ?? '',
      checkInLng: json['checkInLng'] ?? '',
      checkInAddress: json['checkInAddress'] ?? '',
      status: json['status'] ?? '',
      alasanIzin: json['alasanIzin'] ?? '',
    );
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
