// To parse this JSON data, do
//
//     final spgModel = spgModelFromJson(jsonString);

import 'dart:convert';

SpgModel spgModelFromJson(String str) => SpgModel.fromJson(json.decode(str));

String spgModelToJson(SpgModel data) => json.encode(data.toJson());

class SpgModel {
  SpgModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory SpgModel.fromJson(Map<String, dynamic> json) => SpgModel(
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
    this.genderType,
    this.activenessType,
    this.goalType,
    this.foodType,
    this.bodyTypeMale,
    this.bodyTypeFemale,
    this.setGoalIntroImage,
  });

  final List<Type>? genderType;
  final List<Type>? activenessType;
  final List<Type>? goalType;
  final List<Type>? foodType;
  final List<BodyType>? bodyTypeMale;
  final List<BodyType>? bodyTypeFemale;
  final String? setGoalIntroImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        genderType:
            List<Type>.from(json["genderType"].map((x) => Type.fromJson(x))),
        activenessType: List<Type>.from(
            json["activenessType"].map((x) => Type.fromJson(x))),
        goalType:
            List<Type>.from(json["goalType"].map((x) => Type.fromJson(x))),
        foodType:
            List<Type>.from(json["foodType"].map((x) => Type.fromJson(x))),
        bodyTypeMale: List<BodyType>.from(
            json["bodyTypeMale"].map((x) => BodyType.fromJson(x))),
        bodyTypeFemale: List<BodyType>.from(
            json["bodyTypeFemale"].map((x) => BodyType.fromJson(x))),
        setGoalIntroImage: json["set_goal_intro_image"],
      );

  Map<String, dynamic> toJson() => {
        "genderType": List<dynamic>.from(genderType!.map((x) => x.toJson())),
        "activenessType":
            List<dynamic>.from(activenessType!.map((x) => x.toJson())),
        "goalType": List<dynamic>.from(goalType!.map((x) => x.toJson())),
        "foodType": List<dynamic>.from(foodType!.map((x) => x.toJson())),
        "bodyTypeMale":
            List<dynamic>.from(bodyTypeMale!.map((x) => x.toJson())),
        "bodyTypeFemale":
            List<dynamic>.from(bodyTypeFemale!.map((x) => x.toJson())),
        "set_goal_intro_image": setGoalIntroImage,
      };
}

class Type {
  Type({
    this.id,
    this.name,
    this.serialId,
    this.languageCode,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? name;
  final int? serialId;
  final int? languageCode;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
        languageCode: json["languageCode"],
        image: json["image"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
        "languageCode": languageCode,
        "image": image,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class BodyType {
  BodyType({
    this.id,
    this.name,
    this.serialId,
    this.languageCode,
    this.image,
    this.start,
    this.end,
    this.genderType,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? name;
  final int? serialId;
  final int? languageCode;
  final String? image;
  final int? start;
  final int? end;
  final int? genderType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory BodyType.fromJson(Map<String, dynamic> json) => BodyType(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
        languageCode: json["languageCode"],
        image: json["image"],
        start: json["start"],
        end: json["end"],
        genderType: json["genderType"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
        "languageCode": languageCode,
        "image": image,
        "start": start,
        "end": end,
        "genderType": genderType,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}
