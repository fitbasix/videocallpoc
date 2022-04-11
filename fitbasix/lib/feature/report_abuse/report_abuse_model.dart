// To parse this JSON data, do
//
//     final reportAbuseModel = reportAbuseModelFromJson(jsonString);

import 'dart:convert';

ReportAbuseModel reportAbuseModelFromJson(String str) => ReportAbuseModel.fromJson(json.decode(str));

String reportAbuseModelToJson(ReportAbuseModel data) => json.encode(data.toJson());

class ReportAbuseModel {
  ReportAbuseModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory ReportAbuseModel.fromJson(Map<String, dynamic> json) => ReportAbuseModel(
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
  List<ReportAbuse>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"],
    data: List<ReportAbuse>.from(json["data"].map((x) => ReportAbuse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReportAbuse {
  ReportAbuse({
    this.id,
    this.reason,
    this.serialId,
    this.languageCode,
  });

  String? id;
  String? reason;
  int? serialId;
  int? languageCode;

  factory ReportAbuse.fromJson(Map<String, dynamic> json) => ReportAbuse(
    id: json["_id"],
    reason: json["reason"],
    serialId: json["serialId"],
    languageCode: json["languageCode"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "reason": reason,
    "serialId": serialId,
    "languageCode": languageCode,
  };
}
