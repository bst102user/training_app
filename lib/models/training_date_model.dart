// To parse this JSON data, do
//
//     final trainingDateModel = trainingDateModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

TrainingDateModel trainingDateModelFromJson(String str) => TrainingDateModel.fromJson(json.decode(str));

String trainingDateModelToJson(TrainingDateModel data) => json.encode(data.toJson());

class TrainingDateModel {
  TrainingDateModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<TrainingDateDatum> data;

  bool isDate(String input, String format) {
    try {
      final DateTime d = DateFormat(format).parseStrict(input);
      //print(d);
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  factory TrainingDateModel.fromJson(Map<String, dynamic> json) => TrainingDateModel(
    status: json["status"],
    msg: json["msg"],
    data: List<TrainingDateDatum>.from(json["data"].map((x) => TrainingDateDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TrainingDateDatum {
  TrainingDateDatum({
    required this.dates,
    required this.totalRainingstime,
    required this.aWeight,
    required this.isUpdate,
  });

  DateTime dates;
  String totalRainingstime;
  String aWeight;
  String isUpdate;

  factory TrainingDateDatum.fromJson(Map<String, dynamic> json) => TrainingDateDatum(
    dates: (json["dates"]==null||json["dates"]=='Date')?DateTime.parse('2022-04-11'):DateTime.parse(json["dates"]),
    totalRainingstime: json["total_rainingstime"],
    aWeight: json["a_weight"],
    isUpdate: json["is_update"],
  );

  Map<String, dynamic> toJson() => {
    "dates": "${dates.year.toString().padLeft(4, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}",
    "total_rainingstime": totalRainingstime,
    "a_weight": aWeight,
    "is_update": isUpdate,
  };
}
