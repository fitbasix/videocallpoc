// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  CategoryModelResponse? response;
  String? resStr;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        code: json["code"],
        response: CategoryModelResponse.fromJson(json["response"]),
        resStr: json["resStr"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "response": response!.toJson(),
        "resStr": resStr,
      };
}

class CategoryModelResponse {
  CategoryModelResponse({
    this.message,
    this.response,
  });

  String? message;
  ResponseResponse? response;

  factory CategoryModelResponse.fromJson(Map<String, dynamic> json) =>
      CategoryModelResponse(
        message: json["message"],
        response: ResponseResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "response": response!.toJson(),
      };
}

class ResponseResponse {
  ResponseResponse({
    this.data,
  });

  List<Category>? data;

  factory ResponseResponse.fromJson(Map<String, dynamic> json) =>
      ResponseResponse(
        data:
            List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.name,
    this.serialId,
  });

  String? name;
  int? serialId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        serialId: json["serialId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "serialId": serialId,
      };
}
