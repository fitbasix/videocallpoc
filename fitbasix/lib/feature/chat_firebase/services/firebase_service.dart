import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseServices {
  static final FirebaseServices firebaseServices = FirebaseServices._private();

  factory FirebaseServices() => firebaseServices;

  FirebaseServices._private();

  final firestoreDatabase = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required BuildContext context,
    required String receiverId,
    required MessageData messageData,
    required String userId,
  }) async {
    try {
      await firestoreDatabase
          .collection('chats')
          .doc(userId)
          .collection('chatRooms')
          .doc(receiverId)
          .collection('messages')
          .add(messageData.toJson());
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

  Stream<QuerySnapshot> getMessageStream({
    required String chatId,
    required String userId,
  }) {
    return firestoreDatabase
        .collection('chats')
        .doc(userId)
        .collection('chatRooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }
}
