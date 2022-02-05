// To parse this JSON data, do
//
//     final allRaceModel = allRaceModelFromJson(jsonString);

import 'dart:convert';

AllRaceModel allRaceModelFromJson(String str) => AllRaceModel.fromJson(json.decode(str));

String allRaceModelToJson(AllRaceModel data) => json.encode(data.toJson());

class AllRaceModel {
  AllRaceModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<AllRaceDatum> data;

  factory AllRaceModel.fromJson(Map<String, dynamic> json) => AllRaceModel(
    status: json["status"],
    msg: json["msg"],
    data: List<AllRaceDatum>.from(json["data"].map((x) => AllRaceDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllRaceDatum {
  AllRaceDatum({
    required this.id,
    required this.name,
    required this.firstDay,
    required this.lastDay,
    required this.distance,
    required this.verticalMeters,
    required this.goal,
    required this.priority,
    required this.arrival,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String firstDay;
  String lastDay;
  String distance;
  String verticalMeters;
  String goal;
  String priority;
  String arrival;
  DateTime createdAt;
  DateTime updatedAt;

  factory AllRaceDatum.fromJson(Map<String, dynamic> json) => AllRaceDatum(
    id: json["id"],
    name: json["name"],
    firstDay: json["first_day"],
    lastDay: json["last_day"],
    distance: json["distance"],
    verticalMeters: json["vertical_meters"],
    goal: json["goal"],
    priority: json["priority"],
    arrival: json["arrival"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_day": firstDay,
    "last_day": lastDay,
    "distance": distance,
    "vertical_meters": verticalMeters,
    "goal": goal,
    "priority": priority,
    "arrival": arrival,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
