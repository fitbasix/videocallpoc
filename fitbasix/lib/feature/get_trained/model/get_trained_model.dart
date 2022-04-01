// To parse this JSON data, do
//
//     final getTrainerModel = getTrainerModelFromJson(jsonString);

import 'dart:convert';

import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';

GetTrainerModel getTrainerModelFromJson(String str) =>
    GetTrainerModel.fromJson(json.decode(str));

String getTrainerModelToJson(GetTrainerModel data) =>
    json.encode(data.toJson());


GetAllMyTrainers getAllMyTrainersFromJson(String str) => GetAllMyTrainers.fromJson(json.decode(str));

String getAllMyTrainersToJson(GetAllMyTrainers data) => json.encode(data.toJson());

class GetAllMyTrainers {
  GetAllMyTrainers({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  ResponseMyTrainer? response;
  String? resStr;

  factory GetAllMyTrainers.fromJson(Map<String, dynamic> json) => GetAllMyTrainers(
    code: json["code"] == null ? null : json["code"],
    response: json["response"] == null ? null : ResponseMyTrainer.fromJson(json["response"]),
    resStr: json["resStr"] == null ? null : json["resStr"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "response": response == null ? null : response!.toJson(),
    "resStr": resStr == null ? null : resStr,
  };
}

class ResponseMyTrainer {
  ResponseMyTrainer({
    this.message,
    this.data,
  });

  String? message;
  List<MyTrainer>? data;

  factory ResponseMyTrainer.fromJson(Map<String, dynamic> json) => ResponseMyTrainer(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<MyTrainer>.from(json["data"].map((x) => MyTrainer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class GetTrainerModel {
  GetTrainerModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory GetTrainerModel.fromJson(Map<String, dynamic> json) =>
      GetTrainerModel(
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

  final String? message;
  final Data? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.trainers,
    this.fitnessConsultant,
    this.nutritionConsultant,
    this.myTrainers,
  });

  final List<Trainer>? trainers;
  List<MyTrainer>? myTrainers;
  final List<Trainer>? fitnessConsultant;
  final List<Trainer>? nutritionConsultant;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    myTrainers: json["myTrainers"] == null ? null : List<MyTrainer>.from(json["myTrainers"].map((x) => MyTrainer.fromJson(x))),
        trainers: List<Trainer>.from(
            json["trainers"].map((x) => Trainer.fromJson(x))),
        fitnessConsultant: List<Trainer>.from(
            json["fitnessConsultant"].map((x) => Trainer.fromJson(x))),
        nutritionConsultant: List<Trainer>.from(
            json["nutritionConsultant"].map((x) => Trainer.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        "trainers": List<dynamic>.from(trainers!.map((x) => x.toJson())),
        "fitnessConsultant":
            List<dynamic>.from(fitnessConsultant!.map((x) => x.toJson())),
        "nutritionConsultant":
            List<dynamic>.from(nutritionConsultant!.map((x) => x.toJson())),
      };
}

class MyTrainer {
  MyTrainer({
    this.id,
    this.user,
    this.strengths,
    this.isCurrentlyEnrolled,
    this.startDate,
    this.endDate,
    this.name,
    this.profilePhoto,
    this.quickBlox,
    this.time

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
  String? time;

  factory MyTrainer.fromJson(Map<String, dynamic> json) => MyTrainer(
    id: json["_id"] == null ? null : json["_id"],
    user: json["user"] == null ? null : json["user"],
    strengths: json["strengths"] == null ? null : List<Strength>.from(json["strengths"].map((x) => Strength.fromJson(x))),
    isCurrentlyEnrolled: json["isCurrentlyEnrolled"] == null ? null : json["isCurrentlyEnrolled"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    name: json["name"] == null ? null : json["name"],
    profilePhoto: json["profilePhoto"] == null ? null : json["profilePhoto"],
    quickBlox: json["quickBlox"],
    time: json["time"]
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
    name: json["name"],
    serialId: json["serialId"] == null ? null : json["serialId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : nameValues.reverse![name],
    "serialId": serialId == null ? null : serialId,
  };
}
enum Name { ALL_AR, TRAINER_AR, FITNESS_CONSULTANT_AR, FAT_LOSS_AR, NUTRITION_CONSULTANT_AR }

final nameValues = EnumValues({
  "ALL-AR": Name.ALL_AR,
  "Fat Loss-AR": Name.FAT_LOSS_AR,
  "Fitness Consultant-AR": Name.FITNESS_CONSULTANT_AR,
  "Nutrition Consultant-AR": Name.NUTRITION_CONSULTANT_AR,
  "Trainer-AR": Name.TRAINER_AR
});
