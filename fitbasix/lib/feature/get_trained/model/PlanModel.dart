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
    this.data,
    this.message,
  });

  List<Plan>? data;
  String? message;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        data: List<Plan>.from(json["data"].map((x) => Plan.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Plan {
  Plan(
      {this.raters,
      this.id,
      this.createdBy,
      this.planIcon,
      this.planName,
      this.planDuration,
      this.plansRating,
      this.likesCount,
      this.prize,
      this.trainees});

  int? raters;
  String? id;
  String? createdBy;
  String? planIcon;
  String? planName;
  int? planDuration;
  double? plansRating;
  int? likesCount;
  int? prize;
  int? trainees;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
      raters: json["raters"],
      id: json["_id"],
      createdBy: json["trainer"],
      planIcon: json["planIcon"],
      planName: json["planName"],
      planDuration: json["planDuration"],
      plansRating: json["plansRating"].toDouble(),
      likesCount: json["likesCount"],
      trainees: json["trainees"],
      prize: json["prize"]);

  Map<String, dynamic> toJson() => {
        "raters": raters,
        "_id": id,
        "createdBy": createdBy,
        "planIcon": planIcon,
        "planName": planName,
        "planDuration": planDuration,
        "plansRating": plansRating,
        "likesCount": likesCount,
      };
}
