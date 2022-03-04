import 'dart:convert';

import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';

WaterDetail waterDetailFromJson(String str) =>
    WaterDetail.fromJson(json.decode(str));

String waterDetailToJson(WaterDetail data) => json.encode(data.toJson());

class WaterDetail {
  WaterDetail({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory WaterDetail.fromJson(Map<String, dynamic> json) => WaterDetail(
        code: json["code"],
        response: Response.fromJson(json["response"]),
        resStr: json["resStr"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "response": response!.toJson(),
        "resStr": resStr,
      };
}

class Response {
  Response({
    this.message,
    this.data,
  });

  String? message;
  List<ConsumedWater>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<ConsumedWater>.from(
            json["data"].map((x) => ConsumedWater.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ConsumedWater {
  ConsumedWater({
    this.status,
    this.id,
    this.date,
    this.userId,
    this.v,
    this.createdAt,
    this.expireAt,
    this.sleepTime,
    this.totalWaterConsumed,
    this.totalWaterRequired,
    this.updatedAt,
    this.wakeupTime,
    this.waterReminder,
  });

  String? status;
  String? id;
  String? date;
  String? userId;
  int? v;
  DateTime? createdAt;
  DateTime? expireAt;
  String? sleepTime;
  double? totalWaterConsumed;
  double? totalWaterRequired;
  DateTime? updatedAt;
  String? wakeupTime;
  int? waterReminder;

  factory ConsumedWater.fromJson(Map<String, dynamic> json) => ConsumedWater(
      status: json["status"] == null ? null : json["status"],
      id: json["_id"],
      date: json["date"],
      userId: json["userId"],
      v: json["__v"],
      createdAt: DateTime.parse(json["createdAt"]),
      // expireAt: DateTime.parse(json["expireAt"]),
      sleepTime: json["sleepTime"],
      totalWaterConsumed: json["totalWaterConsumed"].toDouble(),
      totalWaterRequired: json["totalWaterRequired"].toDouble(),
      // updatedAt: DateTime.parse(json["updatedAt"]),
      wakeupTime: json["wakeupTime"],
      waterReminder: json["waterReminder"]);

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "_id": id,
        "date": date,
        "userId": userId,
        "__v": v,
        "createdAt": createdAt!.toIso8601String(),
        "expireAt": expireAt!.toIso8601String(),
        "sleepTime": sleepTime,
        "totalWaterConsumed": totalWaterConsumed,
        "totalWaterRequired": totalWaterRequired,
        "updatedAt": updatedAt!.toIso8601String(),
        "wakeupTime": wakeupTime,
        "waterReminder": waterReminder
      };
}
