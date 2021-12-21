// To parse this JSON data, do
//
//     final countries = countriesFromJson(jsonString);

import 'dart:convert';

Countries countriesFromJson(String str) => Countries.fromJson(json.decode(str));

String countriesToJson(Countries data) => json.encode(data.toJson());

class Countries {
  Countries({
    this.resCode,
    this.response,
    this.resStr,
  });

  final int? resCode;
  final Response? response;
  final String? resStr;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        resCode: json["resCode"],
        response: Response.fromJson(json["response"]),
        resStr: json["resStr"],
      );

  Map<String, dynamic> toJson() => {
        "resCode": resCode,
        "response": response!.toJson(),
        "resStr": resStr,
      };
}

class Response {
  Response({
    this.redCode,
    this.data,
  });

  final int? redCode;
  final List<Datum>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        redCode: json["redCode"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "redCode": redCode,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.countryCode,
    this.phoneCode,
    this.nameEn,
    this.flag,
  });

  final String? countryCode;
  final String? phoneCode;
  final String? nameEn;
  final String? flag;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        countryCode: json["country_code"],
        phoneCode: json["phone_code"],
        nameEn: json["name_en"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "phone_code": phoneCode,
        "name_en": nameEn,
        "flag": flag,
      };
}
