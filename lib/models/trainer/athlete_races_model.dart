// To parse this JSON data, do
//
//     final athleteRacesModel = athleteRacesModelFromJson(jsonString);

import 'dart:convert';

AthleteRacesModel athleteRacesModelFromJson(String str) => AthleteRacesModel.fromJson(json.decode(str));

String athleteRacesModelToJson(AthleteRacesModel data) => json.encode(data.toJson());

class AthleteRacesModel {
  AthleteRacesModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<ARMDatum> data;

  factory AthleteRacesModel.fromJson(Map<String, dynamic> json) => AthleteRacesModel(
    status: json["status"],
    msg: json["msg"],
    data: List<ARMDatum>.from(json["data"].map((x) => ARMDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ARMDatum {
  ARMDatum({
    required this.id,
    required this.userId,
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
    required this.departure,
  });

  String id;
  String userId;
  String name;
  DateTime firstDay;
  DateTime lastDay;
  String distance;
  String verticalMeters;
  String goal;
  String priority;
  DateTime arrival;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime departure;

  factory ARMDatum.fromJson(Map<String, dynamic> json) => ARMDatum(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    firstDay: DateTime.parse(json["first_day"]),
    lastDay: DateTime.parse(json["last_day"]),
    distance: json["distance"],
    verticalMeters: json["vertical_meters"],
    goal: json["goal"],
    priority: json["priority"],
    arrival: DateTime.parse(json["arrival"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    departure: DateTime.parse(json["departure"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "first_day": "${firstDay.year.toString().padLeft(4, '0')}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}",
    "last_day": "${lastDay.year.toString().padLeft(4, '0')}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}",
    "distance": distance,
    "vertical_meters": verticalMeters,
    "goal": goal,
    "priority": priority,
    "arrival": "${arrival.year.toString().padLeft(4, '0')}-${arrival.month.toString().padLeft(2, '0')}-${arrival.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "departure": "${departure.year.toString().padLeft(4, '0')}-${departure.month.toString().padLeft(2, '0')}-${departure.day.toString().padLeft(2, '0')}",
  };
}
