class MessageData {
  String senderId;
  String senderName;
  String senderAvatar;
  String message;
  String sentAt;

  MessageData({
    required this.senderName,
    required this.senderId,
    required this.senderAvatar,
    required this.message,
    required this.sentAt,
  });

  static MessageData fromJson(Map<String, dynamic> json) => MessageData(
        message: json['message'],
        sentAt: json['sentAt'],
        senderName: json['senderName'],
        senderId: json['senderId'],
        senderAvatar: json['senderAvatar'],
      );

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'senderName': senderName,
        'sentAt': sentAt,
        'message': message,
        'senderAvatar': senderAvatar,
      };
}
