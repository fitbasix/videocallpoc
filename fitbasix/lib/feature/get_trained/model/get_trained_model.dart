// To parse this JSON data, do
//
//     final getTrainerModel = getTrainerModelFromJson(jsonString);

import 'dart:convert';

import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';

GetTrainerModel getTrainerModelFromJson(String str) =>
    GetTrainerModel.fromJson(json.decode(str));

String getTrainerModelToJson(GetTrainerModel data) =>
    json.encode(data.toJson());

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
  });

  final List<Trainer>? trainers;
  final List<Trainer>? fitnessConsultant;
  final List<Trainer>? nutritionConsultant;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
