// To parse this JSON data, do
//
//     final documentsModel = documentsModelFromJson(jsonString);

import 'dart:convert';

DocumentsModel documentsModelFromJson(String str) => DocumentsModel.fromJson(json.decode(str));

String documentsModelToJson(DocumentsModel data) => json.encode(data.toJson());

class DocumentsModel {
  DocumentsModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
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
  List<AllDocuments>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<AllDocuments>.from(json["data"].map((x) => AllDocuments.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllDocuments {
  AllDocuments({
    this.id,
    this.userId,
    this.trainerId,
    this.senderReceiverMapping,
    this.url,
    this.fileType,
    this.fileName,
    this.sizeInMb,
    this.createdAt,
    this.updatedAt,
    this.showDate
  });

  String? id;
  String? userId;
  String? trainerId;
  String? senderReceiverMapping;
  String? url;
  String? fileType;
  String? fileName;
  double? sizeInMb;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? showDate;

  factory AllDocuments.fromJson(Map<String, dynamic> json) => AllDocuments(
    id: json["_id"] == null ? null : json["_id"],
    userId: json["userId"] == null ? null : json["userId"],
    trainerId: json["trainerId"] == null ? null : json["trainerId"],
    senderReceiverMapping: json["senderReceiverMapping"] == null ? null : json["senderReceiverMapping"],
    url: json["url"] == null ? null : json["url"],
    fileType: json["fileType"] == null ? null : json["fileType"],
    fileName: json["fileName"] == null ? null : json["fileName"],
    sizeInMb: json["sizeInMb"] == null ? null : json["sizeInMb"].toDouble(),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "trainerId": trainerId == null ? null : trainerId,
    "senderReceiverMapping": senderReceiverMapping == null ? null : senderReceiverMapping,
    "url": url == null ? null : url,
    "fileType": fileType == null ? null : fileType,
    "fileName": fileName == null ? null : fileName,
    "sizeInMb": sizeInMb == null ? null : sizeInMb,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
