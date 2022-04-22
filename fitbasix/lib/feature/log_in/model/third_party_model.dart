import 'dart:convert';

ThirdPartyModel thirdPartyModelFromJson(String str) =>
    ThirdPartyModel.fromJson(json.decode(str));

String thirdPartyModelToJson(ThirdPartyModel data) =>
    json.encode(data.toJson());

class ThirdPartyModel {
  ThirdPartyModel({
    this.type,
    this.message,
    this.data,
  });

  String? type;
  String? message;
  Data? data;

  factory ThirdPartyModel.fromJson(Map<String, dynamic> json) =>
      ThirdPartyModel(
        type: json["type"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.userId,
    this.screenId,
  });

  String? userId;
  int? screenId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        screenId: json["screenId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "screenId": screenId,
      };
}
