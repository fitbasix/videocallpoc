import 'dart:developer';

import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = RxBool(false);
  RxBool spgStatus = RxBool(false);
  Rx<UserProfileModel> userProfileData = Rx(UserProfileModel());
  Rx<PersonalGoal> personalGoalData = Rx(PersonalGoal());
  Rx<PostsModel> posts = Rx(PostsModel());
  final TextEditingController commentController = TextEditingController();
  RxString comment = RxString('');
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  RxInt currentPage = RxInt(1);
  Rx<WaterDetail> waterDetails = Rx(WaterDetail());
  RxDouble waterLevel = 0.0.obs;
  RxList<Post> trendingPostList = RxList<Post>([]);
  Rx<PostsModel> initialPostData = Rx(PostsModel());
  RxBool showLoader = RxBool(false);

  Future<void> setup() async {
    isLoading.value = true;
    userProfileData.value = await CreatePostService.getUserProfile();
    print(userProfileData.value.response!.data!.profile!.nutrition.toString());
    if (userProfileData
            .value.response!.data!.profile!.nutrition!.totalRequiredCalories !=
        null) {
      personalGoalData.value = await SPGService.updateSPGData(
          null, null, null, null, null, null, null, null, null);
      if (personalGoalData.value.response!.data!.activenessType != null) {
        final SPGController _spgController = Get.put(SPGController());
        _spgController.spgData.value = await SPGService.getSPGData();
        spgStatus.value = true;
        _spgController.selectedGoalIndex.value = _spgController
            .spgData.value.response!.data!.goalType!
            .singleWhere((element) =>
                element.serialId ==
                personalGoalData.value.response!.data!.goalType!);
        _spgController.selectedDate.value =
            personalGoalData.value.response!.data!.dob.toString();
        _spgController.selectedGenderIndex.value = _spgController
            .spgData.value.response!.data!.genderType!
            .singleWhere((element) =>
                element.serialId ==
                personalGoalData.value.response!.data!.genderType!);
        _spgController.currentHeight.value =
            personalGoalData.value.response!.data!.height!;
        _spgController.currentWeight.value =
            personalGoalData.value.response!.data!.currentWeight!;
        _spgController.targetWeight.value =
            personalGoalData.value.response!.data!.targetWeight!;
        _spgController.selectedBodyFat.value =
            personalGoalData.value.response!.data!.genderType == 1
                ? _spgController.spgData.value.response!.data!.bodyTypeMale!
                    .singleWhere((element) =>
                        element.serialId ==
                        personalGoalData.value.response!.data!.bodyType!)
                : _spgController.spgData.value.response!.data!.bodyTypeFemale!
                    .singleWhere((element) =>
                        element.serialId ==
                        personalGoalData.value.response!.data!.bodyType!);
        _spgController.selectedFoodIndex.value = _spgController
            .spgData.value.response!.data!.foodType!
            .singleWhere((element) =>
                element.serialId ==
                personalGoalData.value.response!.data!.foodType!);
        _spgController.activityNumber.value =
            personalGoalData.value.response!.data!.activenessType!.toDouble();
      }
    }
    await getTrendingPost();
    isLoading.value = false;
  }

  Future<void> getTrendingPost({int? skip}) async {
    initialPostData.value = await HomeService.getPosts2(skip: skip);

    if (initialPostData.value.response!.data!.length != 0) {
      trendingPostList.value = initialPostData.value.response!.data!;
    }
  }

  String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat.yMd().add_Hms().parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Future<void> onInit() async {
    setup();
    super.onInit();
  }
}
