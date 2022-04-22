import 'dart:convert';

RecentCommentModel recentCommentModelFromJson(String str) =>
    RecentCommentModel.fromJson(json.decode(str));

String recentCommentModelToJson(RecentCommentModel data) =>
    json.encode(data.toJson());

class RecentCommentModel {
  RecentCommentModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory RecentCommentModel.fromJson(Map<String, dynamic> json) =>
      RecentCommentModel(
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
  ResponseData? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: ResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class ResponseData {
  ResponseData({
    this.comment,
    this.data,
  });

  Comment? comment;
  UpdateCount? data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        comment:
            json["comment"] == null ? null : Comment.fromJson(json["comment"]),
        data: UpdateCount.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment!.toJson(),
        "data": data!.toJson(),
      };
}

class UpdateCount {
  UpdateCount({
    this.id,
    this.comments,
    this.likes,
  });

  String? id;
  int? comments;
  int? likes;

  factory UpdateCount.fromJson(Map<String, dynamic> json) => UpdateCount(
        id: json["_id"],
        comments: json["comments"],
        likes: json["likes"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "comments": comments,
        "likes": likes,
      };
}

class Comment {
  Comment({
    this.id,
    this.postId,
    this.comment,
    this.user,
    this.createdAt,
    this.likes,
    this.reply,
    this.isLiked,
  });

  String? id;
  String? postId;
  String? comment;
  User? user;
  DateTime? createdAt;
  int? likes;
  int? reply;
  bool? isLiked;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        postId: json["postId"],
        comment: json["comment"],
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        likes: json["likes"],
        reply: json["reply"],
        isLiked: json["isLiked"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "postId": postId,
        "comment": comment,
        "user": user!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "likes": likes,
        "reply": reply,
        "isLiked": isLiked,
      };
}

class User {
  User({
    this.id,
    this.profilePhoto,
    this.name,
  });

  String? id;
  String? profilePhoto;
  String? name;

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
