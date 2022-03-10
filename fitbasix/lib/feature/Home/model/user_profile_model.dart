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
  final ProfileResponseData? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: ProfileResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class ProfileResponseData {
  ProfileResponseData({
    this.profile,
  });

  final Profile? profile;

  factory ProfileResponseData.fromJson(Map<String, dynamic> json) =>
      ProfileResponseData(
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile!.toJson(),
      };
}

class Profile {
  Profile(
      {this.id,
      this.name,
      this.profilePhoto,
      this.coverPhoto,
      this.email,
      this.dob,
      this.bio,
      this.countryCode,
      this.mobileNumber,
      this.height,
      this.weight,
      this.gender,
      this.nutrition,
      this.following,
      this.selectedInterest,
      this.followers,
      this.quickBloxId});

  final String? id;
  final String? name;
  final String? profilePhoto;
  final String? coverPhoto;
  final String? mobileNumber;
  final String? email;
  final DateTime? dob;
  final int? gender;
  final String? bio;
  final double? height;
  final double? weight;
  final String? countryCode;
  final List<int>? selectedInterest;
  final Nutrition? nutrition;
  final int? following;
  final int? followers;
  final int? quickBloxId;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["_id"],
      name: json["name"],
      profilePhoto: json["profilePhoto"],
      coverPhoto: json["coverPhoto"],
      mobileNumber: json["phone"],
      email: json["email"],
      countryCode: json["countryCode"],
      bio: json["bio"],
      gender: json["gender"],
      height: json["height"] == null ? null : json["height"].toDouble(),
      weight: json["weight"] == null ? null : json["weight"].toDouble(),
      dob: json["DOB"] == null ? null : DateTime.parse(json["DOB"]),
      nutrition: json["nutrition"] == null
          ? Nutrition()
          : Nutrition.fromJson(json["nutrition"]),
      following: json["following"],

      selectedInterest: List<int>.from(json["interests"].map((x) => x)),

      followers: json["followers"],
      quickBloxId: json["quickBlox"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "coverPhoto": coverPhoto,
        "nutrition": nutrition!.toJson(),
        "following": following,
        "followers": followers,
        "quickBlox": quickBloxId
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
  final double? totalWaterRequired;
  final double? totalWaterConsumed;
  final double? totalRequiredCalories;
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
        totalWaterRequired: json["totalWaterRequired"] == null
            ? null
            : json["totalWaterRequired"].toDouble(),
        totalWaterConsumed: json["totalWaterConsumed"] == null
            ? null
            : json["totalWaterConsumed"].toDouble(),
        totalRequiredCalories: json["totalRequiredCalories"] == null
            ? null
            : json["totalRequiredCalories"].toDouble(),
        protein: json["protein"] == null
            ? Protein()
            : Protein.fromJson(json["protein"]),
        carbs: json["carbs"] == null ? Carbs() : Carbs.fromJson(json["carbs"]),
        fats: json["fats"] == null ? Fats() : Fats.fromJson(json["fats"]),
        // date: DateTime.parse(json["date"]),
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? 1 : json["__v"],
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

  final double? carbsGrams;
  final double? carbsKiloCals;

  factory Carbs.fromJson(Map<String, dynamic> json) => Carbs(
        carbsGrams: json["carbsGrams"].toDouble(),
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

  final double? fatsGrams;
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

  final double? proteinGrams;
  final double? proteinKiloCals;

  factory Protein.fromJson(Map<String, dynamic> json) => Protein(
        proteinGrams: json["proteinGrams"].toDouble(),
        proteinKiloCals: json["proteinKiloCals"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "proteinGrams": proteinGrams,
        "proteinKiloCals": proteinKiloCals,
      };
}
