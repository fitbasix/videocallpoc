import 'package:dio/dio.dart';
import 'package:fitbasix/feature/video_call/services/video_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  RxString roomId = ''.obs;
  TextEditingController roomIdText = TextEditingController();
  Future<void> createRoom() async {
    VideoCallService videoCallService = VideoCallService();
    var res = await videoCallService.createRoom();
    roomId.value = res;
    roomIdText.text = res;
  }
}
