// To parse this JSON data, do
//
//     final countries = countriesFromJson(jsonString);

import 'dart:convert';

Countries countriesFromJson(String str) => Countries.fromJson(json.decode(str));

String countriesToJson(Countries data) => json.encode(data.toJson());

class Countries {
  Countries({
    this.type,
    this.message,
    this.data,
  });

  final String? type;
  final String? message;
  final List<CountryData>? data;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        type: json["type"],
        message: json["message"],
        data: List<CountryData>.from(
            json["data"].map((x) => CountryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CountryData {
  CountryData({
    this.id,
    this.name,
    this.code,
    this.flag,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? code;
  final String? flag;
  final int? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json["_id"],
        name: json["name"],
        code: "+"+json["code"],
        flag: json["flag"],
        v: json["__v"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "code": code,
        "flag": flag,
        "__v": v,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
