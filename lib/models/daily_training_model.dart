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
  List<Msg> msg;
  List<Datum> data;

  factory DailyTrainingModel.fromJson(Map<String, dynamic> json) => DailyTrainingModel(
    status: json["status"],
    msg: List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.dates,
    required this.headline,
    required this.trainingstimeMin,
    required this.breaks,
    required this.powerWatt,
    required this.pulse,
    required this.cadence,
    required this.aTrainingsTimeMin,
    required this.aPowerWatt,
    required this.aBreaks,
    required this.aMaxPlus,
    required this.aAveragePower,
    required this.aCandence,
    required this.aRating,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  DateTime dates;
  String headline;
  String trainingstimeMin;
  dynamic breaks;
  String powerWatt;
  String pulse;
  String cadence;
  String aTrainingsTimeMin;
  String aPowerWatt;
  String aBreaks;
  String aMaxPlus;
  String aAveragePower;
  String aCandence;
  String aRating;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    dates: DateTime.parse(json["dates"]),
    headline: json["headline"],
    trainingstimeMin: json["trainingstime_min"],
    breaks: json["breaks"],
    powerWatt: json["power_watt"],
    pulse: json["pulse"],
    cadence: json["cadence"],
    aTrainingsTimeMin: json["a_trainings_time_min"],
    aPowerWatt: json["a_power_watt"],
    aBreaks: json["a_breaks"],
    aMaxPlus: json["a_max_plus"],
    aAveragePower: json["a_average_power"],
    aCandence: json["a_candence"],
    aRating: json["a_rating"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "dates": "${dates.year.toString().padLeft(4, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}",
    "headline": headline,
    "trainingstime_min": trainingstimeMin,
    "breaks": breaks,
    "power_watt": powerWatt,
    "pulse": pulse,
    "cadence": cadence,
    "a_trainings_time_min": aTrainingsTimeMin,
    "a_power_watt": aPowerWatt,
    "a_breaks": aBreaks,
    "a_max_plus": aMaxPlus,
    "a_average_power": aAveragePower,
    "a_candence": aCandence,
    "a_rating": aRating,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Msg {
  Msg({
    required this.totalTrainingstime,
    required this.aWeight,
    required this.aComment,
  });

  String totalTrainingstime;
  String aWeight;
  String aComment;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
    totalTrainingstime: json["total_trainingstime"],
    aWeight: json["a_weight"],
    aComment: json["a_comment"],
  );

  Map<String, dynamic> toJson() => {
    "total_trainingstime": totalTrainingstime,
    "a_weight": aWeight,
    "a_comment": aComment,
  };
}
