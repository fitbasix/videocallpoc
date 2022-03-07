import 'dart:convert';

AllTimeSlots allTimeSlotsFromJson(String str) =>
    AllTimeSlots.fromJson(json.decode(str));

String allTimeSlotsToJson(AllTimeSlots data) => json.encode(data.toJson());

class AllTimeSlots {
  AllTimeSlots({
    this.code,
    this.response,
    this.resStr,
  });

  int? code;
  Response? response;
  String? resStr;

  factory AllTimeSlots.fromJson(Map<String, dynamic> json) => AllTimeSlots(
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
  List<TimeSlot>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data:
            List<TimeSlot>.from(json["data"].map((x) => TimeSlot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TimeSlot {
  TimeSlot({
    this.id,
    this.name,
    this.serialId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  int? serialId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
