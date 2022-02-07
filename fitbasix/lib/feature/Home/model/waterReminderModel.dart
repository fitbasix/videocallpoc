// To parse this JSON data, do
//
//     final reminderSource = reminderSourceFromJson(jsonString);

import 'dart:convert';

ReminderSource reminderSourceFromJson(String str) => ReminderSource.fromJson(json.decode(str));

String reminderSourceToJson(ReminderSource data) => json.encode(data.toJson());

class ReminderSource {
    ReminderSource({
        this.code,
        this.response,
        this.resStr,
    });

    int? code;
    Response? response;
    String? resStr;

    factory ReminderSource.fromJson(Map<String, dynamic> json) => ReminderSource(
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
    List<WaterReminder>? data;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<WaterReminder>.from(json["data"].map((x) => WaterReminder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class WaterReminder {
    WaterReminder({
        this.languageCode,
        this.optionString,
        this.serialId,
    });


    int? languageCode;
    String? optionString;
    int? serialId;

    factory WaterReminder.fromJson(Map<String, dynamic> json) => WaterReminder(
        languageCode: json["languageCode"],
        optionString: json["optionString"],
        serialId: json["serialId"],
    );

    Map<String, dynamic> toJson() => {
        "languageCode": languageCode,
        "optionString": optionString,
        "serialId": serialId,
    };
}
