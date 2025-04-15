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

  Map<String, dynamic> ToMap(){
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