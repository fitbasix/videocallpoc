import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Home/model/post_feed_model.dart';
import '../../get_trained/model/interest_model.dart';
import '../../get_trained/services/trainer_services.dart';
import '../../log_in/controller/login_controller.dart';

class ProfileController extends GetxController {
  var val = 0.obs;
  LoginController? loginController;
  final HomeController homeController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  TextEditingController bioController = TextEditingController();
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
  RxInt gender = RxInt(0);
  RxBool isLoading = false.obs;
  RxBool showLoading = RxBool(false);
  Rx<InterestModel> interests = InterestModel().obs;
  RxList<int> interestList = <int>[].obs;
  RxString profilePhoto = "".obs;
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
    interestList.value = homeController
        .userProfileData.value.response!.data!.profile!.selectedInterest!;
    loginController!.mobile.value = homeController
        .userProfileData.value.response!.data!.profile!.mobileNumber
        .toString();
    nameController.text = homeController
        .userProfileData.value.response!.data!.profile!.name
        .toString();
    bioController.text =
        homeController.userProfileData.value.response!.data!.profile!.bio ==
                null
            ? ""
            : homeController.userProfileData.value.response!.data!.profile!.bio
                .toString();
    currentWeight.value = homeController
                .userProfileData.value.response!.data!.profile!.weight ==
            null
        ? 65
        : homeController.userProfileData.value.response!.data!.profile!.weight!
            .toInt();
    currentHeight.value = homeController
                .userProfileData.value.response!.data!.profile!.height ==
            null
        ? 120
        : homeController.userProfileData.value.response!.data!.profile!.height!
            .toInt();
    profilePhoto.value = homeController
        .userProfileData.value.response!.data!.profile!.profilePhoto!;
    gender.value = homeController
                .userProfileData.value.response!.data!.profile!.gender ==
            null
        ? 0
        : homeController.userProfileData.value.response!.data!.profile!.gender!;
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
    isLoading.value = true;
    loginController = Get.put(LoginController());
    setEditProfileData();
    interests.value = await TrainerServices.getAllInterest();
    isLoading.value = false;
    super.onInit();
  }
}
