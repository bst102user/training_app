// To parse this JSON data, do
//
//     final athleteNotifModel = athleteNotifModelFromJson(jsonString);

import 'dart:convert';

AthleteNotifModel athleteNotifModelFromJson(String str) => AthleteNotifModel.fromJson(json.decode(str));

String athleteNotifModelToJson(AthleteNotifModel data) => json.encode(data.toJson());

class AthleteNotifModel {
  AthleteNotifModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<AthlNotifDatum> data;

  factory AthleteNotifModel.fromJson(Map<String, dynamic> json) => AthleteNotifModel(
    status: json["status"],
    msg: json["msg"],
    data: List<AthlNotifDatum>.from(json["data"].map((x) => AthlNotifDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AthlNotifDatum {
  AthlNotifDatum({
    required this.id,
    required this.userId,
    required this.trainerId,
    required this.title,
    required this.descr,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  String trainerId;
  String title;
  String descr;
  DateTime createdAt;
  DateTime updatedAt;

  factory AthlNotifDatum.fromJson(Map<String, dynamic> json) => AthlNotifDatum(
    id: json["id"],
    userId: json["user_id"],
    trainerId: json["trainer_id"],
    title: json["title"],
    descr: json["descr"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "trainer_id": trainerId,
    "title": title,
    "descr": descr,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
