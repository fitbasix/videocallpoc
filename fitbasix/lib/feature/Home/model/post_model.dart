import 'dart:convert';

import 'package:fitbasix/feature/Home/model/post_feed_model.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
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
  final Post? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: Post.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}
