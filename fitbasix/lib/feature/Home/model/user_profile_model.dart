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
    this.profile,
  });

  final Profile? profile;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile!.toJson(),
      };
}

class Profile {
  Profile({
    this.id,
    this.name,
    this.profilePhoto,
    this.coverPhoto,
    this.nutrition,
    this.following,
    this.followers,
  });

  final String? id;
  final String? name;
  final String? profilePhoto;
  final String? coverPhoto;
  final List<Nutrition>? nutrition;
  final int? following;
  final int? followers;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["_id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        coverPhoto: json["coverPhoto"],
        nutrition: List<Nutrition>.from(
            json["nutrition"].map((x) => Nutrition.fromJson(x))),
        following: json["following"],
        followers: json["followers"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "coverPhoto": coverPhoto,
        "nutrition": List<dynamic>.from(nutrition!.map((x) => x.toJson())),
        "following": following,
        "followers": followers,
      };
}

class Nutrition {
  Nutrition({
    this.id,
    this.userId,
    this.totalWaterRequired,
    this.totalWaterConsumed,
    this.totalRequiredCalories,
    this.protein,
    this.carbs,
    this.fats,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? userId;
  final int? totalWaterRequired;
  final int? totalWaterConsumed;
  final int? totalRequiredCalories;
  final Protein? protein;
  final Carbs? carbs;
  final Fats? fats;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        id: json["_id"],
        userId: json["userId"],
        totalWaterRequired: json["totalWaterRequired"],
        totalWaterConsumed: json["totalWaterConsumed"],
        totalRequiredCalories: json["totalRequiredCalories"],
        protein: Protein.fromJson(json["protein"]),
        carbs: Carbs.fromJson(json["carbs"]),
        fats: Fats.fromJson(json["fats"]),
        // date: DateTime.parse(json["date"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "totalWaterRequired": totalWaterRequired,
        "totalWaterConsumed": totalWaterConsumed,
        "totalRequiredCalories": totalRequiredCalories,
        "protein": protein!.toJson(),
        "carbs": carbs!.toJson(),
        "fats": fats!.toJson(),
        "date": date!.toIso8601String(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class Carbs {
  Carbs({
    this.carbsGrams,
    this.carbsKiloCals,
  });

  final int? carbsGrams;
  final double? carbsKiloCals;

  factory Carbs.fromJson(Map<String, dynamic> json) => Carbs(
        carbsGrams: json["carbsGrams"],
        carbsKiloCals: json["carbsKiloCals"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "carbsGrams": carbsGrams,
        "carbsKiloCals": carbsKiloCals,
      };
}

class Fats {
  Fats({
    this.fatsGrams,
    this.fatsKiloCals,
  });

  final int? fatsGrams;
  final double? fatsKiloCals;

  factory Fats.fromJson(Map<String, dynamic> json) => Fats(
        fatsGrams: json["fatsGrams"],
        fatsKiloCals: json["fatsKiloCals"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "fatsGrams": fatsGrams,
        "fatsKiloCals": fatsKiloCals,
      };
}

class Protein {
  Protein({
    this.proteinGrams,
    this.proteinKiloCals,
  });

  final int? proteinGrams;
  final double? proteinKiloCals;

  factory Protein.fromJson(Map<String, dynamic> json) => Protein(
        proteinGrams: json["proteinGrams"],
        proteinKiloCals: json["proteinKiloCals"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "proteinGrams": proteinGrams,
        "proteinKiloCals": proteinKiloCals,
      };
}
