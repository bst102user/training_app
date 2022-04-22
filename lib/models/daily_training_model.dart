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
    required this.aPowerWatt,
    required this.aMaxPlus,
    required this.aAveragePower,
    required this.aCandence,
    required this.aRating,
    required this.aTrainingstime,
    required this.aWeight,
    required this.aComment,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  DateTime dates;
  String headline;
  String trainingstimeMin;
  String powerWatt;
  String pulse;
  String cadence;
  dynamic rainingstime;
  String aPowerWatt;
  String aMaxPlus;
  String aAveragePower;
  String aCandence;
  String aRating;
  String aTrainingstime;
  String aWeight;
  String aComment;
  DateTime createdAt;
  DateTime updatedAt;

  factory DailyTrainDatum.fromJson(Map<String, dynamic> json) => DailyTrainDatum(
    id: json["id"],
    userId: json["user_id"],
    dates: DateTime.parse(json["dates"]),
    headline: json["headline"],
    trainingstimeMin: json["trainingstime_min"],
    powerWatt: json["power_watt"],
    pulse: json["pulse"],
    cadence: json["cadence"],
    rainingstime: json["rainingstime"],
    aPowerWatt: json["a_power_watt"],
    aMaxPlus: json["a_max_plus"],
    aAveragePower: json["a_average_power"],
    aCandence: json["a_candence"],
    aRating: json["a_rating"],
    aTrainingstime: json["a_trainingstime"],
    aWeight: json["a_weight"],
    aComment: json["a_comment"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "dates": "${dates.year.toString().padLeft(4, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}",
    "headline": headline,
    "trainingstime_min": trainingstimeMin,
    "power_watt": powerWatt,
    "pulse": pulse,
    "cadence": cadence,
    "rainingstime": rainingstime,
    "a_power_watt": aPowerWatt,
    "a_max_plus": aMaxPlus,
    "a_average_power": aAveragePower,
    "a_candence": aCandence,
    "a_rating": aRating,
    "a_trainingstime": aTrainingstime,
    "a_weight": aWeight,
    "a_comment": aComment,
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
