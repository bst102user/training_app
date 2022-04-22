// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<ProfileDatum> data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    msg: json["msg"],
    data: List<ProfileDatum>.from(json["data"].map((x) => ProfileDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ProfileDatum {
  ProfileDatum({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.parents,
    required this.status,
    required this.dob,
    required this.userType,
    required this.userId,
    required this.profileImage,
  });

  String id;
  String fname;
  String lname;
  String email;
  String phone;
  String parents;
  String status;
  DateTime dob;
  String userType;
  String userId;
  String profileImage;

  factory ProfileDatum.fromJson(Map<String, dynamic> json) => ProfileDatum(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    phone: json["phone"],
    parents: json["parents"],
    status: json["status"],
    dob: DateTime.parse(json["dob"]),
    userType: json["user_type"],
    userId: json["user_id"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fname": fname,
    "lname": lname,
    "email": email,
    "phone": phone,
    "parents": parents,
    "status": status,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "user_type": userType,
    "user_id": userId,
    "profile_image": profileImage,
  };
}
