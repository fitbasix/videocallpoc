// To parse this JSON data, do
//
//     final myTrainersModel = myTrainersModelFromJson(jsonString);

import 'dart:convert';

MyTrainersModel myTrainersModelFromJson(String str) => MyTrainersModel.fromJson(json.decode(str));

String myTrainersModelToJson(MyTrainersModel data) => json.encode(data.toJson());

class MyTrainersModel {
  MyTrainersModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory MyTrainersModel.fromJson(Map<String, dynamic> json) => MyTrainersModel(
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
    this.message,
    this.data,
  });

  String? message;
  List<Datum>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.user,
    this.strengths,
    this.isCurrentlyEnrolled,
    this.startDate,
    this.endDate,
    this.name,
    this.profilePhoto,
    this.quickBlox,
  });

  String? id;
  String? user;
  List<Strength>? strengths;
  bool? isCurrentlyEnrolled;
  DateTime? startDate;
  DateTime? endDate;
  String? name;
  String? profilePhoto;
  int? quickBlox;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"] == null ? null : json["_id"],
    user: json["user"] == null ? null : json["user"],
    strengths: json["strengths"] == null ? null : List<Strength>.from(json["strengths"].map((x) => Strength.fromJson(x))),
    isCurrentlyEnrolled: json["isCurrentlyEnrolled"] == null ? null : json["isCurrentlyEnrolled"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    name: json["name"] == null ? null : json["name"],
    profilePhoto: json["profilePhoto"] == null ? null : json["profilePhoto"],
    quickBlox: json["quickBlox"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "user": user == null ? null : user,
    "strengths": strengths == null ? null : List<dynamic>.from(strengths!.map((x) => x.toJson())),
    "isCurrentlyEnrolled": isCurrentlyEnrolled == null ? null : isCurrentlyEnrolled,
    "startDate": startDate == null ? null : startDate!.toIso8601String(),
    "endDate": endDate == null ? null : endDate!.toIso8601String(),
    "name": name == null ? null : name,
    "profilePhoto": profilePhoto == null ? null : profilePhoto,
    "quickBlox": quickBlox,
  };
}

class Strength {
  Strength({
    this.name,
    this.serialId,
  });

  String? name;
  int? serialId;

  factory Strength.fromJson(Map<String, dynamic> json) => Strength(
    name: json["name"] == null ? null : json["name"],
    serialId: json["serialId"] == null ? null : json["serialId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "serialId": serialId == null ? null : serialId,
  };
}
