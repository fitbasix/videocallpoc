import 'dart:convert';

LogInRegisterModel logInRegisterModelFromJson(String str) =>
    LogInRegisterModel.fromJson(json.decode(str));

String logInRegisterModelToJson(LogInRegisterModel data) =>
    json.encode(data.toJson());

class LogInRegisterModel {
  LogInRegisterModel({
    this.resCode,
    this.response,
    this.resStr,
  });

  int? resCode;
  Response? response;
  String? resStr;

  factory LogInRegisterModel.fromJson(Map<String, dynamic> json) =>
      LogInRegisterModel(
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
    this.redStr,
    this.data,
  });

  int? redCode;
  String? redStr;
  AccessData? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        redCode: json["redCode"],
        redStr: json["redStr"],
        data: AccessData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "redCode": redCode,
        "redStr": redStr,
        "data": data!.toJson(),
      };
}

class AccessData {
  AccessData({
    this.accessToken,
    this.refreshToken,
    this.firstName,
  });

  String? accessToken;
  String? refreshToken;
  String? firstName;

  factory AccessData.fromJson(Map<String, dynamic> json) => AccessData(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        firstName: json["firstName"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "firstName": firstName,
      };
}
