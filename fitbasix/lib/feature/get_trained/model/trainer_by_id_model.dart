// To parse this JSON data, do
//
//     final trainerByIdModel = trainerByIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';

TrainerByIdModel trainerByIdModelFromJson(String str) => TrainerByIdModel.fromJson(json.decode(str));

String trainerByIdModelToJson(TrainerByIdModel data) => json.encode(data.toJson());

class TrainerByIdModel {
  TrainerByIdModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory TrainerByIdModel.fromJson(Map<String, dynamic> json) => TrainerByIdModel(
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
  Trainer? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Trainer.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.user,
    this.createdAt,
    this.rating,
    this.slotsLeft,
    this.totalRating,
    this.trainees,
    this.about,
    this.users,
    this.slots,
    this.certificate,
    this.strengths,
    this.trainerTypes,
    this.quickBlox,
    this.isFollowing,
    this.followers,
    this.following,
    this.isEnrolled,
  });

  String? id;
  String? user;
  DateTime? createdAt;
  String? rating;
  int? slotsLeft;
  String? totalRating;
  String? trainees;
  String? about;
  Users? users;
  int? slots;
  DataCertificate? certificate;
  List<Strength>? strengths;
  List<Strength>? trainerTypes;
  int? quickBlox;
  bool? isFollowing;
  int? followers;
  int? following;
  bool? isEnrolled;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"] == null ? null : json["_id"],
    user: json["user"] == null ? null : json["user"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    rating: json["rating"] == null ? null : json["rating"],
    slotsLeft: json["slotsLeft"] == null ? null : json["slotsLeft"],
    totalRating: json["totalRating"] == null ? null : json["totalRating"],
    trainees: json["trainees"] == null ? null : json["trainees"],
    about: json["about"] == null ? null : json["about"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    slots: json["slots"] == null ? null : json["slots"],
    certificate: json["certificate"] == null ? null : DataCertificate.fromJson(json["certificate"]),
    strengths: json["strengths"] == null ? null : List<Strength>.from(json["strengths"].map((x) => Strength.fromJson(x))),
    trainerTypes: json["trainerTypes"] == null ? null : List<Strength>.from(json["trainerTypes"].map((x) => Strength.fromJson(x))),
    quickBlox: json["quickBlox"] == null ? null : json["quickBlox"],
    isFollowing: json["isFollowing"] == null ? null : json["isFollowing"],
    followers: json["followers"] == null ? null : json["followers"],
    following: json["following"] == null ? null : json["following"],
    isEnrolled: json["isEnrolled"] == null ? null : json["isEnrolled"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "user": user == null ? null : user,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "rating": rating == null ? null : rating,
    "slotsLeft": slotsLeft == null ? null : slotsLeft,
    "totalRating": totalRating == null ? null : totalRating,
    "trainees": trainees == null ? null : trainees,
    "about": about == null ? null : about,
    "users": users == null ? null : users!.toJson(),
    "slots": slots == null ? null : slots,
    "certificate": certificate == null ? null : certificate!.toJson(),
    "strengths": strengths == null ? null : List<dynamic>.from(strengths!.map((x) => x.toJson())),
    "trainerTypes": trainerTypes == null ? null : List<dynamic>.from(trainerTypes!.map((x) => x.toJson())),
    "quickBlox": quickBlox == null ? null : quickBlox,
    "isFollowing": isFollowing == null ? null : isFollowing,
    "followers": followers == null ? null : followers,
    "following": following == null ? null : following,
    "isEnrolled": isEnrolled == null ? null : isEnrolled,
  };
}

class DataCertificate {
  DataCertificate({
    this.certificates,
  });

  List<CertificateElement>? certificates;

  factory DataCertificate.fromJson(Map<String, dynamic> json) => DataCertificate(
    certificates: json["certificates"] == null ? null : List<CertificateElement>.from(json["certificates"].map((x) => CertificateElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "certificates": certificates == null ? null : List<dynamic>.from(certificates!.map((x) => x.toJson())),
  };
}

class CertificateElement {
  CertificateElement({
    this.issuedBy,
    this.isVerified,
    this.certificateName,
    this.url,
    this.id,
  });

  String? issuedBy;
  bool? isVerified;
  String? certificateName;
  String? url;
  String? id;

  factory CertificateElement.fromJson(Map<String, dynamic> json) => CertificateElement(
    issuedBy: json["issuedBy"] == null ? null : json["issuedBy"],
    isVerified: json["isVerified"] == null ? null : json["isVerified"],
    certificateName: json["certificateName"] == null ? null : json["certificateName"],
    url: json["url"] == null ? null : json["url"],
    id: json["_id"] == null ? null : json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "issuedBy": issuedBy == null ? null : issuedBy,
    "isVerified": isVerified == null ? null : isVerified,
    "certificateName": certificateName == null ? null : certificateName,
    "url": url == null ? null : url,
    "_id": id == null ? null : id,
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

class Users {
  Users({
    this.id,
    this.name,
    this.profilePhoto,
    this.coverPhoto,
  });

  String? id;
  String? name;
  String? profilePhoto;
  String? coverPhoto;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    profilePhoto: json["profilePhoto"] == null ? null : json["profilePhoto"],
    coverPhoto: json["coverPhoto"] == null ? null : json["coverPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "profilePhoto": profilePhoto == null ? null : profilePhoto,
    "coverPhoto": coverPhoto == null ? null : coverPhoto,
  };
}
