import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbasix/feature/call_back_form/model/callBackModel';

class CallBackController extends GetxController {
  String source = "Mobile";
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController query = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  RxBool isclicked = RxBool(false);
  late Rx<CallBackModel> callBackResult = CallBackModel().obs;
}
