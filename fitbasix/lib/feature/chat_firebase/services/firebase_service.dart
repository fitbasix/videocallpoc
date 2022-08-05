import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/chat_firebase/services/message_service.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseServices {
  static final FirebaseServices firebaseServices = FirebaseServices._private();

  factory FirebaseServices() => firebaseServices;

  FirebaseServices._private();

  final firestoreDatabase = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance.ref();

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

  Future<String> getLastMessage({
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
      var message =  MessageData.fromJson(data.docs[0].data() as Map<String, dynamic>).message;
      printInfo(info: message);
      return message;
    }
    return '';
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
    var reference = firebaseStorage.child(
        '$senderId-${DateTime.now().millisecondsSinceEpoch}-$fileName'); // get a reference to the path of the image directory
    String storagePath = reference.fullPath;
    printInfo(info: 'Uploading to $storagePath');
    var uploadTask =
        await reference.putFile(file).then((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.success) {
        printInfo(info: "Image uploaded Successful");
      } else if (taskSnapshot.state == TaskState.running) {
      } else if (taskSnapshot.state == TaskState.error) {
        printInfo(info: "Image uploaded Failed");
      }
    });
    var url = uploadTask.ref.getDownloadURL();
    printInfo(info: 'Download Url $url');
    return url;
  }
}
