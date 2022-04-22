// To parse this JSON data, do
//
//     final sortByModel = sortByModelFromJson(jsonString);

import 'dart:convert';

SortByModel sortByModelFromJson(String str) => SortByModel.fromJson(json.decode(str));

String sortByModelToJson(SortByModel data) => json.encode(data.toJson());

class SortByModel {
  SortByModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory SortByModel.fromJson(Map<String, dynamic> json) => SortByModel(
    code: json["code"] == null ? null : json["code"],
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
    resStr: json["resStr"] == null ? null : json["resStr"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "response": response == null ? null : response!.toJson(),
    "resStr": resStr == null ? null : resStr,
  };
}

class Response {
  Response({
    this.message,
    this.data,
  });

  String? message;
  List<sortData>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<sortData>.from(json["data"].map((x) => sortData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class sortData {
  sortData({
    this.id,
    this.title,
    this.languageCode,
    this.serialId,
  });

  String? id;
  String? title;
  int? languageCode;
  int? serialId;

  factory sortData.fromJson(Map<String, dynamic> json) => sortData(
    id: json["_id"] == null ? null : json["_id"],
    title: json["title"] == null ? null : json["title"],
    languageCode: json["languageCode"] == null ? null : json["languageCode"],
    serialId: json["serialId"] == null ? null : json["serialId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "title": title == null ? null : title,
    "languageCode": languageCode == null ? null : languageCode,
    "serialId": serialId == null ? null : serialId,
  };
}
