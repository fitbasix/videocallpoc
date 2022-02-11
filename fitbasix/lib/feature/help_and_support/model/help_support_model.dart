

import 'dart:convert';

HelpAndSupportModel helpAndSupportModelFromJson(String str) => HelpAndSupportModel.fromJson(json.decode(str));

String helpAndSupportModelToJson(HelpAndSupportModel data) => json.encode(data.toJson());

class HelpAndSupportModel {
  HelpAndSupportModel({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory HelpAndSupportModel.fromJson(Map<String, dynamic> json) => HelpAndSupportModel(
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
  Data? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.title,
    this.description,
    this.whatsAppNo,
    this.callingNo,
    this.questionsAndAnswers,
    this.languageCode,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? title;
  String? description;
  String? whatsAppNo;
  String? callingNo;
  List<QuestionsAndAnswer>? questionsAndAnswers;
  int? languageCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    whatsAppNo: json["whatsAppNo"],
    callingNo: json["callingNo"],
    questionsAndAnswers: List<QuestionsAndAnswer>.from(json["questionsAndAnswers"].map((x) => QuestionsAndAnswer.fromJson(x))),
    languageCode: json["languageCode"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "whatsAppNo": whatsAppNo,
    "callingNo": callingNo,
    "questionsAndAnswers": List<dynamic>.from(questionsAndAnswers!.map((x) => x.toJson())),
    "languageCode": languageCode,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class QuestionsAndAnswer {
  QuestionsAndAnswer({
    this.question,
    this.answer,
    this.id,
  });

  String? question;
  String? answer;
  String? id;

  factory QuestionsAndAnswer.fromJson(Map<String, dynamic> json) => QuestionsAndAnswer(
    question: json["question"],
    answer: json["answer"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
    "_id": id,
  };
}
