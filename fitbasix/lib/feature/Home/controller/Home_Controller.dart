import 'dart:developer';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routes/app_routes.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxInt userQuickBloxId = 0.obs;
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
  RxDouble caloriesBurnt = 0.0.obs;
  RxBool waterConsumedDataLoading = false.obs;
  RxBool isConsumptionLoading = false.obs;
  RxBool isNeedToLoadData = true.obs;
  Rx<TimeOfDay> waterTimingFrom = TimeOfDay(hour: 06, minute: 30).obs;
  Rx<TimeOfDay> waterTimingTo = TimeOfDay(hour: 23, minute: 30).obs;
  List<double> Watergoal = [3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0];
  Rx<double> goalWater = 0.0.obs;
  Rx<ReminderSource> waterSource = ReminderSource().obs;
  Rx<WaterReminder> waterReminder = WaterReminder().obs;
  RxString waterStatus = "".obs;
  RxBool iswaterNotificationDataUpdating = false.obs;
  Rx<Post> post = Rx(Post());
  Rx<CommentModel> postComments = Rx(CommentModel());
  RxList<Comments> commentsList = RxList<Comments>([]);
  RxBool commentsLoading = RxBool(false);
  RxBool isExploreSearch = false.obs;
  final TextEditingController searchController = TextEditingController();
  RxString exploreSearchText = "".obs;
  Rx<int> selectedPostCategoryIndex = (-1).obs;
  RxBool isExploreDataLoading = false.obs;
  Rx<PostsModel> explorePostModel = Rx(PostsModel());
  RxList<Post> explorePostList = RxList<Post>([]);
  RxBool nextDataLoad = false.obs;
  RxInt explorePageCount = 1.obs;
  RxBool postLoading = RxBool(false);
  RxInt skipCommentCount = RxInt(1);
  final TextEditingController replyController = TextEditingController();
  RxString reply = RxString('');
  RxList<Comments> replyList = RxList<Comments>([]);
  RxList<bool>? viewReplies = RxList<bool>([]);
  RxList<int> skipReplyList = RxList<int>([]);
  Future<List<Comments>>? future;
  RxBool isPostUpdate = false.obs;
  RxList<String> likedPost = RxList<String>([]);
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: waterTimingFrom.value,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                      primary: hintGrey, onPrimary: kPureBlack),
                  textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(primary: hintGrey))),
              child: child!);
        });
    final date = DateTime.now();
    if (picked != null) {
      final dt = TimeOfDay(hour: picked.hour, minute: picked.minute);
      final format = DateFormat.jm();
      waterTimingFrom.value = dt;
    }
  }

  Future<void> selectTime2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: waterTimingTo.value,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                      primary: hintGrey, onPrimary: kPureBlack),
                  textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(primary: hintGrey))),
              child: child!);
        });
    final date = DateTime.now();
    if (picked != null) {
      final dt =
          DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
      final format = DateFormat.jm();
      waterTimingTo.value = TimeOfDay(hour: picked.hour, minute: picked.minute);
      ;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  String formatedTime(TimeOfDay selectedTime) {
    DateTime tempDate = DateFormat.Hms().parse(selectedTime.hour.toString() +
        ":" +
        selectedTime.minute.toString() +
        ":" +
        '0' +
        ":" +
        '0');
    var dateFormat = DateFormat("h:mm a");
    return (dateFormat.format(tempDate));
  }

  WaterReminder getWaterReminder(int Time) {
    try {
      waterReminder.value = waterSource.value.response!.data!
          .singleWhere((element) => element.serialId == Time);
      return waterReminder.value;
    } catch (e) {
      return waterReminder.value;
    }
  }

  Future<void> getspgData() async {
    if (userProfileData
            .value.response!.data!.profile!.nutrition!.totalRequiredCalories !=
        null) {
      personalGoalData.value = await SPGService.updateSPGData(
          null, null, null, null, null, null, null, null, null);
      if (personalGoalData.value.response!.data!.activenessType != null) {
        final SPGController _spgController = Get.put(SPGController());
        _spgController.spgData.value = await SPGService.getSPGData();
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
  }

  Future<void> setup() async {
    isLoading.value = true;
    userProfileData.value = await CreatePostService.getUserProfile();

    ///todo after
    // if (userProfileData.value.response!.data!.profile!.name == null) {
    //   print("jdfjdsjkg");
    //   Get.deleteAll();
    //   Get.toNamed(RouteName.enterDetails);
    // }
    print(userProfileData.value.response!.data!.profile!.nutrition.toString());
    if (userProfileData
            .value.response!.data!.profile!.nutrition!.totalRequiredCalories !=
        null) {
      spgStatus.value = true;
    }

    isLoading.value = false;
    await getTrendingPost();
  }

  Future<void> getTrendingPost({int? skip}) async {
    isPostUpdate.value = true;
    initialPostData.value = await HomeService.getPosts(skip: skip);

    if (initialPostData.value.response!.data!.length != 0) {
      trendingPostList.value = initialPostData.value.response!.data!;
    }
    print(trendingPostList.value.length.toString() + "length");
    if (trendingPostList.value.length < 5) {
      isNeedToLoadData.value = false;
    }
    isPostUpdate.value = false;
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

  Future<List<Comments>> fetchReplyComment(
      {required String commentId, int? skip, int? limit}) async {
    var replyData = await HomeService.fetchComment(
        commentId: commentId, skip: skip, limit: limit);

    if (replyData.response!.data!.length != 0) {
      for (var item in replyData.response!.data!) {
        replyList.add(item);
      }
      // replyList.addAll(replyData.response!.data!);
    }
    return replyList;
  }

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var calories = prefs.getString('caloriesBurnt');
    if (calories != null) {
      caloriesBurnt.value = double.parse(calories.toString());
    }

    setup();
    super.onInit();
  }
}
