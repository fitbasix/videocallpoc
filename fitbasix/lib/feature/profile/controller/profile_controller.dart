import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Home/model/post_feed_model.dart';
import '../../log_in/controller/login_controller.dart';

class ProfileController extends GetxController {
  var val = 0.obs;
  LoginController? mobileNoController;
  TextEditingController emailController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  RxString selectedDate = DateTime(1999).toString().obs;
// height controller for dialog box
  RxString heightType = "inch".obs;
  RxInt currentHeight = 170.obs;
  final heightRulerPickerController = RulerPickerController(value: 0);
// weight controller for dialog box
  RxInt currentWeight = 65.obs;
  RxString weightType = "kg".obs;
  final rulerPickerController = RulerPickerController(value: 2);
  RxList<Post> userPostList = RxList<Post>([]);
  Rx<PostsModel> initialPostData = Rx(PostsModel());
  RxInt currentPage = RxInt(1);
  RxBool showLoading = RxBool(false);
  void editUserPersonalInfo() {
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
    DOBController.text = DateFormat("dd/LL/yyyy").format(DateTime.now());

    super.onInit();
  }
}
