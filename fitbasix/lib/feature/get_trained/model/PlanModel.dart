// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  PlanModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        code: json["code"] == null ? null : json["code"],
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
        resStr: json["resStr"] == null ? null : json["resStr"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "response": response == null ? null : response!.toJson(),
        "resStr": resStr == null ? null : resStr,
      };
}

class Response {
  Response({
    this.data,
    this.message,
  });

  List<Plan>? data;
  String? message;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        data: json["data"] == null
            ? null
            : List<Plan>.from(json["data"].map((x) => Plan.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null ? null : message,
      };
}

class Plan {
  Plan({
    this.id,
    this.planName,
    this.planDuration,
    this.session,
    this.planType,
    this.keyPoints,
    this.price,
    this.createdAt,
    this.equipments,
    this.freeSession,
    this.likesCount,
    this.planDescription,
    this.plansRating,
    this.raters,
    this.sessionDescription,
    this.trainees,
    this.updatedAt,
  });

  String? id;
  String? planName;
  int? planDuration;
  int? session;
  int? freeSession;
  String? planType;
  int? price;
  String? planDescription;
  String? sessionDescription;
  List<String>? keyPoints;
  List<dynamic>? equipments;
  int? likesCount;
  int? plansRating;
  int? raters;
  int? trainees;
  String? createdAt;
  String? updatedAt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    createdAt: json["createdAt"] == null? null:json["createdAt"],
        equipments: json["equipments"] == null
            ? null
            : List<String>.from(json["equipments"].map((x) => x)),
        freeSession: json["freeSession"] == null? null:json["freeSession"],
        likesCount:  json["likesCount"] == null? null:json["likesCount"],
        planDescription: json["planDescription"] == null? null:json["planDescription"],
        plansRating: json["plansRating"] == null? null:json["plansRating"],
        raters:  json["raters"] == null? null:json["raters"],
        sessionDescription: json["sessionDescription"] == null? null:json["sessionDescription"],
        trainees:  json["trainees"] == null? null:json["trainees"],
        updatedAt:  json["updatedAt"] == null? null:json["updatedAt"],
        id: json["_id"] == null ? null : json["_id"],
        planName: json["planName"] == null ? null : json["planName"],
        planDuration:
            json["planDuration"] == null ? null : json["planDuration"],
        session: json["session"] == null ? null : json["session"],
        planType: json["planType"] == null ? null : json["planType"],
        keyPoints: json["keyPoints"] == null
            ? null
            : List<String>.from(json["keyPoints"].map((x) => x)),
        price: json["price"] == null ? null : json["price"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "planName": planName == null ? null : planName,
        "planDuration": planDuration == null ? null : planDuration,
        "session": session == null ? null : session,
        "planType": planType == null ? null : planType,
        "keyPoints": keyPoints == null
            ? null
            : List<dynamic>.from(keyPoints!.map((x) => x)),
        "price": price == null ? null : price,
      };
}
