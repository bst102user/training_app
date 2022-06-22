// To parse required this JSON data, do
//
//     final altModel = altModelFromJson(jsonString);

import 'dart:convert';

AltModel altModelFromJson(String str) => AltModel.fromJson(json.decode(str));

String altModelToJson(AltModel data) => json.encode(data.toJson());

class AltModel {
  AltModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<ALTDatum> data;

  factory AltModel.fromJson(Map<String, dynamic> json) => AltModel(
    status: json["status"],
    msg: json["msg"],
    data: List<ALTDatum>.from(json["data"].map((x) => ALTDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ALTDatum {
  ALTDatum({
    required this.id,
    required this.userId,
    required this.dates,
    required this.headline,
    required this.trainingstimeMin,
    required this.breaks,
    required this.powerWatt,
    required this.pulse,
    required this.cadence,
    required this.totalRainingstime,
    required this.aTrainingsTimeMin,
    required this.aPowerWatt,
    required this.aMaxPlus,
    required this.aAveragePower,
    required this.aCandence,
    required this.aRating,
    required this.aTrainingstime,
    required this.aBreaks,
    required this.aWeight,
    required this.aComment,
    required this.isUpdate,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  DateTime dates;
  String headline;
  String trainingstimeMin;
  String breaks;
  String powerWatt;
  String pulse;
  String cadence;
  String totalRainingstime;
  String aTrainingsTimeMin;
  String aPowerWatt;
  String aMaxPlus;
  String aAveragePower;
  String aCandence;
  String aRating;
  String aTrainingstime;
  String aBreaks;
  String aWeight;
  String aComment;
  String isUpdate;
  DateTime createdAt;
  DateTime updatedAt;

  factory ALTDatum.fromJson(Map<String, dynamic> json) => ALTDatum(
    id: json["id"],
    userId: json["user_id"],
    dates: DateTime.parse(json["dates"]),
    headline: json["headline"],
    trainingstimeMin: json["trainingstime_min"],
    breaks: json["breaks"],
    powerWatt: json["power_watt"],
    pulse: json["pulse"],
    cadence: json["cadence"],
    totalRainingstime: json["total_rainingstime"],
    aTrainingsTimeMin: json["a_trainings_time_min"],
    aPowerWatt: json["a_power_watt"],
    aMaxPlus: json["a_max_plus"],
    aAveragePower: json["a_average_power"],
    aCandence: json["a_candence"],
    aRating: json["a_rating"],
    aTrainingstime: json["a_trainingstime"],
    aBreaks: json["a_breaks"],
    aWeight: json["a_weight"],
    aComment: json["a_comment"],
    isUpdate: json["is_update"],
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
    "total_rainingstime": totalRainingstime,
    "a_trainings_time_min": aTrainingsTimeMin,
    "a_power_watt": aPowerWatt,
    "a_max_plus": aMaxPlus,
    "a_average_power": aAveragePower,
    "a_candence": aCandence,
    "a_rating": aRating,
    "a_trainingstime": aTrainingstime,
    "a_breaks": aBreaks,
    "a_weight": aWeight,
    "a_comment": aComment,
    "is_update": isUpdate,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
