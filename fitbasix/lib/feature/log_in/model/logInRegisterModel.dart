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
    required this.accessToken,
    required this.refreshToken,
  });

  String accessToken;
  String refreshToken;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
