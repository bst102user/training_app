// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<NotificationDatum> data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    status: json["status"],
    msg: json["msg"],
    data: List<NotificationDatum>.from(json["data"].map((x) => NotificationDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationDatum {
  NotificationDatum({
    required this.id,
    required this.userId,
    required this.title,
    required this.descr,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  String title;
  String descr;
  DateTime createdAt;
  DateTime updatedAt;

  factory NotificationDatum.fromJson(Map<String, dynamic> json) => NotificationDatum(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    descr: json["descr"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "descr": descr,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
