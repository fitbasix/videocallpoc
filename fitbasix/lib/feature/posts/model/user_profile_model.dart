// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
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
  final Profile? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: Profile.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class Profile {
  Profile({
    this.id,
    this.phone,
    this.v,
    this.countryCode,
    this.createdAt,
    this.numCertificates,
    this.provider,
    this.role,
    this.updatedAt,
    this.coverPhoto,
    this.email,
    this.name,
    this.profilePhoto,
    this.followers,
    this.following,
    this.dataId,
  });

  final String? id;
  final String? phone;
  final int? v;
  final String? countryCode;
  final DateTime? createdAt;
  final int? numCertificates;
  final String? provider;
  final String? role;
  final DateTime? updatedAt;
  final String? coverPhoto;
  final String? email;
  final String? name;
  final String? profilePhoto;
  final int? followers;
  final int? following;
  final String? dataId;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["_id"],
        phone: json["phone"],
        v: json["__v"],
        countryCode: json["countryCode"],
        createdAt: DateTime.parse(json["createdAt"]),
        numCertificates: json["numCertificates"],
        provider: json["provider"],
        role: json["role"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        coverPhoto: json["coverPhoto"],
        email: json["email"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        followers: json["followers"],
        following: json["following"],
        dataId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "__v": v,
        "countryCode": countryCode,
        "createdAt": createdAt!.toIso8601String(),
        "numCertificates": numCertificates,
        "provider": provider,
        "role": role,
        "updatedAt": updatedAt!.toIso8601String(),
        "coverPhoto": coverPhoto,
        "email": email,
        "name": name,
        "profilePhoto": profilePhoto,
        "followers": followers,
        "following": following,
        "id": dataId,
      };
}
