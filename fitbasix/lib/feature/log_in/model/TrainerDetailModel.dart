// To parse this JSON data, do
//
//     final trainerModel = trainerModelFromJson(jsonString);

import 'dart:convert';

TrainerModel trainerModelFromJson(String str) =>
    TrainerModel.fromJson(json.decode(str));

String trainerModelToJson(TrainerModel data) => json.encode(data.toJson());

class TrainerModel {
  TrainerModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory TrainerModel.fromJson(Map<String, dynamic> json) => TrainerModel(
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
    this.trainer,
  });

  String? message;
  Trainer? trainer;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        trainer: Trainer.fromJson(json["trainer"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "trainer": trainer!.toJson(),
      };
}

class Trainer {
  Trainer({
    this.id,
    this.about,
    this.trainerType,
    this.isFitnessConsultant,
    this.isNutritionConsultant,
    this.strength,
    this.user,
    this.numOfCertificates,
    this.certificates,
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

  String? id;
  String? about;
  List<String>? trainerType;
  bool? isFitnessConsultant;
  bool? isNutritionConsultant;
  List<String>? strength;
  User? user;
  int? numOfCertificates;
  List<Certificate>? certificates;
  String? followers;
  String? following;
  String? trainees;
  String? slotsFeft;
  String? totalRating;
  String? rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
        id: json["_id"],
        about: json["about"],
        trainerType: List<String>.from(json["trainerType"].map((x) => x)),
        isFitnessConsultant: json["isFitnessConsultant"],
        isNutritionConsultant: json["isNutritionConsultant"],
        strength: List<String>.from(json["strength"].map((x) => x)),
        user: User.fromJson(json["user"]),
        numOfCertificates: json["numOfCertificates"],
        certificates: List<Certificate>.from(json["certificates"] == null
            ? []
            : json["certificates"]["certificates"]
                .map((x) => Certificate.fromJson(x))),
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
        "certificates":
            List<dynamic>.from(certificates!.map((x) => x.toJson())),
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

class Certificate {
  Certificate({
    this.id,
    this.trainerId,
    this.issuedBy,
    this.isVerified,
    this.certificateName,
    this.url,
    this.v,
  });

  String? id;
  String? trainerId;
  String? issuedBy;
  bool? isVerified;
  String? certificateName;
  String? url;
  int? v;

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
        id: json["_id"],
        trainerId: json["trainerId"],
        issuedBy: json["issuedBy"],
        isVerified: json["isVerified"],
        certificateName: json["certificateName"],
        url: json["url"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "trainerId": trainerId,
        "issuedBy": issuedBy,
        "isVerified": isVerified,
        "certificateName": certificateName,
        "url": url,
        "__v": v,
      };
}

class User {
  User({
    this.id,
    this.profilePhoto,
    this.name,
    this.coverPhoto,
  });

  String? id;
  String? profilePhoto;
  String? coverPhoto;
  String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"],
      profilePhoto: json["profilePhoto"],
      name: json["name"],
      coverPhoto: json['coverPhoto']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "profilePhoto": profilePhoto,
        "name": name,
        "coverPhoto": coverPhoto
      };
}
