import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/feature/Home/model/RecentCommentModel.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/healthData.dart';
import 'package:fitbasix/feature/message/view/screens/message_list.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routes/app_routes.dart';
import '../../posts/model/UserModel.dart';

class HomeController extends GetxController {
  final RemoteConfig remoteConfig = RemoteConfig.instance;
  RxInt selectedIndex = 0.obs;
  RxInt userQuickBloxId = 0.obs;
  RxBool isLoading = RxBool(true);
  RxBool spgStatus = RxBool(false);
  Rx<double> videoPlayerVolume = 1.0.obs;
  Rx<UserProfileModel> userProfileData = Rx(UserProfileModel());
  Rx<UserProfileModel> individualUserProfileData = Rx(UserProfileModel());
  RxBool isIndividualUserProfileLoading = false.obs;
  RxList<UserData> searchUsersData = [UserData()].obs;
  RxBool isUserSearchLoading = false.obs;
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
  RxList<MonthlyHealthData> monthlyHealthData = [MonthlyHealthData()].obs;
  RxList<MonthlyHealthData> monthlyHealthDataAfterFilter =
      [MonthlyHealthData()].obs;
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
  RxString coverPhoto = "".obs;
  RxString profilePhoto = "".obs;
  RxList<String> likedPost = RxList<String>([]);
  RxBool updateWaterData = false.obs;
  RxString openCommentId = "".obs;

  RxMap<String, Comment?> commentsMap = RxMap<String, Comment?>(
    {},
  );
  RxMap<String, UpdateCount?> updateCount = RxMap<String, UpdateCount?>(
    {},
  );
  RxMap<String, bool?> LikedPostMap = RxMap<String, bool?>(
    {},
  );

  RxString getWaterGoalStatus() {
    HomeController _homeController = Get.find();
    print((_homeController.waterLevel.value *
                _homeController
                    .waterDetails.value.response!.data![0].totalWaterRequired!)
            .toString() +
        "  " +
        _homeController.goalWater.value.toString());
    if (((_homeController.waterLevel.value *
                    _homeController.waterDetails.value.response!.data![0]
                        .totalWaterRequired!) /
                _homeController.goalWater.value) *
            100 <=
        20) {
      return 'Low'.obs;
    } else if (((_homeController.waterLevel.value *
                    _homeController.waterDetails.value.response!.data![0]
                        .totalWaterRequired!) /
                _homeController.goalWater.value) *
            100 <=
        40) {
      return 'Moderate'.obs;
    } else if (((_homeController.waterLevel.value *
                    _homeController.waterDetails.value.response!.data![0]
                        .totalWaterRequired!) /
                _homeController.goalWater.value) *
            100 <=
        60) {
      return 'Good'.obs;
    } else {
      return 'Excellent'.obs;
    }
  }

  RxList<String> alreadyRenderedPostId = <String>[].obs;
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: waterTimingFrom.value,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
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
                  colorScheme: const ColorScheme.light(
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
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
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
    print("test");
    userProfileData.value = await CreatePostService.getUserProfile();

    ///todo after
    if (userProfileData.value.response!.data!.profile!.email == null) {
      Get.deleteAll();
      Get.offAndToNamed(RouteName.enterDetails);
    }

    coverPhoto.value =
        userProfileData.value.response!.data!.profile!.coverPhoto.toString();
    print(userProfileData.value.response!.data!.profile!.nutrition.toString());
    if (userProfileData
            .value.response!.data!.profile!.nutrition!.totalRequiredCalories !=
        null) {
      waterLevel.value = (userProfileData.value.response!.data!.profile!
                  .nutrition!.totalWaterConsumed ??
              0) /
          (userProfileData
              .value.response!.data!.profile!.nutrition!.totalWaterRequired!);
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
      var inputFormat = DateFormat('dd/MM/yyyy');
      var inputDate = inputFormat.parse(dateString);
      String date = DateFormat('dd LLLL yyyy').format(inputDate);
      return date;
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

    var senderChatId = prefs.getString('senderChatId');
    var senderId = prefs.getString('senderId');
    var senderName = prefs.getString('senderName');
    var senderProfilePhoto = prefs.getString('senderProfilePhoto');
    var userIdForCometChat = prefs.getString("userIdForCometChat");

    print(
        '===================> Home Controller $senderChatId $senderId $senderName $senderProfilePhoto');

    if (senderChatId != null && senderId != null) {
      if (userIdForCometChat != null) {
        bool userIsLoggedIn =
            await CometChatService().logInUser(userIdForCometChat);
        if (userIsLoggedIn) {
          Get.to(
            () => MessageList(
              chatId: senderChatId,
              trainerId: senderId,
              profilePicURL: senderProfilePhoto,
              trainerTitle: senderName,
              time: '',
              days: [0],
            ),
          );
        }
      }
    }

    AppState _state = AppState.DATA_NOT_FETCHED;
    var calories = prefs.getString('caloriesBurnt');

    if (calories != null) {
      Future fetchData() async {
        _state = AppState.FETCHING_DATA;
        HealthFactory health = HealthFactory();
        List<HealthDataPoint> _healthDataList = [];
        // define the types to get
        final types = [
          HealthDataType.ACTIVE_ENERGY_BURNED,
          // Uncomment this line on iOS - only available on iOS
          // HealthDataType.DISTANCE_WALKING_RUNNING,
        ];

        // with coresponsing permissions
        final permissions = [HealthDataAccess.READ];

        // get data within the last 24 hours
        final now = DateTime.now();
        final yesterday = now
            .subtract(Duration(hours: int.parse(DateFormat('kk').format(now))));

        // requesting access to the data types before reading them
        // note that strictly speaking, the [permissions] are not
        // needed, since we only want READ access.
        bool requested =
            await health.requestAuthorization(types, permissions: permissions);

        if (requested) {
          try {
            // fetch health data
            String time = DateFormat('kk').format(DateTime.now());
            print(int.parse(time));
            List<HealthDataPoint> healthData =
                await health.getHealthDataFromTypes(yesterday, now, types);

            // save all the new data points (only the first 100)
            _healthDataList.addAll((healthData.length < 100)
                ? healthData
                : healthData.sublist(0, 100));
          } catch (error) {
            print("Exception in getHealthDataFromTypes: $error");
          }

          // filter out duplicates
          //_healthDataList = HealthFactory.removeDuplicates(_healthDataList);
          caloriesBurnt.value = 0.0;
          // print the results
          _healthDataList.forEach((x) {
            caloriesBurnt.value = x.value.toDouble() + caloriesBurnt.value;
          });
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('caloriesBurnt', caloriesBurnt.value.toString());
          // update the UI to display the results
          _state =
              _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
        } else {
          _state = AppState.DATA_NOT_FETCHED;
        }
      }

      fetchData();
    }

    setup();
    super.onInit();
  }
}
