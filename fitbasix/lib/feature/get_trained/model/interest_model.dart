// To parse this JSON data, do
//
//     final interestModel = interestModelFromJson(jsonString);

import 'dart:convert';

InterestModel interestModelFromJson(String str) =>
    InterestModel.fromJson(json.decode(str));

String interestModelToJson(InterestModel data) => json.encode(data.toJson());

class InterestModel {
  InterestModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final InterestModelResponse? response;
  final String? resStr;

  factory InterestModel.fromJson(Map<String, dynamic> json) => InterestModel(
        code: json["code"],
        response: InterestModelResponse.fromJson(json["response"]),
        resStr: json["resStr"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "response": response!.toJson(),
        "resStr": resStr,
      };
}

class InterestModelResponse {
  InterestModelResponse({
    this.message,
    this.response,
  });

  final String? message;
  final InterestResponse? response;

  factory InterestModelResponse.fromJson(Map<String, dynamic> json) =>
      InterestModelResponse(
        message: json["message"],
        response: InterestResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "response": response!.toJson(),
      };
}

class InterestResponse {
  InterestResponse({
    this.data,
  });

  final List<Interest>? data;

  factory InterestResponse.fromJson(Map<String, dynamic> json) =>
      InterestResponse(
        data:
            List<Interest>.from(json["data"].map((x) => Interest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Interest {
  Interest({
    this.id,
    this.name,
    this.serialId,
  });

  final String? id;
  final String? name;
  final int? serialId;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
      };
}
