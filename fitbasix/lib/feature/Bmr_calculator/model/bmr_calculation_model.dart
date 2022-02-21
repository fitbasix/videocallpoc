// To parse this JSON data, do
//
//     final bmrCalculationModel = bmrCalculationModelFromJson(jsonString);

import 'dart:convert';

BmrCalculationModel bmrCalculationModelFromJson(String str) => BmrCalculationModel.fromJson(json.decode(str));

String bmrCalculationModelToJson(BmrCalculationModel data) => json.encode(data.toJson());

class BmrCalculationModel {
  BmrCalculationModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory BmrCalculationModel.fromJson(Map<String, dynamic> json) => BmrCalculationModel(
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
    this.bmr,
    this.data,
  });

  double? bmr;
  BmrResult? data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    bmr: json["bmr"].toDouble(),
    data: BmrResult.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "bmr": bmr,
    "data": data!.toJson(),
  };
}

class BmrResult {
  BmrResult({
    this.veryIntenseExerciseDailyEn,
    this.intenseExercise67TimesWeekEn,
    this.dailyIntenseExercise45TimesWeekEn,
    this.exercise45TimesWeekEn,
    this.exercise13TimesWeekEn,
    this.littleNoExerciseEn,
  });

  int? veryIntenseExerciseDailyEn;
  int? intenseExercise67TimesWeekEn;
  int? dailyIntenseExercise45TimesWeekEn;
  int? exercise45TimesWeekEn;
  int? exercise13TimesWeekEn;
  int? littleNoExerciseEn;

  factory BmrResult.fromJson(Map<String, dynamic> json) => BmrResult(
    veryIntenseExerciseDailyEn: json["Very intense exercise daily -EN"],
    intenseExercise67TimesWeekEn: json["Intense exercise 6-7 times/week -EN"],
    dailyIntenseExercise45TimesWeekEn: json["Daily/Intense exercise 4-5 times/week -EN"],
    exercise45TimesWeekEn: json["Exercise 4-5 times/week -EN"],
    exercise13TimesWeekEn: json["Exercise 1-3 times/week -EN"],
    littleNoExerciseEn: json["Little/ no exercise -EN"],
  );

  Map<String, dynamic> toJson() => {
    "Very intense exercise daily -EN": veryIntenseExerciseDailyEn,
    "Intense exercise 6-7 times/week -EN": intenseExercise67TimesWeekEn,
    "Daily/Intense exercise 4-5 times/week -EN": dailyIntenseExercise45TimesWeekEn,
    "Exercise 4-5 times/week -EN": exercise45TimesWeekEn,
    "Exercise 1-3 times/week -EN": exercise13TimesWeekEn,
    "Little/ no exercise -EN": littleNoExerciseEn,
  };
}
