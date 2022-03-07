import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Home/model/post_feed_model.dart';
import '../../log_in/controller/login_controller.dart';

class ProfileController extends GetxController {
  var val = 0.obs;
  LoginController? loginController;
  final HomeController homeController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  RxString selectedDate = DateTime.now().toString().obs;
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
    loginController?.mobile.value;
    //country code
    loginController?.selectedCountry.value;
  }

  void setEditProfileData() async {
    loginController!.mobileController.text = homeController
        .userProfileData.value.response!.data!.profile!.mobileNumber
        .toString();
    loginController!.mobile.value = homeController
        .userProfileData.value.response!.data!.profile!.mobileNumber
        .toString();
    print(loginController!.mobile.value);
    emailController.text = homeController
        .userProfileData.value.response!.data!.profile!.email
        .toString();
    selectedDate.value = homeController
                .userProfileData.value.response!.data!.profile!.dob ==
            null
        ? DateTime.now().toString()
        : DateFormat("dd/LL/yyyy").format(
            homeController.userProfileData.value.response!.data!.profile!.dob!);
    DOBController.text = homeController
                .userProfileData.value.response!.data!.profile!.dob ==
            null
        ? ""
        : DateFormat("dd/LL/yyyy").format(
            homeController.userProfileData.value.response!.data!.profile!.dob!);
    await loginController!.getCountries();
    loginController!.selectedCountry.value = loginController!.countryList
        .singleWhere((element) =>
            element.code ==
            homeController
                .userProfileData.value.response!.data!.profile!.countryCode);
  }

  @override
  Future<void> onInit() async {
    loginController = Get.put(LoginController());
    setEditProfileData();
    super.onInit();
  }
}
