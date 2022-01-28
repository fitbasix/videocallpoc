// To parse this JSON data, do
//
//     final postsModel = postsModelFromJson(jsonString);

import 'dart:convert';

PostsModel postsModelFromJson(String str) =>
    PostsModel.fromJson(json.decode(str));

String postsModelToJson(PostsModel data) => json.encode(data.toJson());

class PostsModel {
  PostsModel({
    this.code,
    this.response,
    this.resStr,
  });

  final int? code;
  final Response? response;
  final String? resStr;

  factory PostsModel.fromJson(Map<String, dynamic> json) => PostsModel(
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
  final List<Post>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"],
        data: List<Post>.from(json["data"].map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Post {
  Post({
    this.id,
    this.caption,
    this.files,
    this.location,
    this.people,
    this.updatedAt,
    this.userId,
    this.category,
    this.postCategory,
    this.likes,
    this.comments,
  });

  final String? id;
  final String? caption;
  final List<String>? files;
  final Location? location;
  final List<Person>? people;
  final DateTime? updatedAt;
  final Person? userId;
  final int? category;
  final List<PostCategory>? postCategory;
  final int? likes;
  final int? comments;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        caption: json["caption"],
        files: List<String>.from(json["files"].map((x) => x)),
        location: Location.fromJson(json["location"]),
        people:
            List<Person>.from(json["people"].map((x) => Person.fromJson(x))),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userId: Person.fromJson(json["userId"]),
        category: json["category"] == null ? null : json["category"],
        postCategory: List<PostCategory>.from(
            json["postCategory"].map((x) => PostCategory.fromJson(x))),
        likes: json["likes"],
        comments: json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "caption": caption,
        "files": List<dynamic>.from(files!.map((x) => x)),
        "location": location!.toJson(),
        "people": List<dynamic>.from(people!.map((x) => x.toJson())),
        "updatedAt": updatedAt!.toIso8601String(),
        "userId": userId,
        "category": category == null ? null : category,
        "postCategory":
            List<dynamic>.from(postCategory!.map((x) => x.toJson())),
        "likes": likes,
        "comments": comments,
      };
}

class Location {
  Location({
    this.placeName,
    this.placeId,
    this.geometry,
  });

  final List<dynamic>? placeName;
  final String? placeId;
  final Geometry? geometry;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        placeName: List<dynamic>.from(json['placeName'].map((x) => x)),
        placeId: json["placeId"],
        geometry: Geometry.fromJson(
            json["geometry"] == null ? Geometry() : json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "placeName": List<dynamic>.from(placeName!.map((x) => x)),
        "placeId": placeId,
        "geometry": geometry!.toJson(),
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

class Person {
  Person({
    this.id,
    this.name,
    this.profilePhoto,
    this.personId,
  });

  final String? id;
  final String? name;
  final String? profilePhoto;
  final String? personId;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["_id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        personId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "id": personId,
      };
}

class PostCategory {
  PostCategory({
    this.id,
    this.name,
    this.serialId,
  });

  final String? id;
  final String? name;
  final int? serialId;

  factory PostCategory.fromJson(Map<String, dynamic> json) => PostCategory(
        id: json["_id"],
        name: json["name"],
        serialId: json["serialId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialId": serialId,
      };
}
