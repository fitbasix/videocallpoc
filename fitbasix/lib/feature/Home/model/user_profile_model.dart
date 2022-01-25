// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

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
    this.nutrition,
  });

  final Profile? profile;
  final Nutrition? nutrition;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profile: Profile.fromJson(json["profile"]),
        nutrition: json["nutrition"] == null
            ? null
            : Nutrition.fromJson(json["nutrition"]),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile!.toJson(),
        "nutrition": nutrition!.toJson(),
      };
}

class Nutrition {
  Nutrition({
    this.protein,
    this.carbs,
    this.fats,
    this.id,
    this.userId,
    this.totalWaterRequired,
    this.totalWaterConsumed,
    this.totalRequiredCalories,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final Protein? protein;
  final Carbs? carbs;
  final Fats? fats;
  final String? id;
  final String? userId;
  final int? totalWaterRequired;
  final int? totalWaterConsumed;
  final int? totalRequiredCalories;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        protein: Protein.fromJson(json["protein"]),
        carbs: Carbs.fromJson(json["carbs"]),
        fats: Fats.fromJson(json["fats"]),
        id: json["_id"],
        userId: json["userId"],
        totalWaterRequired: json["totalWaterRequired"],
        totalWaterConsumed: json["totalWaterConsumed"],
        totalRequiredCalories: json["totalRequiredCalories"],
        date: DateTime.parse(json["date"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "protein": protein!.toJson(),
        "carbs": carbs!.toJson(),
        "fats": fats!.toJson(),
        "_id": id,
        "userId": userId,
        "totalWaterRequired": totalWaterRequired,
        "totalWaterConsumed": totalWaterConsumed,
        "totalRequiredCalories": totalRequiredCalories,
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

class Profile {
  Profile({
    this.id,
    this.phone,
    this.v,
    this.countryCode,
    this.createdAt,
    this.isBlacklisted,
    this.numCertificates,
    this.provider,
    this.role,
    this.updatedAt,
    this.token,
    this.email,
    this.name,
    this.profilePhoto,
    this.coverPhoto,
    this.followers,
    this.following,
    this.profileId,
  });

  final String? id;
  final String? phone;
  final int? v;
  final String? countryCode;
  final DateTime? createdAt;
  final bool? isBlacklisted;
  final int? numCertificates;
  final String? provider;
  final String? role;
  final DateTime? updatedAt;
  final String? token;
  final String? email;
  final String? name;
  final String? profilePhoto;
  final String? coverPhoto;
  final int? followers;
  final int? following;
  final String? profileId;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["_id"],
        phone: json["phone"],
        v: json["__v"],
        countryCode: json["countryCode"],
        createdAt: DateTime.parse(json["createdAt"]),
        isBlacklisted: json["isBlacklisted"],
        numCertificates: json["numCertificates"],
        provider: json["provider"],
        role: json["role"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        token: json["token"],
        email: json["email"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        coverPhoto: json["coverPhoto"],
        followers: json["followers"],
        following: json["following"],
        profileId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "__v": v,
        "countryCode": countryCode,
        "createdAt": createdAt!.toIso8601String(),
        "isBlacklisted": isBlacklisted,
        "numCertificates": numCertificates,
        "provider": provider,
        "role": role,
        "updatedAt": updatedAt!.toIso8601String(),
        "token": token,
        "email": email,
        "name": name,
        "profilePhoto": profilePhoto,
        "coverPhoto": coverPhoto,
        "followers": followers,
        "following": following,
        "id": profileId,
      };
}
