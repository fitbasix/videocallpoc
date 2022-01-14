import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
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
  List<UserData>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data:
            List<UserData>.from(json["data"].map((x) => UserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.profilePhoto,
    this.trainer,
    this.datumId,
  });

  String? id;
  String? name;
  String? profilePhoto;
  Trainer? trainer;
  String? datumId;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["_id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        trainer:
            json["trainer"] == null ? null : Trainer.fromJson(json["trainer"]),
        datumId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "trainer": trainer == null ? null : trainer!.toJson(),
        "id": datumId,
      };
}

class Trainer {
  Trainer({
    this.id,
    this.trainerType,
    this.user,
  });

  String? id;
  List<String>? trainerType;
  String? user;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
        id: json["_id"],
        trainerType: List<String>.from(json["trainerType"].map((x) => x)),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "trainerType": List<dynamic>.from(trainerType!.map((x) => x)),
        "user": user,
      };
}
