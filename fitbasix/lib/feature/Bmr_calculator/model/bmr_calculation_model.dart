// To parse this JSON data, do
//
//     final bmrCalculationModel = bmrCalculationModelFromJson(jsonString);
import 'dart:convert';

BmrCalculationModel bmrCalculationModelFromJson(String str) =>
    BmrCalculationModel.fromJson(json.decode(str));

String bmrCalculationModelToJson(BmrCalculationModel data) =>
    json.encode(data.toJson());

class BmrCalculationModel {
  BmrCalculationModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory BmrCalculationModel.fromJson(Map<String, dynamic> json) =>
      BmrCalculationModel(
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
  Bmr? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: Bmr.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class Bmr {
  Bmr({
    this.bmr,
    this.data,
  });

  int? bmr;
  List<BmrResult>? data;

  factory Bmr.fromJson(Map<String, dynamic> json) => Bmr(
        bmr: json["bmr"].toInt(),
        data: List<BmrResult>.from(
            json["data"].map((x) => BmrResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bmr": bmr,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BmrResult {
  BmrResult({
    this.name,
    this.value,
  });

  String? name;
  double? value;

  factory BmrResult.fromJson(Map<String, dynamic> json) => BmrResult(
        name: json["name"],
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
