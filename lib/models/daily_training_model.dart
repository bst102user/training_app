// To parse this JSON data, do
//
//     final dailyTrainingModel = dailyTrainingModelFromJson(jsonString);

import 'dart:convert';

DailyTrainingModel dailyTrainingModelFromJson(String str) => DailyTrainingModel.fromJson(json.decode(str));

String dailyTrainingModelToJson(DailyTrainingModel data) => json.encode(data.toJson());

class DailyTrainingModel {
  DailyTrainingModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  Msg msg;
  List<DailyTrainDatum> data;

  factory DailyTrainingModel.fromJson(Map<String, dynamic> json) => DailyTrainingModel(
    status: json["status"],
    msg: Msg.fromJson(json["msg"]),
    data: List<DailyTrainDatum>.from(json["data"].map((x) => DailyTrainDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DailyTrainDatum {
  DailyTrainDatum({
    required this.id,
    required this.userId,
    required this.dates,
    required this.headline,
    required this.trainingstimeMin,
    required this.powerWatt,
    required this.pulse,
    required this.cadence,
    required this.rainingstime,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  String dates;
  String headline;
  String trainingstimeMin;
  String powerWatt;
  String pulse;
  String cadence;
  String rainingstime;
  DateTime createdAt;
  DateTime updatedAt;

  factory DailyTrainDatum.fromJson(Map<String, dynamic> json) => DailyTrainDatum(
    id: json["id"],
    userId: json["user_id"],
    dates: json["dates"],
    headline: json["headline"] == null ? null : json["headline"],
    trainingstimeMin: json["trainingstime_min"] == null ? null : json["trainingstime_min"],
    powerWatt: json["power_watt"] == null ? null : json["power_watt"],
    pulse: json["pulse"] == null ? null : json["pulse"],
    cadence: json["cadence"] == null ? null : json["cadence"],
    rainingstime: json["rainingstime"] == null ? null : json["rainingstime"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "dates": dates,
    "headline": headline == null ? null : headline,
    "trainingstime_min": trainingstimeMin == null ? null : trainingstimeMin,
    "power_watt": powerWatt == null ? null : powerWatt,
    "pulse": pulse == null ? null : pulse,
    "cadence": cadence == null ? null : cadence,
    "rainingstime": rainingstime == null ? null : rainingstime,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Msg {
  Msg({
    required this.message,
  });

  String message;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}