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
    planDetails: List<PlanDetail>.from(json["planDetails"].map((x) => PlanDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "planDetails": List<dynamic>.from(planDetails!.map((x) => x.toJson())),
  };
}

class PlanDetail {
  PlanDetail({
    this.id,
    this.expiryDate,
    this.weekDays,
    this.trainer,
    this.sessionTime,
    this.planDetails,
  });

  String? id;
  DateTime? expiryDate;
  List<int>? weekDays;
  Trainer? trainer;
  SessionTime? sessionTime;
  PlanDetails? planDetails;

  factory PlanDetail.fromJson(Map<String, dynamic> json) => PlanDetail(
    id: json["_id"],
    expiryDate: DateTime.parse(json["expiryDate"]),
    weekDays: List<int>.from(json["weekDays"].map((x) => x)),
    trainer: Trainer.fromJson(json["trainer"]),
    sessionTime: SessionTime.fromJson(json["sessionTime"]),
    planDetails: PlanDetails.fromJson(json["planDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "expiryDate": expiryDate!.toIso8601String(),
    "weekDays": List<dynamic>.from(weekDays!.map((x) => x)),
    "trainer": trainer!.toJson(),
    "sessionTime": sessionTime!.toJson(),
    "planDetails": planDetails!.toJson(),
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
  });

  String? name;
  String? profilePhoto;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    name: json["name"],
    profilePhoto: json["profilePhoto"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profilePhoto": profilePhoto,
  };
}
