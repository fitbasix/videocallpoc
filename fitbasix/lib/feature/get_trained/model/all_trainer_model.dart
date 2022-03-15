// To parse this JSON data, do
//
//     final allTrainer = allTrainerFromJson(jsonString);

import 'dart:convert';

import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';

AllTrainer allTrainerFromJson(String str) =>
    AllTrainer.fromJson(json.decode(str));

String allTrainerToJson(AllTrainer data) => json.encode(data.toJson());

class AllTrainer {
  AllTrainer({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory AllTrainer.fromJson(Map<String, dynamic> json) => AllTrainer(
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
  });

  final List<Trainer>? trainers;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trainers: List<Trainer>.from(
            json["trainers"].map((x) => Trainer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trainers": List<dynamic>.from(trainers!.map((x) => x.toJson())),
      };
}

class Trainer {
  Trainer({
    this.followers,
    this.following,
    this.trainees,
    this.slotsFeft,
    this.totalRating,
    this.rating,
    this.id,
    this.about,
    this.trainerType,
    this.strength,
    this.user,
    this.numOfCertificates,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isFitnessConsultant,
    this.isNutritionConsultant,
    this.certificates,
    this.isFollowing,
    this.isEnrolled
  });

  String? followers;
  final String? following;
  final String? trainees;
  final int? slotsFeft;
  final String? totalRating;
  final String? rating;
  final String? id;
  final String? about;
  final List<dynamic>? trainerType;
  final List<StrengthElement>? strength;
  final User? user;
  final int? numOfCertificates;
  final List<Strength>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isFitnessConsultant;
  final bool? isNutritionConsultant;
  final List<Certificate>? certificates;
  bool? isFollowing;
  bool? isEnrolled;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
      followers: json["followers"].toString(),
      following: json["following"].toString(),
      trainees: json["trainees"],
      slotsFeft: json["slotsLeft"],
      totalRating: json["totalRating"],
      rating: json["rating"],
      id: json["_id"],
      about: json["about"],
      trainerType: List<dynamic>.from(
          json["trainerType"] == null ? [] : json["trainerType"].map((x) => x)),
      strength: List<StrengthElement>.from(
          json["strengths"].map((x) => StrengthElement.fromJson(x))),
      user: json["users"] == null ? null : User.fromJson(json["users"]),
      numOfCertificates: json["numOfCertificates"],
      // tags:
      //     List<Strength>.from(json["strength"].map((x) => Strength.fromJson(x))),
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      isFitnessConsultant: json["isFitnessConsultant"],
      isNutritionConsultant: json["isNutritionConsultant"],
      certificates: json["certificate"] == null
          ? []
          : List<Certificate>.from(json["certificate"]["certificates"]
              .map((x) => Certificate.fromJson(x))),
      isFollowing: json["isFollowing"],
      isEnrolled: json["isEnrolled"]

  );

  Map<String, dynamic> toJson() => {
        "followers": followers,
        "following": following,
        "trainees": trainees,
        "slotsLeft": slotsFeft,
        "totalRating": totalRating,
        "rating": rating,
        "_id": id,
        "about": about,
        "trainerType": List<dynamic>.from(trainerType!.map((x) => x)),
        "strength": List<String>.from(strength!.map((x) => x)),
        "user": user == null ? null : user!.toJson(),
        "numOfCertificates": numOfCertificates,
        "tags": List<dynamic>.from(tags!.map((x) => x.toJson())),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v,
        "isFitnessConsultant": isFitnessConsultant,
        "isNutritionConsultant": isNutritionConsultant,
        "certificates":
            List<dynamic>.from(certificates!.map((x) => x.toJson())),
      };
}

class Strength {
  Strength({
    this.strength,
  });

  final List<String>? strength;

  factory Strength.fromJson(Map<String, dynamic> json) => Strength(strength: List<String>.from(json["strength"].map((x) => x)),);

  Map<String, dynamic> toJson() => {
        "strength": List<dynamic>.from(strength!.map((x) => x)),
      };
}

// final strengthValues = EnumValues({"ALL": Strength.ALL, "str2": Strength.STR2});

// enum TrainerType { TRAINER, FITNESS_CONSULTATION }

// final trainerTypeValues = EnumValues({
//   "Fitness Consultation": TrainerType.FITNESS_CONSULTATION,
//   "Trainer": TrainerType.TRAINER
// });

class User {
  User({
    this.id,
    this.profilePhoto,
    this.coverPhoto,
    this.name,
  });

  final String? id;
  final String? profilePhoto;
  final String? name;
  final String? coverPhoto;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        profilePhoto: json["profilePhoto"],
        coverPhoto: json["coverPhoto"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "profilePhoto": profilePhoto,
        "name": name,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class StrengthElement {
  StrengthElement({
    this.id,
    this.name,
    this.serialId,
  });

  String? id;
  String? name;
  int? serialId;

  factory StrengthElement.fromJson(Map<String, dynamic> json) =>
      StrengthElement(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
      };
}
