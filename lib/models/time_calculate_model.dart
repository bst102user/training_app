// To parse this JSON data, do
//
//     final timeCalcuateModel = timeCalcuateModelFromJson(jsonString);

import 'dart:convert';

TimeCalcuateModel timeCalcuateModelFromJson(String str) => TimeCalcuateModel.fromJson(json.decode(str));

String timeCalcuateModelToJson(TimeCalcuateModel data) => json.encode(data.toJson());

class TimeCalcuateModel {
  TimeCalcuateModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  String msg;
  List<Datum> data;

  factory TimeCalcuateModel.fromJson(Map<String, dynamic> json) => TimeCalcuateModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.dates,
    required this.id,
    required this.userId,
    required this.rainingstime,
  });

  String dates;
  String id;
  String userId;
  String rainingstime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    dates: json["dates"],
    id: json["id"],
    userId: json["user_id"],
    rainingstime: json["rainingstime"] == null ? null : json["rainingstime"],
  );

  Map<String, dynamic> toJson() => {
    "dates": dates,
    "id": id,
    "user_id": userId,
    "rainingstime": rainingstime == null ? null : rainingstime,
  };
}
