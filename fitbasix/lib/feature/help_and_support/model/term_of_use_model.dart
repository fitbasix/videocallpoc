// To parse this JSON data, do
//
//     final termOfUseModel = termOfUseModelFromJson(jsonString);

import 'dart:convert';

TermOfUseModel termOfUseModelFromJson(String str) => TermOfUseModel.fromJson(json.decode(str));

String termOfUseModelToJson(TermOfUseModel data) => json.encode(data.toJson());

class TermOfUseModel {
  TermOfUseModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory TermOfUseModel.fromJson(Map<String, dynamic> json) => TermOfUseModel(
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
  Data? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.introduction,
    this.sections,
    this.languageCode,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.description,
  });

  String? id;
  String? introduction;
  List<Section>? sections;
  int? languageCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? description;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    introduction: json["introduction"],
    sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
    languageCode: json["languageCode"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "introduction": introduction,
    "sections": List<dynamic>.from(sections!.map((x) => x.toJson())),
    "languageCode": languageCode,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "description": description,
  };
}

class Section {
  Section({
    this.title,
    this.description,
    this.id,
  });

  String? title;
  String? description;
  String? id;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    title: json["title"],
    description: json["description"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "_id": id,
  };
}
