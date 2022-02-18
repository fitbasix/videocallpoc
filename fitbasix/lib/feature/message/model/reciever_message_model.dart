



import 'dart:convert';


// final recievedMessageModel = recievedMessageModelFromJson(jsonString);
//


RecievedMessageModel recievedMessageModelFromJson(String str) => RecievedMessageModel.fromJson(json.decode(str));
//
// String recievedMessageModelToJson(RecievedMessageModel data) => json.encode(data.toJson());

class RecievedMessageModel {
  RecievedMessageModel({
    this.payload,
    this.type,
  });

  Payload? payload;
  String? type;

  factory RecievedMessageModel.fromJson(Map<String, dynamic> json) => RecievedMessageModel(
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "payload": payload == null ? null : payload!.toJson(),
    "type": type == null ? null : type,
  };
}

class Payload {
  Payload({
    this.markable,
    this.senderId,
    this.attachments,
    this.deliveredIds,
    this.readIds,
    this.recipientId,
    this.delayed,
    this.id,
    this.dateSent,
    this.dialogId,
    this.body,
  });

  bool? markable;
  int? senderId;
  List<Attachment>? attachments;
  List<int>? deliveredIds;
  List<int>? readIds;
  int? recipientId;
  bool? delayed;
  String? id;
  int? dateSent;
  String? dialogId;
  String? body;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    markable: json["markable"] == null ? null : json["markable"],
    senderId: json["senderId"] == null ? null : json["senderId"],
    attachments: json["attachments"] == null ? null : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    deliveredIds: json["deliveredIds"] == null ? null : List<int>.from(json["deliveredIds"].map((x) => x)),
    readIds: json["readIds"] == null ? null : List<int>.from(json["readIds"].map((x) => x)),
    recipientId: json["recipientId"] == null ? null : json["recipientId"],
    delayed: json["delayed"] == null ? null : json["delayed"],
    id: json["id"] == null ? null : json["id"],
    dateSent: json["dateSent"] == null ? null : json["dateSent"],
    dialogId: json["dialogId"] == null ? null : json["dialogId"],
    body: json["body"] == null ? null : json["body"],
  );

  Map<String, dynamic> toJson() => {
    "markable": markable == null ? null : markable,
    "senderId": senderId == null ? null : senderId,
    "attachments": attachments == null ? null : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "deliveredIds": deliveredIds == null ? null : List<dynamic>.from(deliveredIds!.map((x) => x)),
    "readIds": readIds == null ? null : List<dynamic>.from(readIds!.map((x) => x)),
    "recipientId": recipientId == null ? null : recipientId,
    "delayed": delayed == null ? null : delayed,
    "id": id == null ? null : id,
    "dateSent": dateSent == null ? null : dateSent,
    "dialogId": dialogId == null ? null : dialogId,
    "body": body == null ? null : body,
  };
}

class Attachment {
  Attachment({
    this.id,
    this.type,
    this.contentType,
    this.url,
  });

  String? id;
  String? type;
  String? contentType;
  String? url;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    contentType: json["contentType"] == null ? null : json["contentType"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "contentType": contentType == null ? null : contentType,
    "url": url == null ? null : url,
  };
}
