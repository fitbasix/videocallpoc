// To parse this JSON data, do
//
//     final mediaUrl = mediaUrlFromJson(jsonString);

import 'dart:convert';

MediaUrl mediaUrlFromJson(String str) => MediaUrl.fromJson(json.decode(str));

String mediaUrlToJson(MediaUrl data) => json.encode(data.toJson());

class MediaUrl {
  MediaUrl({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory MediaUrl.fromJson(Map<String, dynamic> json) => MediaUrl(
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
  final List<String>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x)),
      };
}
