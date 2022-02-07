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
    this.isLiked,
    this.postCategory,
    this.likes,
    this.comments,
    this.commentgiven
  });

  final String? id;
  final String? caption;
  final List<String>? files;
  final Location? location;
  final List<Person>? people;
  final DateTime? updatedAt;
  final Person? userId;
  final int? category;
  bool? isLiked;
  final List<PostCategory>? postCategory;
  int? likes;
  final int? comments;
  Comment? commentgiven;

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
        isLiked: json["isLiked"],
        postCategory: List<PostCategory>.from(
            json["postCategory"].map((x) => PostCategory.fromJson(x))),
        likes: json["likes"],
        comments: json["comments"],
        commentgiven:
            json["comment"] == null ? null : Comment.fromJson(json["comment"]),
            
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
        "isLiked": isLiked,
        "postCategory":
            List<dynamic>.from(postCategory!.map((x) => x.toJson())),
        "likes": likes,
        "comments": comments,
        "comment": commentgiven == null ? null : commentgiven!.toJson(),
      };
}

class Comment {
  Comment({
    this.id,
    this.postId,
    this.comment,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.reply,
    this.likes,
    this.commentId,
  });

  String? id;
  String? postId;
  String? comment;
  UserId? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? reply;
  int? likes;
  String? commentId;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        postId: json["postId"],
        comment: json["comment"],
        user: UserId.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reply: json["reply"],
        likes: json["likes"],
        commentId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "postId": postId,
        "comment": comment,
        "user": user!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "reply": reply,
        "likes": likes,
        "id": commentId,
      };
}

class UserId {
  UserId({
    this.id,
    this.name,
    this.profilePhoto,
    this.userIdId,
  });

  String? id;
  String? name;
  String? profilePhoto;
  String? userIdId;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        userIdId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "id": userIdId,
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
        geometry:
            Geometry.fromJson(json["geometry"] == null ? {} : json["geometry"]),
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
