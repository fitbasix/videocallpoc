import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/chat_firebase/services/firebase_service.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class FirebaseChatController extends GetxController {
  String senderId = '';
  String userName = '';
  String senderPhoto = '';

  final firebaseService = FirebaseServices();

  String senderName = '';
  String receiverId = '';

  var fileName = ''.obs;

  var userWantToSendMedia = false.obs;
  var mediaIsUploading = false.obs;

  @override
  void onInit() async {
    getValues();
    super.onInit();
  }

  getValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString('userId')!;
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
    await firebaseService.sendMessage(
      senderId: senderId,
      context: context,
      receiverId: receiverId,
      messageData: MessageData(
        senderName: userName,
        senderId: senderId,
        senderAvatar: senderPhoto,
        message: messageController.text,
        sentAt: DateTime.now().toUtc().toString(),
      ),
    );
  }

  sendMediaMessage() async {
    String filePath = "";
    late String messageType;
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      userWantToSendMedia.value = true;
      mediaIsUploading.value = true;
      filePath = result.files.single.path!;
      fileName.value = result.files[0].name;

      String? fileExtension = lookupMimeType(result.files.single.path!);
      print("extension " + fileExtension.toString());
      if (fileExtension != null) {
        if (fileExtension.startsWith("audio")) {
          messageType = "audio";
        } else if (fileExtension.startsWith("image")) {
          messageType = "image";
        } else if (fileExtension.startsWith("video")) {
          messageType = "video";
        } else {
          messageType = "file";
        }
      }

      try {
        print("extension " + fileExtension.toString());
        var url = await firebaseService.uploadFile(
            File(result.files[0].path!), fileName.value, senderId);
        printInfo(info: "Url $url");
        await firebaseService
            .sendMessage(
                context: Get.context!,
                receiverId: receiverId,
                messageData: MessageData(
                  senderName: userName,
                  senderId: senderId,
                  senderAvatar: senderPhoto,
                  message: '',
                  isMedia: true,
                  mediaUrl: url,
                  mediaName: fileName.value,
                  mediaType: messageType,
                  sentAt: DateTime.now().toUtc().toString(),
                ),
                senderId: senderId)
            .then((value) {
          mediaIsUploading.value = false;
          userWantToSendMedia.value = false;
        });
      } on Exception catch (e) {
        mediaIsUploading.value = false;
        userWantToSendMedia.value = false;
      } on Error catch (e) {
        mediaIsUploading.value = false;
        userWantToSendMedia.value = false;
      }
    } else {
      mediaIsUploading.value = false;
      userWantToSendMedia.value = false;
    }
  }

  Future<XFile?> pickFromCamera({required bool gallery}) async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (file != null) {
      return file;
    } else
      return null;
  }

  void sendImageFromCamera(context, {required bool gallery}) async {
    late String receiverID;
    late String messageType;
    String filePath = "";
    // if (widget.conversation.value.conversationType == "user") {
    //   receiverID = (widget.conversation.value.conversationWith as User).uid;
    // } else {
    //   receiverID = (widget.conversation.value.conversationWith as Group).guid;
    // }
    XFile? pickedFile = await pickFromCamera(gallery: gallery);
    if (pickedFile != null) {
      userWantToSendMedia.value = true;
      mediaIsUploading.value = true;
      fileName.value = pickedFile.name;
      filePath = pickedFile.path;

      String? fileExtension = lookupMimeType(filePath);
      print("extension " + fileExtension.toString());
      if (fileExtension != null) {
        if (fileExtension.startsWith("audio")) {
          messageType = "audio";
        } else if (fileExtension.startsWith("image")) {
          messageType = "image";
        } else if (fileExtension.startsWith("video")) {
          messageType = "video";
        } else {
          messageType = "file";
        }
      }

      try {
        var url = await firebaseService.uploadFile(
            File(filePath), fileName.value, senderId);
        firebaseService.sendMessage(
            context: Get.context!,
            receiverId: receiverId,
            messageData: MessageData(
              senderName: userName,
              senderId: senderId,
              senderAvatar: senderPhoto,
              message: '',
              isMedia: true,
              mediaUrl: url,
              mediaType: messageType,
              sentAt: DateTime.now().toUtc().toString(),
            ),
            senderId: senderId);
        mediaIsUploading.value = false;
        userWantToSendMedia.value = false;
      } on Exception catch (e) {
        print(e.toString());
        mediaIsUploading.value = false;
        userWantToSendMedia.value = false;
      } on Error catch (e) {
        print(e.toString());
        mediaIsUploading.value = false;
        userWantToSendMedia.value = false;
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pick a image first")));
    }
  }
}
