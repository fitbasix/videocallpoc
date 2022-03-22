// To parse this JSON data, do
//
//     final documentsUsersModel = documentsUsersModelFromJson(jsonString);

import 'dart:convert';

DocumentsUsersModel documentsUsersModelFromJson(String str) => DocumentsUsersModel.fromJson(json.decode(str));

String documentsUsersModelToJson(DocumentsUsersModel data) => json.encode(data.toJson());

class DocumentsUsersModel {
  DocumentsUsersModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory DocumentsUsersModel.fromJson(Map<String, dynamic> json) => DocumentsUsersModel(
    code: json["code"] == null ? null : json["code"],
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
    resStr: json["resStr"] == null ? null : json["resStr"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "response": response == null ? null : response!.toJson(),
    "resStr": resStr == null ? null : resStr,
  };
}

class Response {
  Response({
    this.message,
    this.data,
  });

  String? message;
  List<DataUserDocs>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<DataUserDocs>.from(json["data"].map((x) => DataUserDocs.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DataUserDocs {
  DataUserDocs({
    this.id,
    this.files,
    this.name,
    this.profilePhoto,
  });

  String? id;
  int? files;
  String? name;
  String? profilePhoto;

  factory DataUserDocs.fromJson(Map<String, dynamic> json) => DataUserDocs(
    id: json["_id"] == null ? null : json["_id"],
    files: json["files"] == null ? null : json["files"],
    name: json["name"] == null ? null : json["name"],
    profilePhoto: json["profilePhoto"] == null ? null : json["profilePhoto"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "files": files == null ? null : files,
    "name": name == null ? null : name,
    "profilePhoto": profilePhoto == null ? null : profilePhoto,
  };
}
