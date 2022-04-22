// To parse this JSON data, do
//
//     final thirdPartyLogin = thirdPartyLoginFromJson(jsonString);

import 'dart:convert';

ThirdPartyLogin thirdPartyLoginFromJson(String str) =>
    ThirdPartyLogin.fromJson(json.decode(str));

String thirdPartyLoginToJson(ThirdPartyLogin data) =>
    json.encode(data.toJson());

class ThirdPartyLogin {
  ThirdPartyLogin({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory ThirdPartyLogin.fromJson(Map<String, dynamic> json) =>
      ThirdPartyLogin(
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
    this.user,
    this.screenId,
    this.refreshToken,
  });

  final String? message;
  final UserId? user;
  final int? screenId;
  final String? refreshToken;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
      message: json["message"],
      user: UserId.fromJson(json["user"]),
      screenId: json["screenId"],
      refreshToken: json["refreshToken"]);

  Map<String, dynamic> toJson() => {
        "message": message,
        "userId": user!.toJson(),
        "screenId": screenId,
      };
}

class UserId {
  UserId(
      {this.id,
      this.email,
      this.v,
      this.createdAt,
      this.isBlacklisted,
      this.name,
      this.provider,
      this.role,
      this.updatedAt,
      this.token});

  final String? id;
  final String? email;
  final int? v;
  final DateTime? createdAt;
  final bool? isBlacklisted;
  final String? name;
  final String? provider;
  final String? role;
  final DateTime? updatedAt;
  final String? token;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
      id: json["_id"],
      email: json["email"],
      v: json["__v"],
      createdAt: DateTime.parse(json["createdAt"]),
      isBlacklisted: json["isBlacklisted"],
      name: json["name"],
      provider: json["provider"],
      role: json["role"],
      updatedAt: DateTime.parse(json["updatedAt"]),
      token: json["token"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "__v": v,
        "createdAt": createdAt!.toIso8601String(),
        "isBlacklisted": isBlacklisted,
        "name": name,
        "provider": provider,
        "role": role,
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
