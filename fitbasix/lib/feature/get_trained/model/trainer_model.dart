// To parse this JSON data, do
//
//     final trainer = trainerFromJson(jsonString);

import 'dart:convert';

Trainer trainerFromJson(String str) => Trainer.fromJson(json.decode(str));

String trainerToJson(Trainer data) => json.encode(data.toJson());

class Trainer {
  Trainer({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final TrainerResponse? response;
  final String? resStr;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
        code: json["code"],
        response: TrainerResponse.fromJson(json["response"]),
        resStr: json["resStr"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "response": response!.toJson(),
        "resStr": resStr,
      };
}

class TrainerResponse {
  TrainerResponse({
    this.message,
    this.trainer,
  });

  final String? message;
  final TrainerClass? trainer;

  factory TrainerResponse.fromJson(Map<String, dynamic> json) =>
      TrainerResponse(
        message: json["message"],
        trainer: TrainerClass.fromJson(json["trainer"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "trainer": trainer!.toJson(),
      };
}

class TrainerClass {
  TrainerClass({
    this.id,
    this.about,
    this.trainerType,
    this.isFitnessConsultant,
    this.isNutritionConsultant,
    this.strength,
    this.user,
    this.numOfCertificates,
    this.followers,
    this.following,
    this.trainees,
    this.slotsFeft,
    this.totalRating,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? about;
  final List<String>? trainerType;
  final bool? isFitnessConsultant;
  final bool? isNutritionConsultant;
  final List<String>? strength;
  final User? user;
  final int? numOfCertificates;
  final String? followers;
  final String? following;
  final String? trainees;
  final String? slotsFeft;
  final String? totalRating;
  final String? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory TrainerClass.fromJson(Map<String, dynamic> json) => TrainerClass(
        id: json["_id"],
        about: json["about"],
        trainerType: List<String>.from(json["trainerType"].map((x) => x)),
        isFitnessConsultant: json["isFitnessConsultant"],
        isNutritionConsultant: json["isNutritionConsultant"],
        strength: List<String>.from(json["strength"].map((x) => x)),
        user: User.fromJson(json["user"]),
        numOfCertificates: json["numOfCertificates"],
        followers: json["followers"],
        following: json["following"],
        trainees: json["trainees"],
        slotsFeft: json["slotsFeft"],
        totalRating: json["totalRating"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "about": about,
        "trainerType": List<dynamic>.from(trainerType!.map((x) => x)),
        "isFitnessConsultant": isFitnessConsultant,
        "isNutritionConsultant": isNutritionConsultant,
        "strength": List<dynamic>.from(strength!.map((x) => x)),
        "user": user!.toJson(),
        "numOfCertificates": numOfCertificates,
        "followers": followers,
        "following": following,
        "trainees": trainees,
        "slotsFeft": slotsFeft,
        "totalRating": totalRating,
        "rating": rating,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class User {
  User({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
