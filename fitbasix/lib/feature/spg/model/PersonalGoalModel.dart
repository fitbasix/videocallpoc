import 'dart:convert';

PersonalGoal personalGoalFromJson(String str) =>
    PersonalGoal.fromJson(json.decode(str));

String personalGoalToJson(PersonalGoal data) => json.encode(data.toJson());

class PersonalGoal {
  PersonalGoal({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory PersonalGoal.fromJson(Map<String, dynamic> json) => PersonalGoal(
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
  GoalData? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: GoalData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class GoalData {
  GoalData({
    this.id,
    this.userId,
    this.v,
    this.activenessType,
    this.goalType,
    this.bodyType,
    this.foodType,
    this.genderType,
  });

  String? id;
  String? userId;
  int? v;
  int? activenessType;
  int? goalType;
  int? bodyType;
  int? foodType;
  int? genderType;

  factory GoalData.fromJson(Map<String, dynamic> json) => GoalData(
        id: json["_id"],
        userId: json["userId"],
        v: json["__v"],
        activenessType: json["activenessType"],
        goalType: json["goalType"],
        bodyType: json["bodyType"],
        foodType: json["foodType"],
        genderType: json["genderType"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "__v": v,
        "activenessType": activenessType,
        "goalType": goalType,
        "bodyType": bodyType,
        "foodType": foodType,
        "genderType": genderType,
      };
}
