// To parse this JSON data, do
//
//     final postponeModel = postponeModelFromJson(jsonString);

import 'dart:convert';

PostponeModel postponeModelFromJson(String str) => PostponeModel.fromJson(json.decode(str));

String postponeModelToJson(PostponeModel data) => json.encode(data.toJson());

class PostponeModel {
  PostponeModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory PostponeModel.fromJson(Map<String, dynamic> json) => PostponeModel(
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
    this.sessionData,
  });

  String? message;
  SessionData? sessionData;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"],
    sessionData: SessionData.fromJson(json["sessionData"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "sessionData": sessionData!.toJson(),
  };
}

class SessionData {
  SessionData({
    this.postponeSessionLeft,
    this.expiryDate,
  });

  int? postponeSessionLeft;
  DateTime? expiryDate;

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
    postponeSessionLeft: json["postponeSessionLeft"],
    expiryDate: DateTime.parse(json["expiryDate"]),
  );

  Map<String, dynamic> toJson() => {
    "postponeSessionLeft": postponeSessionLeft,
    "expiryDate": expiryDate!.toIso8601String(),
  };
}
