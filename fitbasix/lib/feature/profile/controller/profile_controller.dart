import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../log_in/controller/login_controller.dart';

class ProfileController extends GetxController{
  var val = 0.obs;
  LoginController? mobileNoController;
TextEditingController emailController = TextEditingController();
TextEditingController DOBController = TextEditingController();



void editUserPersonalInfo(){
  //todo import API for user data updating
  //user email
  emailController.text;
  //user dob
  DOBController.text;
  //mobile no
  mobileNoController?.mobile.value;
  //country code
  mobileNoController?.selectedCountry.value;




}


   
@override
  Future<void> onInit() async {
  DOBController.text = DateFormat("dd/mm/yyyy").format(DateTime.now());

    super.onInit();
  }
}