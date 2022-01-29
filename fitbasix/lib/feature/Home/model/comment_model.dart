// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
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
  final List<Comment>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<Comment>.from(json["data"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    this.id,
    this.postId,
    this.comment,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.reply,
    this.likes,
    this.datumId,
  });

  final String? id;
  final String? postId;
  final String? comment;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final int? reply;
  final int? likes;
  final String? datumId;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        postId: json["postId"],
        comment: json["comment"],
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reply: json["reply"],
        likes: json["likes"],
        datumId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "postId": postId,
        "comment": comment,
        "user": user!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "reply": reply,
        "likes": likes,
        "id": datumId,
      };
}

class User {
  User({
    this.id,
    this.name,
    this.profilePhoto,
    this.userId,
  });

  final String? id;
  final String? name;
  final String? profilePhoto;
  final String? userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        userId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "id": userId,
      };
}
