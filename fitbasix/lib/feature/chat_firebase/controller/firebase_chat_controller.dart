import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/chat_firebase/services/firebase_service.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseChatController extends GetxController {
  String userId = '';
  String userName = '';
  String senderPhoto = '';

  final firebaseService = FirebaseServices();

  String senderName = '';

  String chatId = '';

  @override
  void onInit() async{
    getValues();
    super.onInit();
  }

  getValues()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId')!;
  }

  var messageController = TextEditingController();

  String getDayString(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime2.day - dateTime1.day == 0) {
      return 'Today';
    } else if (dateTime2.day - dateTime1.day == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM').format(dateTime1);
    }
  }

  sendTextMessage(BuildContext context) async {
    firebaseService.sendMessage(
      userId: userId,
      context: context,
      receiverId: chatId,
      messageData: MessageData(senderName: userName, senderId: userId, senderAvatar: senderPhoto, message: messageController.text, sentAt: DateTime.now().toString(),),
    );
  }
}
