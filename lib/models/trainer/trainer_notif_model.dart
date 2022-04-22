// To parse this JSON data, do
//
//     final trainerNotifModel = trainerNotifModelFromJson(jsonString);

import 'dart:convert';

TrainerNotifModel trainerNotifModelFromJson(String str) => TrainerNotifModel.fromJson(json.decode(str));

String trainerNotifModelToJson(TrainerNotifModel data) => json.encode(data.toJson());

class TrainerNotifModel {
  TrainerNotifModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<TrainNotifDatum> data;

  factory TrainerNotifModel.fromJson(Map<String, dynamic> json) => TrainerNotifModel(
    status: json["status"],
    msg: json["msg"],
    data: List<TrainNotifDatum>.from(json["data"].map((x) => TrainNotifDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TrainNotifDatum {
  TrainNotifDatum({
    required this.id,
    required this.userId,
    required this.trainerId,
    required this.userName,
    required this.title,
    required this.msg,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  String trainerId;
  String userName;
  String title;
  String msg;
  DateTime createdAt;
  DateTime updatedAt;

  factory TrainNotifDatum.fromJson(Map<String, dynamic> json) => TrainNotifDatum(
    id: json["id"],
    userId: json["user_id"],
    trainerId: json["trainer_id"],
    userName: json["user_name"],
    title: json["title"],
    msg: json["msg"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "trainer_id": trainerId,
    "user_name": userName,
    "title": title,
    "msg": msg,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
