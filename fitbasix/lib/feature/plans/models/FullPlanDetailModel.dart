import 'dart:convert';

PlanFullDetails planFullDetailsFromJson(String str) =>
    PlanFullDetails.fromJson(json.decode(str));

String planFullDetailsToJson(PlanFullDetails data) =>
    json.encode(data.toJson());

class PlanFullDetails {
  PlanFullDetails({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory PlanFullDetails.fromJson(Map<String, dynamic> json) =>
      PlanFullDetails(
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

  String? message;
  FullPlan? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: FullPlan.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class FullPlan {
  FullPlan({
    this.id,
    this.planName,
    this.planDuration,
    this.planIcon,
    this.description,
    this.likesCount,
    this.plansRating,
    this.raters,
    this.trainees,
    this.keyPoints,
    this.equipments,
    this.trainer,
    this.prize,
    this.isEnrolled,
    this.language,
    this.isDemoAvailable,
    this.isFollowing,
  });

  String? id;
  String? planName;
  int? planDuration;
  String? planIcon;
  String? description;
  String? language;
  int? likesCount;
  double? plansRating;
  int? raters;
  int? trainees;
  List<String>? keyPoints;
  List<String>? equipments;
  TrainerDetail? trainer;
  int? prize;
  bool? isEnrolled;
  bool? isDemoAvailable;
  bool? isFollowing;

  factory FullPlan.fromJson(Map<String, dynamic> json) => FullPlan(
        id: json["_id"],
        planName: json["planName"],
        planDuration: json["planDuration"],
        planIcon: json["planIcon"],
        description: json['description'],
        language: json["planLanguage"],
        likesCount: json["likesCount"],
        plansRating: json["plansRating"].toDouble(),
        raters: json["raters"],
        trainees: json["trainees"],
        keyPoints: json["keyPoints"] == null
            ? []
            : List<String>.from(json["keyPoints"].map((x) => x)),
        equipments: json["equipments"] == null
            ? []
            : List<String>.from(json["equipments"].map((x) => x)),
        trainer: TrainerDetail.fromJson(json["trainer"]),
        prize: json["prize"],
        isEnrolled: json["isEnrolled"],
        isDemoAvailable: json["isDemoAvailable"],
        isFollowing: json["isFollowing"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "planName": planName,
        "planDuration": planDuration,
        "planIcon": planIcon,
        "likesCount": likesCount,
        "plansRating": plansRating,
        "raters": raters,
        "trainees": trainees,
        "keyPoints": List<dynamic>.from(keyPoints!.map((x) => x)),
        "equipments": List<dynamic>.from(equipments!.map((x) => x)),
        "trainer": trainer!.toJson(),
        "prize": prize,
        "isEnrolled": isEnrolled,
        "isDemoAvailable": isDemoAvailable,
        "isFollowing": isFollowing,
      };
}

class TrainerDetail {
  TrainerDetail({
    this.trainerId,
    this.trainees,
    this.rating,
    this.followers,
    this.followings,
    this.isFollowing,
    this.name,
    this.profilePhoto,
  });
  String? trainerId;
  String? trainees;
  String? rating;
  int? followers;
  int? followings;
  String? name;
  bool? isFollowing;
  String? profilePhoto;

  factory TrainerDetail.fromJson(Map<String, dynamic> json) => TrainerDetail(
        trainerId: json["user"],
        trainees: json["trainees"],
        rating: json["rating"],
        followers: json["followers"],
        followings: json["followings"],
        name: json["name"],
        isFollowing: json["isFollowing"],
        profilePhoto: json["profilePhoto"],
      );

  Map<String, dynamic> toJson() => {
        "trainees": trainees,
        "rating": rating,
        "followers": followers,
        "followings": followings,
        "name": name,
        "profilePhoto": profilePhoto,
      };
}
