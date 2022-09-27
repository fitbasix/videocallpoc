// To parse this JSON data, do
//
//     final activePlansModel = activePlansModelFromJson(jsonString);

import 'dart:convert';

ActivePlansModel activePlansModelFromJson(String str) => ActivePlansModel.fromJson(json.decode(str));

String activePlansModelToJson(ActivePlansModel data) => json.encode(data.toJson());

class ActivePlansModel {
  ActivePlansModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory ActivePlansModel.fromJson(Map<String, dynamic> json) => ActivePlansModel(
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
    this.planDetails,
  });

  String? message;
  List<PlanDetail>? planDetails;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"],
    planDetails: List<PlanDetail>.from(json["subscriptionData"].map((x) => PlanDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "subscriptionData": List<dynamic>.from(planDetails!.map((x) => x.toJson())),
  };
}
///Added invoicePdf in PlanDetail -- by Pavan S.
class PlanDetail {
  PlanDetail({
    this.id,
    this.expiryDate,
    this.weekDays,
    this.trainer,
    this.sessionTime,
    this.planDetails,
    this.postponeSessionLeft,
    this.invoicePdf
  });

  String? id;
  DateTime? expiryDate;
  List<int>? weekDays;
  Trainer? trainer;
  int? postponeSessionLeft;
  SessionTime? sessionTime;
  PlanDetails? planDetails;
  bool isExpanded = false;
  bool isChangeExpanded = false;
  String? invoicePdf;

  factory PlanDetail.fromJson(Map<String, dynamic> json) => PlanDetail(
    id: json["_id"],
    expiryDate: DateTime.parse(json["expiryDate"]),
    weekDays: List<int>.from(json["weekDays"].map((x) => x)),
    trainer: Trainer.fromJson(json["trainers"]),
    sessionTime: SessionTime.fromJson(json["sessionTime"]),
    planDetails: PlanDetails.fromJson(json["planDetails"]),
    postponeSessionLeft: json["postponeSessionLeft"],
    invoicePdf: json["invoicePdf"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "expiryDate": expiryDate!.toIso8601String(),
    "weekDays": List<dynamic>.from(weekDays!.map((x) => x)),
    "trainers": trainer!.toJson(),
    "sessionTime": sessionTime!.toJson(),
    "planDetails": planDetails!.toJson(),
    "postponeSessionLeft":postponeSessionLeft,
    "invoicePdf": invoicePdf
  };
}

class PlanDetails {
  PlanDetails({
    this.planName,
    this.planDuration,
  });

  String? planName;
  int? planDuration;

  factory PlanDetails.fromJson(Map<String, dynamic> json) => PlanDetails(
    planName: json["planName"],
    planDuration: json["planDuration"],
  );

  Map<String, dynamic> toJson() => {
    "planName": planName,
    "planDuration": planDuration,
  };
}

class SessionTime {
  SessionTime({
    this.name,
  });

  String? name;

  factory SessionTime.fromJson(Map<String, dynamic> json) => SessionTime(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class Trainer {
  Trainer({
    this.name,
    this.profilePhoto,
    this.id,
  });

  String? name;
  String? profilePhoto;
  String? id;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    name: json["name"],
    profilePhoto: json["profilePhoto"],
    id: json["_id"],

  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profilePhoto": profilePhoto,
    "id":id
  };
}
