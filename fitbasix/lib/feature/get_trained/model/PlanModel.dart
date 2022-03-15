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
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
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
    data: json["data"] == null ? null : List<Plan>.from(json["data"].map((x) => Plan.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
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
    this.description,
    this.keyPoints,
    this.planIcon,
    this.trainer,
    this.price,
    this.isDemoAvailable,
    this.isEnrolled,
  });

  String? id;
  String? planName;
  int? planDuration;
  int? session;
  String? planType;
  String? description;
  List<String>? keyPoints;
  String? planIcon;
  String? trainer;
  int? price;
  bool? isDemoAvailable;
  bool? isEnrolled;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["_id"] == null ? null : json["_id"],
    planName: json["planName"] == null ? null : json["planName"],
    planDuration: json["planDuration"] == null ? null : json["planDuration"],
    session: json["session"] == null ? null : json["session"],
    planType: json["planType"] == null ? null : json["planType"],
    description: json["description"] == null ? null : json["description"],
    keyPoints: json["keyPoints"] == null ? null : List<String>.from(json["keyPoints"].map((x) => x)),
    planIcon: json["planIcon"] == null ? null : json["planIcon"],
    trainer: json["trainer"] == null ? null : json["trainer"],
    price: json["price"] == null ? null : json["price"],
    isDemoAvailable: json["isDemoAvailable"] == null ? null : json["isDemoAvailable"],
    isEnrolled: json["isEnrolled"] == null ? null : json["isEnrolled"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "planName": planName == null ? null : planName,
    "planDuration": planDuration == null ? null : planDuration,
    "session": session == null ? null : session,
    "planType": planType == null ? null : planType,
    "description": description == null ? null : description,
    "keyPoints": keyPoints == null ? null : List<dynamic>.from(keyPoints!.map((x) => x)),
    "planIcon": planIcon == null ? null : planIcon,
    "trainer": trainer == null ? null : trainer,
    "price": price == null ? null : price,
    "isDemoAvailable": isDemoAvailable == null ? null : isDemoAvailable,
    "isEnrolled": isEnrolled == null ? null : isEnrolled,
  };
}
