// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
    ImageModel({
        required this.code,
        required this.response,
        required this.resStr,
    });

    final int code;
    final Response response;
    final String resStr;

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
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
        required this.location,
    });

    final String message;
    final String location;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        location: json["Location"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "Location": location,
    };
}
