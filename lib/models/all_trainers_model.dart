// To parse this JSON data, do
//
//     final allTrainersModel = allTrainersModelFromJson(jsonString);

import 'dart:convert';

AllTrainersModel allTrainersModelFromJson(String str) => AllTrainersModel.fromJson(json.decode(str));

String allTrainersModelToJson(AllTrainersModel data) => json.encode(data.toJson());

class AllTrainersModel {
  AllTrainersModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<AlTrainerDatum> data;

  factory AllTrainersModel.fromJson(Map<String, dynamic> json) => AllTrainersModel(
    status: json["status"],
    msg: json["msg"],
    data: List<AlTrainerDatum>.from(json["data"].map((x) => AlTrainerDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AlTrainerDatum {
  AlTrainerDatum({
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
  dynamic parents;
  String status;
  String dob;
  String token;
  String allowNotification;
  DateTime createdAt;
  DateTime updatedAt;

  factory AlTrainerDatum.fromJson(Map<String, dynamic> json) => AlTrainerDatum(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    userType: json["user_type"],
    parents: json["parents"],
    status: json["status"],
    dob: json["dob"],
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
    "dob": dob,
    "token": token,
    "allow_notification": allowNotification,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
