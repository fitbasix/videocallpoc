import 'dart:developer';

import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = RxBool(false);
  RxBool spgStatus = RxBool(false);
  Rx<UserProfileModel> userProfileData = Rx(UserProfileModel());
  Rx<PersonalGoal> personalGoalData = Rx(PersonalGoal());
  Rx<PostsModel> posts = Rx(PostsModel());

  Future<void> setup() async {
    isLoading.value = true;
    userProfileData.value = await CreatePostService.getUserProfile();
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
    isLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    setup();
    super.onInit();
  }
}
