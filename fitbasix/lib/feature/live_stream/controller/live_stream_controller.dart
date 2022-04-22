

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamController extends GetxController{
  RxBool isSearchActive = RxBool(false);
  final TextEditingController searchController = TextEditingController();
  RxString pageTitle = RxString('');

  @override
  void onInit() {
    super.onInit();
  }

}