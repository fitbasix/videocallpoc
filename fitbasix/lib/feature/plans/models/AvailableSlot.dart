import 'dart:convert';

AvailableSlot availableSlotFromJson(String str) =>
    AvailableSlot.fromJson(json.decode(str));

String availableSlotToJson(AvailableSlot data) => json.encode(data.toJson());

class AvailableSlot {
  AvailableSlot({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory AvailableSlot.fromJson(Map<String, dynamic> json) => AvailableSlot(
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
  List<Slot>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<Slot>.from(json["data"].map((x) => Slot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Slot {
  Slot({
    this.id,
    this.trainerId,
    this.time,
    this.day,
    this.date,
    this.planId,
    this.isAvailable,
  });

  String? id;
  String? trainerId;
  dynamic time;
  int? day;
  DateTime? date;
  String? planId;
  int? isAvailable;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["_id"],
        trainerId: json["trainerId"],
        time: json["time"],
        day: json["day"],
        date: DateTime.parse(json["date"]),
        planId: json["planId"],
        isAvailable: json["isAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "trainerId": trainerId,
        "time": time,
        "day": day,
        "date": date!.toIso8601String(),
        "planId": planId,
        "isAvailable": isAvailable,
      };
}
