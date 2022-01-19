// To parse this JSON data, do
//
//     final postData = postDataFromJson(jsonString);

import 'dart:convert';

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));

String postDataToJson(PostData data) => json.encode(data.toJson());

class PostData {
  PostData({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
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

  final String? message;
  final Data? data;

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
  Data(
      {this.location,
      this.id,
      this.v,
      this.createdAt,
      this.files,
      this.isInappropriate,
      this.isPublished,
      this.people,
      this.updatedAt,
      this.userId,
      this.caption,
      this.dataId,
      this.category});

  final Location? location;
  final String? id;
  final int? v;
  final DateTime? createdAt;
  final List<String>? files;
  final bool? isInappropriate;
  final bool? isPublished;
  final List<People>? people;
  final DateTime? updatedAt;
  final String? userId;
  final String? caption;
  final String? dataId;
  final int? category;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        v: json["__v"],
        createdAt: DateTime.parse(json["createdAt"]),
        files: List<String>.from(json["files"].map((x) => x)),
        isInappropriate: json["isInappropriate"],
        isPublished: json["isPublished"],
        category: json["category"],
        people:
            List<People>.from(json['people'].map((x) => People.fromJson(x))),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        caption: json["caption"],
        dataId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "_id": id,
        "__v": v,
        "createdAt": createdAt!.toIso8601String(),
        "files": List<dynamic>.from(files!.map((x) => x)),
        "isInappropriate": isInappropriate,
        "isPublished": isPublished,
        "people": List<dynamic>.from(people!.map((x) => x)),
        "updatedAt": updatedAt!.toIso8601String(),
        "userId": userId,
        "caption": caption,
        "id": dataId,
      };
}

class People {
  People({
    this.id,
    this.name,
    this.personId,
  });

  final String? id;
  final String? name;
  final String? personId;

  factory People.fromJson(Map<String, dynamic> json) => People(
        id: json["_id"],
        name: json["name"],
        personId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "id": personId,
      };
}

class Location {
  Location({
    this.geometry,
    this.placeName,
    this.placeId,
  });

  final Geometry? geometry;
  final List<String>? placeName;
  final String? placeId;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        // geometry: Geometry.fromJson(json["geometry"]),
        placeName: List<String>.from(json["placeName"].map((x) => x)),
        placeId: json["placeId"],
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry!.toJson(),
        "placeName": List<dynamic>.from(placeName!.map((x) => x)),
        "placeId": placeId,
      };
}

class Geometry {
  Geometry({
    this.lat,
    this.lng,
  });

  final String? lat;
  final String? lng;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
