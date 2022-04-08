// To parse this JSON data, do
//
//     final trAssignAthletesModel = trAssignAthletesModelFromJson(jsonString);

import 'dart:convert';

TrAssignAthletesModel trAssignAthletesModelFromJson(String str) => TrAssignAthletesModel.fromJson(json.decode(str));

String trAssignAthletesModelToJson(TrAssignAthletesModel data) => json.encode(data.toJson());

class TrAssignAthletesModel {
  TrAssignAthletesModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<AssignDatum> data;

  factory TrAssignAthletesModel.fromJson(Map<String, dynamic> json) => TrAssignAthletesModel(
    status: json["status"],
    msg: json["msg"],
    data: List<AssignDatum>.from(json["data"].map((x) => AssignDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AssignDatum {
  AssignDatum({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
    required this.userType,
    required this.parents,
    required this.status,
    required this.dob,
    required this.token,
    required this.allowNotification,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String fname;
  String lname;
  String email;
  String phone;
  String password;
  String userType;
  String parents;
  String status;
  DateTime dob;
  String token;
  String allowNotification;
  DateTime createdAt;
  DateTime updatedAt;

  factory AssignDatum.fromJson(Map<String, dynamic> json) => AssignDatum(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    userType: json["user_type"],
    parents: json["parents"],
    status: json["status"],
    dob: DateTime.parse(json["dob"]),
    token: json["token"],
    allowNotification: json["allow_notification"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fname": fname,
    "lname": lname,
    "email": email,
    "phone": phone,
    "password": password,
    "user_type": userType,
    "parents": parents,
    "status": status,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "token": token,
    "allow_notification": allowNotification,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
