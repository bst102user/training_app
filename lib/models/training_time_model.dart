// To parse this JSON data, do
//
//     final trainingTimeCalculate = trainingTimeCalculateFromJson(jsonString);

import 'dart:convert';

TrainingTimeCalculate trainingTimeCalculateFromJson(String str) => TrainingTimeCalculate.fromJson(json.decode(str));

String trainingTimeCalculateToJson(TrainingTimeCalculate data) => json.encode(data.toJson());

class TrainingTimeCalculate {
  TrainingTimeCalculate({
    required this.status,
    required this.msg,
    required this.data,
  });

  String status;
  Msg msg;
  List<Datum> data;

  factory TrainingTimeCalculate.fromJson(Map<String, dynamic> json) => TrainingTimeCalculate(
    status: json["status"],
    msg: Msg.fromJson(json["msg"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg.toJson(),
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

  DateTime dates;
  String id;
  String userId;
  String rainingstime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    dates: DateTime.parse(json["dates"]),
    id: json["id"],
    userId: json["user_id"],
    rainingstime: json["rainingstime"],
  );

  Map<String, dynamic> toJson() => {
    "dates": "${dates.year.toString().padLeft(4, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}",
    "id": id,
    "user_id": userId,
    "rainingstime": rainingstime,
  };
}

class Msg {
  Msg({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
