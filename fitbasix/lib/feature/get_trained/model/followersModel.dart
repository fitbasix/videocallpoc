// To parse this JSON data, do
//
//     final followerModel = followerModelFromJson(jsonString);

import 'dart:convert';

FollowerModel followerModelFromJson(String str) => FollowerModel.fromJson(json.decode(str));

String followerModelToJson(FollowerModel data) => json.encode(data.toJson());

class FollowerModel {
    FollowerModel({
        required this.code,
        required this.response,
        required this.resStr,
    });

    final int code;
    final Response response;
    final String resStr;

    factory FollowerModel.fromJson(Map<String, dynamic> json) => FollowerModel(
        code: json["code"],
        response: Response.fromJson(json["response"]),
        resStr: json["resStr"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "response": response.toJson(),
        "resStr": resStr,
    };
}

class Response {
    Response({
        required this.message,
        required this.data,
    });

    final String message;
    final List<Datum> data;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.user,
    });

    final String id;
    final User user;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user.toJson(),
    };
}

class User {
    User({
        required this.id,
        required this.profilePhoto,
        required this.name,
    });

    final String id;
    final String profilePhoto;
    final String name;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        profilePhoto: json["profilePhoto"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "profilePhoto": profilePhoto,
        "name": name,
    };
}
