import 'dart:convert';

TimingModel timingModelFromJson(String str) =>
    TimingModel.fromJson(json.decode(str));

String timingModelToJson(TimingModel data) => json.encode(data.toJson());

class TimingModel {
  TimingModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory TimingModel.fromJson(Map<String, dynamic> json) => TimingModel(
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
  List<Time>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<Time>.from(json["data"].map((x) => Time.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Time {
  Time({
    this.id,
    this.name,
    this.serialId,
  });

  String? id;
  String? name;
  int? serialId;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
      };
}
