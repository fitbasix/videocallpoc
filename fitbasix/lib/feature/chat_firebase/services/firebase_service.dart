import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/chat_firebase/model/mediaLinkModel.dart';
import 'package:fitbasix/feature/chat_firebase/services/message_service.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;

class FirebaseServices {
  static final FirebaseServices firebaseServices = FirebaseServices._private();

  factory FirebaseServices() => firebaseServices;

  FirebaseServices._private();

  final firestoreDatabase = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  String getChatRoomId(String senderId, String receiverId) {
    if (!(senderId.compareTo(receiverId) > 0)) {
      return "$receiverId\_$senderId";
    } else {
      return "$senderId\_$receiverId";
    }
  }

  Future<void> sendMessage(
      {required BuildContext context,
      required String receiverId,
      required MessageData messageData,
      required String senderId,
      required}) async {
    try {
      await firestoreDatabase
          .collection('chats')
          .doc(getChatRoomId(receiverId, senderId))
          .collection('messages')
          .add(messageData.toJson())
          .then((value) {
        MessageService.sendMessageNotification(
            receiverId: receiverId,
            senderId: senderId,
            message: messageData.message);
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (e.message.toString()),
          ),
        ),
      );
    }
  }

  Future<MessageData?> getLastMessage({
    required String receiverId,
    required String senderId,
  }) async {
    var data = await firestoreDatabase
        .collection('chats')
        .doc(getChatRoomId(senderId, receiverId))
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .get();
    if (data.docs.isNotEmpty) {
      var message =
          MessageData.fromJson(data.docs[0].data() as Map<String, dynamic>);
      return message;
    }
    return null;
  }

  Stream<QuerySnapshot> getMessageStream({
    required String chatId,
  }) {
    return firestoreDatabase
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  Future<String> uploadFile(File file, String fileName, String senderId) async {
    var url = '';
    // var reference = firebaseStorage.ref().child(
    //     '$senderId/${DateTime.now().millisecondsSinceEpoch}_$fileName'); // get a reference to the path of the image directory
    // String storagePath = reference.fullPath;
    // printInfo(info: 'Uploading to $storagePath');
    // var uploadTask = await reference.putFile(file);
    // var data = await uploadTask.ref.getDownloadURL();
    final dio = Dio();
    var formData = FormData();
    formData.files.addAll([
      MapEntry(
          'file',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last)),
    ]);
    dio.options.headers["language"] = "1";
    dio.options.headers['Authorization'] = await LogInService.getAccessToken();
    var result = await dio.post(
      ApiUrl.uploadChatMedia,
      data: formData,
      onSendProgress: (sent, total) {
        Get.Get.find<FirebaseChatController>().uploadProgress.value =
            ((sent / total) * 100).toPrecision(0);
      },
    );
    print(result.data.toString());
    return imageModelFromJson(result.toString()).response.location;
  }
}
