import 'dart:convert';

TimeModel timeModelFromJson(String str) => TimeModel.fromJson(json.decode(str));

String timeModelToJson(TimeModel data) => json.encode(data.toJson());

class TimeModel {
  TimeModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
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
  List<AvailableTime>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<AvailableTime>.from(
            json["data"].map((x) => AvailableTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AvailableTime {
  AvailableTime({
    this.id,
    this.startDate,
    this.endDate,
    this.time,
    this.isAvailable,
  });

  String? id;
  DateTime? startDate;
  DateTime? endDate;
  List<int>? time;
  int? isAvailable;

  factory AvailableTime.fromJson(Map<String, dynamic> json) => AvailableTime(
        id: json["_id"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        time: List<int>.from(json["time"].map((x) => x)),
        isAvailable: json["isAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "startDate": startDate!.toIso8601String(),
        "endDate": endDate!.toIso8601String(),
        "time": List<dynamic>.from(time!.map((x) => x)),
        "isAvailable": isAvailable,
      };
}
