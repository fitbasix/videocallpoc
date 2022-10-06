import 'dart:convert';
import 'dart:core';

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/view/my_trainers_screen.dart';
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/call_back_form/services/callBackServices.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/view/chat_page.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/Home/model/RecentCommentModel.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/posts/view/tag_people_screen.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/report_abuse/report_abuse_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/tools_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/caloriesDetails.dart';
import 'package:fitbasix/feature/Home/view/widgets/custom_bottom_nav_bar.dart';
import 'package:fitbasix/feature/Home/view/widgets/green_circle_arrow_button.dart';
import 'package:fitbasix/feature/Home/view/widgets/healthData.dart';
import 'package:fitbasix/feature/Home/view/widgets/menu_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/posts/view/create_post.dart';

// import 'package:quickblox_sdk/users/module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/universal_widgets/capitalizeText.dart';
import '../../get_trained/services/trainer_services.dart';
import '../../get_trained/view/get_trained_screen.dart';
import '../../posts/model/UserModel.dart';
import '../../profile/services/profile_services.dart';
import '../../spg/view/set_goal_screen.dart';
import '../controller/individual_user_controller.dart';

class HomeAndTrainerPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var dependencyupdate =
        homeController.remoteConfig.getString('UiDependency');
    var jsonOb = json.decode(dependencyupdate);

    final List<Widget> screens = [
      if (jsonOb['home'] == 1) HomePage(),
      if (jsonOb['get_trained'] == 1) GetTrainedScreen(),

      ///Added the Chat Screen in bottomNavigationBar
      MyTrainersScreen(),
      if (jsonOb['post'] == 1) CreatePostScreen(),
      if (jsonOb['tools'] == 1) const ToolsScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: homeController.drawerKey,
      body: Obx(() => screens[homeController.selectedIndex.value]),
      // bottomNavigationBar: CustomizedBottomAppBar(),
      bottomNavigationBar: CustomBottomNavigationBar(
        length: screens.length,
      ),
      endDrawer: Container(
        width: 300 * SizeConfig.widthMultiplier!,
        child: Drawer(
          child: Obx(
            () => MenuScreen(
                imageCoverPic:
                    homeController.userProfileData.value.response == null
                        ? ""
                        : homeController.coverPhoto.value == ""
                            ? homeController.userProfileData.value.response!
                                .data!.profile!.coverPhoto
                                .toString()
                            : homeController.coverPhoto.value,
                name: homeController.userProfileData.value.response == null
                    ? ""
                    : homeController.userProfileData.value.response!.data!
                        .profile!.name!.capitalize
                        .toString(),
                imageUrl: homeController.userProfileData.value.response == null
                    ? ""
                    : homeController.profilePhoto.value == ""
                        ? homeController.userProfileData.value.response!.data!
                            .profile!.profilePhoto
                            .toString()
                        : homeController.profilePhoto.value),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ReportAbuseController _reportAbuseController =
      Get.put(ReportAbuseController());
  final HomeController _homeController = Get.find();
  final PostController postController = Get.put(PostController());
  TextEditingController searchUserController = TextEditingController();
  RxBool showUserSearch = false.obs;
  int switchValue = 1;

  RxDouble _caloriesData = 0.0.obs;

  fetchCaloriesDataFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(_homeController.caloriesBurnt.value.toString() + ' ttttt');

    _caloriesData.value =
        double.tryParse(prefs.getString('caloriesBurnt') ?? '0.0') ?? 0.0;
    print(prefs.getString('caloriesBurnt'));
    print(_caloriesData.value);
  }

  DateTime? currentBackPressTime;

  @override
  void dispose() {
    super.dispose();
    searchUserController.dispose();
    _reportAbuseController.dispose();
    _homeController.dispose();
    postController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchNotification();

    _homeController.currentPage.value = 1;
    _homeController.scrollController.addListener(() async {
      if (_homeController.isNeedToLoadData.value == true) {
        if (_homeController.scrollController.position.maxScrollExtent ==
                _homeController.scrollController.position.pixels &&
            _homeController.showLoader.value == false) {
          _homeController.showLoader.value = true;
          final postQuery = await HomeService.getPosts(
              skip: _homeController.currentPage.value);

          if (postQuery.response!.data!.length < 5) {
            _homeController.isNeedToLoadData.value = false;
            _homeController.trendingPostList.addAll(postQuery.response!.data!);
            _homeController.showLoader.value = false;

            //return;
          } else {
            if (_homeController.trendingPostList.last.id ==
                postQuery.response!.data!.last.id) {
              _homeController.showLoader.value = false;
              //return;
            }
            print("got here");

            _homeController.trendingPostList.addAll(postQuery.response!.data!);
            _homeController.showLoader.value = false;
          }

          _homeController.currentPage.value++;
          _homeController.showLoader.value = false;
          // setState(() {});
        }
      }
    });
  }

  void fetchNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var senderChatId = prefs.getString('senderChatId');
    var senderId = prefs.getString('senderId');
    var senderName = prefs.getString('senderName');
    var senderProfilePhoto = prefs.getString('senderProfilePhoto');
    var userIdForCometChat = prefs.getString("userIdForCometChat");
    var postId = prefs.getString('postId');

    if (senderId != null) {
      var controller = Get.find<FirebaseChatController>();
      controller.getValues();
      controller.receiverId = senderId;
      controller.senderPhoto = senderProfilePhoto!;
      controller.senderName = senderName!;
      Get.to(
        () => ChatPage(),
      );
    } else if (postId != null) {
      _homeController.commentsList.clear();
      _homeController.viewReplies!.clear();
      _homeController.postLoading.value = true;
      Get.to(PostScreen());
      var post = await HomeService.getPostById(postId);
      _homeController.post.value = post.response!.data!;
      _homeController.postLoading.value = false;
      _homeController.commentsLoading.value = true;
      _homeController.postComments.value =
          await HomeService.fetchComment(postId: postId);

      if (_homeController.postComments.value.response!.data!.isNotEmpty) {
        _homeController.commentsList.value =
            _homeController.postComments.value.response!.data!;
      }
      _homeController.commentsLoading.value = false;
    }
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('close_app_text'.tr),
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {
    fetchCaloriesDataFromStorage();
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    String formatter = DateFormat('MMMd').format(now);
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: kPureWhite,
        //   centerTitle: false,
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     IconButton(
        //         onPressed: () {}, icon: SvgPicture.asset(ImagePath.bellIcon))
        //   ],
        // ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
              child: Obx(() => _homeController.isLoading.value
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CustomizedCircularProgress()),
                    )
                  : RefreshIndicator(
                      backgroundColor: kBlack,
                      color: kGreenColor,
                      onRefresh: _homeController.onTrendingPostRefresh,
                      child: SingleChildScrollView(
                        // key: const PageStorageKey<String>('feed-screen'),
                        controller: _homeController.scrollController,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50 * SizeConfig.heightMultiplier!,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                SizedBox(
                                  height: 10 * SizeConfig.heightMultiplier!,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!,
                                      right: 16 * SizeConfig.widthMultiplier!),
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(
                                        top: 8 * SizeConfig.heightMultiplier!,
                                        bottom:
                                            8 * SizeConfig.heightMultiplier!),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              final ProfileController
                                                  _profileController =
                                                  Get.put(ProfileController());
                                              refreshProfileData();

                                              _profileController
                                                  .setAssetDataForGallery();
                                              _profileController
                                                  .directFromHome.value = true;
                                              Navigator.pushNamed(context,
                                                  RouteName.userprofileinfo);
                                              _profileController
                                                      .initialPostData.value =
                                                  await ProfileServices
                                                      .getUserPosts();

                                              if (_profileController
                                                  .initialPostData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .isNotEmpty) {
                                                _profileController
                                                        .userPostList.value =
                                                    _profileController
                                                        .initialPostData
                                                        .value
                                                        .response!
                                                        .data!;
                                              } else {
                                                _profileController.userPostList
                                                    .clear();
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              constraints: BoxConstraints(
                                                minWidth: Get.width -
                                                    120 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                // maxWidth: Get.width-100*SizeConfig.widthMultiplier!
                                              ),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(30 *
                                                            SizeConfig
                                                                .widthMultiplier!),
                                                    child: Obx(() => CachedNetworkImage(
                                                        imageUrl: _homeController
                                                                    .profilePhoto.value ==
                                                                ""
                                                            ? _homeController
                                                                .userProfileData
                                                                .value
                                                                .response!
                                                                .data!
                                                                .profile!
                                                                .profilePhoto
                                                                .toString()
                                                            : _homeController
                                                                .profilePhoto
                                                                .value,
                                                        placeholder:
                                                            (context, url) =>
                                                                ShimmerEffect(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            ShimmerEffect(),
                                                        fit: BoxFit.cover,
                                                        height: 50 *
                                                            SizeConfig.widthMultiplier!,
                                                        width: 50 * SizeConfig.widthMultiplier!)),
                                                  ),
                                                  SizedBox(
                                                    width: 15 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        // mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          _homeController
                                                                      .userProfileData
                                                                      .value
                                                                      .response ==
                                                                  null
                                                              ? Container()
                                                              : Text(
                                                                  'hi_name'
                                                                      .trParams({
                                                                    'name': _homeController
                                                                        .userProfileData
                                                                        .value
                                                                        .response!
                                                                        .data!
                                                                        .profile!
                                                                        .name!
                                                                        .capitalize
                                                                        .toString()
                                                                  }),
                                                                  style: AppTextStyle.boldBlackText.copyWith(
                                                                      fontSize: 16 *
                                                                          SizeConfig
                                                                              .textMultiplier!,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1
                                                                          ?.color),
                                                                ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          height:
                                              43 * SizeConfig.heightMultiplier!,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                8 *
                                                    SizeConfig
                                                        .heightMultiplier!),
                                            border: Border.all(
                                                color: _homeController
                                                            .userProfileData
                                                            .value
                                                            .response!
                                                            .data!
                                                            .profile!
                                                            .getCallStatus ==
                                                        true
                                                    ? Colors.grey
                                                    : kGreenColor),
                                            color: _homeController
                                                        .userProfileData
                                                        .value
                                                        .response!
                                                        .data!
                                                        .profile!
                                                        .getCallStatus ==
                                                    true
                                                ? Colors.grey
                                                : kGreenColor,
                                          ),
                                          child: GestureDetector(
                                            onTap: _homeController
                                                        .userProfileData
                                                        .value
                                                        .response!
                                                        .data!
                                                        .profile!
                                                        .getCallStatus ==
                                                    true
                                                ? null
                                                : () async {
                                                        await CallBackServices.sendRequest(
                                                            name:
                                                                _homeController.userProfileData.value.response!.data!.profile!.name.toString(),
                                                            email:
                                                                _homeController.userProfileData.value.response!.data!.profile!.email.toString(),
                                                            number: _homeController.userProfileData.value.response!.data!.profile!.mobileNumber.toString(),
                                                            query: _homeController
                                                                .userProfileData
                                                                .value
                                                                .response!
                                                                .data!
                                                                .profile!
                                                                .id
                                                                .toString());
                                                    Get.showSnackbar(
                                                        const GetSnackBar(
                                                      message:
                                                          "Your Request has been sent.",
                                                      backgroundColor:
                                                          kGreenColor,
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ));
                                                  },
                                            child: Text(
                                              "Get a Call back",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 16 * SizeConfig.heightMultiplier!,
                                // ),
                                Obx(
                                  () => _homeController
                                              .userProfileData
                                              .value
                                              .response!
                                              .data!
                                              .profile!
                                              .isPreviousEnrolled ==
                                          true
                                      ? Container()
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: 24 *
                                                  SizeConfig.heightMultiplier!,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16 *
                                                    SizeConfig.widthMultiplier!,
                                                vertical: 11 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                              ),
                                              color: const Color(0xff031402),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 216 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                    child: Text.rich(
                                                      TextSpan(
                                                          text:
                                                              'You can get a lot more out of it.\nStart with our ',
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'demo plan ',
                                                              style: AppTextStyle
                                                                  .black600Text
                                                                  .copyWith(
                                                                      fontSize: 14 *
                                                                          SizeConfig
                                                                              .textMultiplier!,
                                                                      color:
                                                                          kgreen49),
                                                            )
                                                          ]),
                                                      style: AppTextStyle
                                                          .black600Text
                                                          .copyWith(
                                                              fontSize: 14 *
                                                                  SizeConfig
                                                                      .textMultiplier!,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  ?.color),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  //join button
                                                  GestureDetector(
                                                    onTap: () {
                                                      _homeController
                                                          .selectedIndex
                                                          .value = 1;
                                                      //Navigator.pushNamed(context, RouteName.userSetting);
                                                    },
                                                    child: Container(
                                                      height: 36 *
                                                          SizeConfig
                                                              .heightMultiplier!,
                                                      width: 96 *
                                                          SizeConfig
                                                              .widthMultiplier!,
                                                      decoration: BoxDecoration(
                                                        color: kgreen49,
                                                        borderRadius: BorderRadius
                                                            .circular(2 *
                                                                SizeConfig
                                                                    .heightMultiplier!),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'take_demo'.tr,
                                                          style: AppTextStyle
                                                              .black600Text
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1
                                                                      ?.color),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),

                                //live stream
                                // Container(
                                //   padding: EdgeInsets.symmetric(
                                //     horizontal: 16 * SizeConfig.widthMultiplier!,
                                //     vertical: 8 * SizeConfig.heightMultiplier!,
                                //   ),
                                //   color: kBlack,
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         mainAxisAlignment: MainAxisAlignment.start,
                                //         children: [
                                //           Text(
                                //             'Jonathan is streaming live now',
                                //             style: AppTextStyle.black600Text.copyWith(
                                //                 color: Theme.of(context)
                                //                     .textTheme
                                //                     .bodyText1
                                //                     ?.color),
                                //           ),
                                //           SizedBox(
                                //               height:
                                //                   8 * SizeConfig.heightMultiplier!),
                                //           Container(
                                //             padding: EdgeInsets.only(
                                //                 top: 4 * SizeConfig.heightMultiplier!,
                                //                 bottom:
                                //                     4 * SizeConfig.heightMultiplier!,
                                //                 right:
                                //                     8 * SizeConfig.widthMultiplier!,
                                //                 left: 8.67 *
                                //                     SizeConfig.widthMultiplier!),
                                //             height: 24 * SizeConfig.heightMultiplier!,
                                //             //  width:98*SizeConfig.widthMultiplier!,
                                //             decoration: BoxDecoration(
                                //               color: Theme.of(context)
                                //                   .textTheme
                                //                   .headline4
                                //                   ?.color,
                                //               borderRadius: BorderRadius.circular(
                                //                   8 * SizeConfig.heightMultiplier!),
                                //             ),
                                //             child: Row(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.center,
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.center,
                                //               children: [
                                //                 Icon(
                                //                   Icons.visibility,
                                //                   color:
                                //                       Theme.of(context).primaryColor,
                                //                   size: 20,
                                //                 ),
                                //                 SizedBox(
                                //                   width: 4.67 *
                                //                       SizeConfig.widthMultiplier!,
                                //                 ),
                                //                 Text('28 viewers',
                                //                     style: AppTextStyle.black600Text
                                //                         .copyWith(
                                //                             fontSize: (12) *
                                //                                 SizeConfig
                                //                                     .textMultiplier!,
                                //                             color: Theme.of(context)
                                //                                 .textTheme
                                //                                 .bodyText1
                                //                                 ?.color)),
                                //               ],
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //       Spacer(),
                                //       //join button
                                //       GestureDetector(
                                //         onTap: () {},
                                //         child: Container(
                                //           height: 36 * SizeConfig.heightMultiplier!,
                                //           width: 96 * SizeConfig.widthMultiplier!,
                                //           decoration: BoxDecoration(
                                //             color: Color(0xFFFF5A5A),
                                //             borderRadius: BorderRadius.circular(
                                //                 8 * SizeConfig.heightMultiplier!),
                                //           ),
                                //           padding: EdgeInsets.symmetric(
                                //               horizontal:
                                //                   35 * SizeConfig.widthMultiplier!,
                                //               vertical:
                                //                   8 * SizeConfig.heightMultiplier!),
                                //           child: Text(
                                //             'Join'.tr,
                                //             style: AppTextStyle.black600Text.copyWith(
                                //                 color: Theme.of(context)
                                //                     .textTheme
                                //                     .bodyText1
                                //                     ?.color),
                                //           ),
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10 * SizeConfig.heightMultiplier!,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!,
                                      right: 16 * SizeConfig.widthMultiplier!),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'today'.tr,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 16 *
                                                    SizeConfig.textMultiplier!,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.color),
                                      ),
                                      Text(
                                        formatter,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.color),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10 * SizeConfig.heightMultiplier!,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 16 * SizeConfig.widthMultiplier!,
                                        right:
                                            16 * SizeConfig.widthMultiplier!),
                                    child: _homeController.spgStatus.value ==
                                            true
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Obx(() => _homeController
                                                          .waterConsumedDataLoading
                                                          .value
                                                      ? Shimmer.fromColors(
                                                          child: Container(
                                                            height: 220 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                            width: (Get.width /
                                                                    2) -
                                                                20 *
                                                                    SizeConfig
                                                                        .widthMultiplier!,
                                                            color: Colors.white,
                                                          ),
                                                          baseColor: const Color
                                                                  .fromRGBO(
                                                              240, 240, 240, 1),
                                                          highlightColor:
                                                              const Color
                                                                      .fromRGBO(
                                                                  245,
                                                                  245,
                                                                  245,
                                                                  1),
                                                        )
                                                      : Expanded(
                                                          child: WaterConsumed(
                                                              _homeController
                                                                  .userProfileData
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .profile!
                                                                  .nutrition!
                                                                  .totalWaterConsumed!
                                                                  .toDouble(),
                                                              _homeController
                                                                  .userProfileData
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .profile!
                                                                  .nutrition!
                                                                  .totalWaterRequired!
                                                                  .toDouble(),
                                                              () async {
                                                          print("homeController.waterLevel.value" +
                                                              _homeController
                                                                  .waterLevel
                                                                  .value
                                                                  .toString());
                                                          _homeController
                                                              .isConsumptionLoading
                                                              .value = true;
                                                          Navigator.pushNamed(
                                                              context,
                                                              RouteName
                                                                  .waterConsumed);
                                                          _homeController
                                                                  .waterSource
                                                                  .value =
                                                              await HomeService
                                                                  .fetchReminderData();
                                                          _homeController
                                                                  .waterDetails
                                                                  .value =
                                                              await HomeService
                                                                  .getWaterDetails();
                                                          _homeController
                                                                  .goalWater
                                                                  .value =
                                                              _homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .totalWaterRequired!;
                                                          _homeController
                                                                  .waterStatus
                                                                  .value =
                                                              _homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .status!;
                                                          _homeController.waterTimingTo.value = TimeOfDay(
                                                              hour: int.parse(_homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .sleepTime!
                                                                  .split(
                                                                      ":")[0]),
                                                              minute: int.parse(
                                                                  _homeController
                                                                      .waterDetails
                                                                      .value
                                                                      .response!
                                                                      .data![0]
                                                                      .sleepTime!
                                                                      .split(
                                                                          ":")[1]));
                                                          _homeController.waterTimingFrom.value = TimeOfDay(
                                                              hour: int.parse(_homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .wakeupTime!
                                                                  .split(
                                                                      ":")[0]),
                                                              minute: int.parse(
                                                                  _homeController
                                                                      .waterDetails
                                                                      .value
                                                                      .response!
                                                                      .data![0]
                                                                      .wakeupTime!
                                                                      .split(
                                                                          ":")[1]));
                                                          _homeController
                                                                  .waterReminder
                                                                  .value =
                                                              _homeController.getWaterReminder(
                                                                  _homeController
                                                                      .waterDetails
                                                                      .value
                                                                      .response!
                                                                      .data![0]
                                                                      .waterReminder!);
                                                          _homeController
                                                              .waterLevel
                                                              .value = _homeController
                                                                      .waterDetails
                                                                      .value
                                                                      .response!
                                                                      .data![0]
                                                                      .totalWaterConsumed ==
                                                                  0.0
                                                              ? 0.0
                                                              : (_homeController
                                                                      .userProfileData
                                                                      .value
                                                                      .response!
                                                                      .data!
                                                                      .profile!
                                                                      .nutrition!
                                                                      .totalWaterConsumed! /
                                                                  (_homeController
                                                                      .userProfileData
                                                                      .value
                                                                      .response!
                                                                      .data!
                                                                      .profile!
                                                                      .nutrition!
                                                                      .totalWaterRequired!));
                                                          _homeController
                                                              .isConsumptionLoading
                                                              .value = false;
                                                        },
                                                              //homecontroller
                                                              _homeController,
                                                              //Passing context for theme
                                                              context))),
                                                  SizedBox(
                                                    width: 5.0 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0.0 *
                                                              SizeConfig
                                                                  .widthMultiplier!),
                                                      child: Obx(
                                                        () => CaloriesBurnt(
                                                            _caloriesData
                                                                        .value >
                                                                    0
                                                                ? double.parse(NumberFormat(
                                                                        "0.###")
                                                                    .format(_caloriesData
                                                                        .value))
                                                                : 0.0, () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  HealthApp());
                                                        },
                                                            //is connected
                                                            true,
                                                            //Passing context for theme
                                                            context),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: 5 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                              CaloryConsumption(
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .totalRequiredCalories!
                                                          .toInt()
                                                          .toString() +
                                                      " kcal",
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .carbs!
                                                          .carbsGrams!
                                                          .toInt()
                                                          .toString() +
                                                      " g",
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .carbs!
                                                          .carbsKiloCals!
                                                          .toInt()
                                                          .toString() +
                                                      " kcal",
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .protein!
                                                          .proteinGrams!
                                                          .toInt()
                                                          .toString() +
                                                      " g",
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .protein!
                                                          .proteinKiloCals!
                                                          .toInt()
                                                          .toString() +
                                                      " kcal",
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .fats!
                                                          .fatsGrams!
                                                          .toInt()
                                                          .toString() +
                                                      " g",
                                                  _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .fats!
                                                          .fatsKiloCals!
                                                          .toInt()
                                                          .toString() +
                                                      " kcal",
                                                  //passing context for theme
                                                  context),
                                              SizedBox(
                                                  height: 5 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteName.setGoal);
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: 15 *
                                                                  SizeConfig
                                                                      .widthMultiplier!),
                                                          height: 50 *
                                                              SizeConfig
                                                                  .heightMultiplier!,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: kGreenColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.10),
                                                                  blurRadius:
                                                                      10,
                                                                  spreadRadius:
                                                                      -2,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 5))
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                  ImagePath
                                                                      .refresh),
                                                              SizedBox(
                                                                  width: 10 *
                                                                      SizeConfig
                                                                          .widthMultiplier!),
                                                              Text(
                                                                'Update Goals',
                                                                style: AppTextStyle
                                                                    .normalWhiteText
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14 *
                                                                                SizeConfig.textMultiplier!),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        _homeController
                                                            .explorePageCount
                                                            .value = 0;
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteName
                                                                .exploreSearch);
                                                        _homeController
                                                            .searchController
                                                            .clear();
                                                        _homeController
                                                            .exploreSearchText
                                                            .value = "";
                                                        postController
                                                            .getCategory();
                                                        _homeController
                                                            .isExploreDataLoading
                                                            .value = true;
                                                        _homeController
                                                                .explorePostModel
                                                                .value =
                                                            await HomeService
                                                                .getExplorePosts(
                                                          skip: 0,
                                                        );
                                                        _homeController
                                                                .explorePostList
                                                                .value =
                                                            _homeController
                                                                .explorePostModel
                                                                .value
                                                                .response!
                                                                .data!;
                                                        _homeController
                                                            .isExploreDataLoading
                                                            .value = false;
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: 15 *
                                                                  SizeConfig
                                                                      .widthMultiplier!),
                                                          height: 50 *
                                                              SizeConfig
                                                                  .heightMultiplier!,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.10),
                                                                  blurRadius:
                                                                      10,
                                                                  spreadRadius:
                                                                      -2,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 5))
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Let\'s ',
                                                                style: AppTextStyle
                                                                    .normalWhiteText
                                                                    .copyWith(
                                                                        color:
                                                                            kgreen49,
                                                                        fontSize:
                                                                            14 *
                                                                                SizeConfig.textMultiplier!),
                                                              ),
                                                              Text(
                                                                'Explore ',
                                                                style: AppTextStyle
                                                                    .normalWhiteText
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14 *
                                                                                SizeConfig.textMultiplier!),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container(
                                            // padding:
                                            //     EdgeInsets.only(left: 16, bottom: 16),
                                            decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.10),
                                                      blurRadius: 10,
                                                      spreadRadius: -2,
                                                      offset:
                                                          const Offset(0, 5))
                                                ]),
                                            child: Column(
                                              children: [
                                                // Row(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.start,
                                                //   children: [
                                                //     Container(
                                                //       padding: EdgeInsets.only(
                                                //           top: 16 *
                                                //               SizeConfig
                                                //                   .heightMultiplier!),
                                                //       width: 126 *
                                                //           SizeConfig.widthMultiplier!,
                                                //       child: Text(
                                                //         'set_goal_heading'.tr,
                                                //         style: AppTextStyle
                                                //             .boldBlackText
                                                //             .copyWith(
                                                //                 fontSize: 14 *
                                                //                     SizeConfig
                                                //                         .textMultiplier!),
                                                //         maxLines: 4,
                                                //       ),
                                                //     ),
                                                //     CachedNetworkImage(
                                                //         imageUrl:
                                                //             "https://fitbasix-dev.s3.me-south-1.amazonaws.com/HealthGoalImage.png",
                                                //         fit: BoxFit.cover,
                                                //         height: 120 *
                                                //             SizeConfig.widthMultiplier!,
                                                //         width: 186 *
                                                //             SizeConfig
                                                //                 .widthMultiplier!),
                                                //   ],
                                                // ),
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              topRight: Radius
                                                                  .circular(8)),
                                                      child: Image.asset(
                                                        ImagePath
                                                            .setgoalfeedImage,
                                                        height: 125 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        width: Get.width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 125 *
                                                          SizeConfig
                                                              .heightMultiplier!,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8)),
                                                        gradient:
                                                            RadialGradient(
                                                                colors: [
                                                              const Color(
                                                                      0xff000000)
                                                                  .withOpacity(
                                                                      0),
                                                              const Color(
                                                                      0xff000000)
                                                                  .withOpacity(
                                                                      0.22),
                                                              const Color(
                                                                      0xff000000)
                                                                  .withOpacity(
                                                                      1.0),
                                                            ],
                                                                focal: Alignment
                                                                    .center,
                                                                radius: 8.0),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: 78 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        left: 13 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        child: Text(
                                                          'Lets complete the following \nsteps to define your health goals',
                                                          style: AppTextStyle
                                                              .boldBlackText
                                                              .copyWith(
                                                                  fontSize: 14 *
                                                                      SizeConfig
                                                                          .textMultiplier!,
                                                                  color:
                                                                      kPureWhite),
                                                          maxLines: 2,
                                                        ))
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: 13 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                                // above
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16, bottom: 16),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                ImagePath
                                                                    .dropIcon,
                                                                width: 11 *
                                                                    SizeConfig
                                                                        .widthMultiplier!,
                                                                height: 15 *
                                                                    SizeConfig
                                                                        .heightMultiplier!,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              SizedBox(
                                                                width: 10 *
                                                                    SizeConfig
                                                                        .widthMultiplier!,
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                    text:
                                                                        'Track ',
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'hydration',
                                                                        style: AppTextStyle.boldWhiteText.copyWith(
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyText1?.color,
                                                                            fontSize: 14 * SizeConfig.textMultiplier!),
                                                                      )
                                                                    ]),
                                                                style: AppTextStyle.grey400Text.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText1
                                                                        ?.color,
                                                                    fontSize: 14 *
                                                                        SizeConfig
                                                                            .textMultiplier!),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 8 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                ImagePath
                                                                    .fireIcon,
                                                                width: 11 *
                                                                    SizeConfig
                                                                        .widthMultiplier!,
                                                                height: 15 *
                                                                    SizeConfig
                                                                        .heightMultiplier!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              SizedBox(
                                                                width: 10 *
                                                                    SizeConfig
                                                                        .widthMultiplier!,
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                    text:
                                                                        'Track ',
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'calories',
                                                                        style: AppTextStyle.boldWhiteText.copyWith(
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyText1?.color,
                                                                            fontSize: 14 * SizeConfig.textMultiplier!),
                                                                      )
                                                                    ]),
                                                                style: AppTextStyle.grey400Text.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText1
                                                                        ?.color,
                                                                    fontSize: 14 *
                                                                        SizeConfig
                                                                            .textMultiplier!),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      SizedBox(
                                                        height: 40 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        child:
                                                            GreenCircleArrowButton(
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RouteName
                                                                    .setGoalIntro);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                if (!_homeController.spgStatus.value)
                                  SizedBox(
                                    height: 5 * SizeConfig.heightMultiplier!,
                                  ),
                                if (!_homeController.spgStatus.value)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16 * SizeConfig.widthMultiplier!,
                                        right:
                                            16 * SizeConfig.widthMultiplier!),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left:
                                              16 * SizeConfig.widthMultiplier!),
                                      height: 55 * SizeConfig.heightMultiplier!,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: kGreenColor,
                                          boxShadow: [
                                            BoxShadow(
                                                color: kBlack.withOpacity(0.10),
                                                blurRadius: 10,
                                                spreadRadius: 0,
                                                offset: const Offset(0, 5))
                                          ]),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            ImagePath.searchFavoriteIcon,
                                          ),
                                          SizedBox(
                                            width: 16 *
                                                SizeConfig.widthMultiplier!,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Explore the Fitbasix Community',
                                              style: AppTextStyle.boldBlackText
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!,
                                              ),
                                            ),
                                          ),
                                          GreenCircleArrowButton(
                                            onTap: () async {
                                              _homeController
                                                  .explorePageCount.value = 0;
                                              Navigator.pushNamed(context,
                                                  RouteName.exploreSearch);
                                              _homeController.searchController
                                                  .clear();
                                              _homeController
                                                  .exploreSearchText.value = "";
                                              postController.getCategory();
                                              _homeController
                                                  .isExploreDataLoading
                                                  .value = true;
                                              _homeController
                                                      .explorePostModel.value =
                                                  await HomeService
                                                      .getExplorePosts(
                                                skip: 0,
                                              );
                                              _homeController
                                                      .explorePostList.value =
                                                  _homeController
                                                      .explorePostModel
                                                      .value
                                                      .response!
                                                      .data!;
                                              _homeController
                                                  .isExploreDataLoading
                                                  .value = false;
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 9 * SizeConfig.heightMultiplier!,
                                ),
                                CarouselSlider(
                                  items: [
                                    ImagePath.banner1,
                                    ImagePath.banner2,
                                    ImagePath.banner3,
                                    ImagePath.banner4,
                                    ImagePath.banner5,
                                  ]
                                      .map(
                                        (e) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10 *
                                                  SizeConfig.heightMultiplier!),
                                          child: Image.asset(
                                            e,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    viewportFraction: 1,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    aspectRatio: 3,
                                  ),
                                ),
                                SizedBox(
                                  height: 10 * SizeConfig.heightMultiplier!,
                                ),
                                Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16 *
                                                SizeConfig.heightMultiplier!,
                                            top: 16 *
                                                SizeConfig.heightMultiplier!),
                                        child: Text(
                                          'trending_posts'.tr,
                                          style: AppTextStyle.boldBlackText
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.color,
                                                  fontSize: 16 *
                                                      SizeConfig
                                                          .textMultiplier!),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            10 * SizeConfig.heightMultiplier!,
                                      ),
                                      Obx(
                                        () => _homeController.isPostUpdate.value
                                            ? Center(child: Container())
                                            : ListView.builder(
                                                addAutomaticKeepAlives: false,
                                                addRepaintBoundaries: false,
                                                itemCount: _homeController
                                                        .trendingPostList
                                                        .isEmpty
                                                    ? 0
                                                    : _homeController
                                                        .trendingPostList
                                                        .length,
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemBuilder: (_, index) {
                                                  /// Changed due to no use.
                                                  // _homeController
                                                  //     .alreadyRenderedPostId
                                                  //     .add(_homeController
                                                  //         .trendingPostList[
                                                  //             index]
                                                  //         .id!);
                                                  // _homeController
                                                  //     .alreadyRenderedPostId
                                                  //     .toSet();

                                                  // if(_homeController.alreadyRenderedPostId.indexOf(_homeController
                                                  //     .trendingPostList[
                                                  // index]
                                                  //     .id!)==-1){
                                                  //   _homeController.commentsMap.addIf(false==false,
                                                  //       _homeController
                                                  //           .trendingPostList[
                                                  //       index]
                                                  //           .id!, _homeController
                                                  //           .trendingPostList[
                                                  //       index]
                                                  //           .commentgiven);
                                                  //   _homeController.updateCount.addIf(false==false,
                                                  //       _homeController
                                                  //           .trendingPostList[
                                                  //       index]
                                                  //           .id!, UpdateCount(id: _homeController
                                                  //           .trendingPostList[
                                                  //       index]
                                                  //           .id!,
                                                  //           comments: _homeController
                                                  //               .trendingPostList[
                                                  //           index]
                                                  //               .comments,
                                                  //           likes: _homeController
                                                  //               .trendingPostList[
                                                  //           index]
                                                  //               .likes
                                                  //       ));
                                                  // }

                                                  if (_homeController
                                                          .trendingPostList
                                                          .length <
                                                      5) {
                                                    _homeController
                                                        .isNeedToLoadData
                                                        .value = false;
                                                  }
                                                  print("Links: " +
                                                      _homeController
                                                          .trendingPostList
                                                          .elementAt(index)
                                                          .files
                                                          .toString());
                                                  return Obx(() => Column(
                                                        children: [
                                                          PostTile(
                                                            isMe: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .isMe!,
                                                            userID: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .userId!
                                                                .id,
                                                            comment: _homeController
                                                                        .commentsMap[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ??
                                                                _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .commentgiven,
                                                            name: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .userId!
                                                                .name
                                                                .toString(),
                                                            profilePhoto:
                                                                _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .userId!
                                                                    .profilePhoto!,
                                                            category: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .postCategory![
                                                                    0]
                                                                .name!
                                                                .capitalize!,
                                                            date: DateFormat.d()
                                                                .add_MMM()
                                                                .format(_homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .updatedAt!),
                                                            place: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .location!
                                                                    .placeName!
                                                                    .isEmpty
                                                                ? ''
                                                                : _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .location!
                                                                    .placeName![
                                                                        1]
                                                                    .toString(),
                                                            imageUrl: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .files!
                                                                    .isEmpty
                                                                ? []
                                                                : _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .files!,
                                                            caption: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .caption ??
                                                                '',
                                                            likes: _homeController.updateCount[_homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                    null
                                                                ? _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .likes!
                                                                    .toString()
                                                                : _homeController
                                                                    .updateCount[_homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!]!
                                                                    .likes!
                                                                    .toString(),
                                                            comments: _homeController.updateCount[_homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                    null
                                                                ? _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .comments!
                                                                    .toString()
                                                                : _homeController
                                                                    .updateCount[_homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!]!
                                                                    .comments!
                                                                    .toString(),
                                                            hitLike: () async {
                                                              _homeController.LikedPostMap[_homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .id!] = _homeController.LikedPostMap[_homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!] ==
                                                                      null
                                                                  ? !(_homeController
                                                                      .trendingPostList[
                                                                          index]
                                                                      .isLiked!)
                                                                  : !(_homeController
                                                                          .LikedPostMap[
                                                                      _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!]!);
                                                              if (_homeController
                                                                          .LikedPostMap[
                                                                      _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!]! ==
                                                                  false) {
                                                                _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .isLiked = false;

                                                                await HomeService.unlikePost(
                                                                    postId: _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!);
                                                              } else {
                                                                _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .isLiked = true;

                                                                _homeController
                                                                    .likedPost
                                                                    .toSet()
                                                                    .toList();

                                                                await HomeService.likePost(
                                                                    postId: _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!);
                                                              }

                                                              RecentCommentModel
                                                                  recentComment =
                                                                  RecentCommentModel();
                                                              recentComment = await HomeService
                                                                  .recentComment(
                                                                      postId: _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!);
                                                              // _homeController.commentsMap[_homeController.post.value.id.toString()] =
                                                              //     recentComment.response!.data!.comment;
                                                              _homeController
                                                                      .updateCount[
                                                                  _homeController
                                                                      .trendingPostList[
                                                                          index]
                                                                      .id!] = recentComment
                                                                  .response!
                                                                  .data!
                                                                  .data;

                                                              setState(() {});
                                                            },
                                                            addComment: () {
                                                              // HomeService.addComment(
                                                              //     _homeController
                                                              //         .trendingPostList[
                                                              //             index]
                                                              //         .id!,
                                                              //     _homeController
                                                              //         .comment.value);
                                                              //
                                                              // setState(() {});
                                                              //
                                                              // _homeController
                                                              //     .commentController
                                                              //     .clear();
                                                            },
                                                            postId: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .id!,
                                                            isLiked: _homeController.LikedPostMap[_homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                    null
                                                                ? _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .isLiked!
                                                                : _homeController
                                                                        .LikedPostMap[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!]!,
                                                            onTap: () async {
                                                              _homeController
                                                                  .commentsList
                                                                  .clear();
                                                              _homeController
                                                                  .viewReplies!
                                                                  .clear();
                                                              // _homeController.replyList.clear();
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  RouteName
                                                                      .postScreen);
                                                              _homeController
                                                                  .postLoading
                                                                  .value = true;
                                                              var postData = await HomeService
                                                                  .getPostById(
                                                                      _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!);

                                                              _homeController
                                                                      .post
                                                                      .value =
                                                                  postData
                                                                      .response!
                                                                      .data!;

                                                              _homeController
                                                                  .postLoading
                                                                  .value = false;
                                                              _homeController
                                                                  .commentsLoading
                                                                  .value = true;
                                                              // print("post id  "+_homeController._homeController
                                                              //     .trendingPostList[
                                                              // index]
                                                              //     .id!);
                                                              _homeController
                                                                      .postComments
                                                                      .value =
                                                                  await HomeService.fetchComment(
                                                                      postId: _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!);

                                                              if (_homeController
                                                                  .postComments
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .isNotEmpty) {
                                                                _homeController
                                                                        .commentsList
                                                                        .value =
                                                                    _homeController
                                                                        .postComments
                                                                        .value
                                                                        .response!
                                                                        .data!;
                                                              }
                                                              _homeController
                                                                  .commentsLoading
                                                                  .value = false;
                                                            },
                                                            people: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .people!,
                                                          ),
                                                          Container(
                                                            height: 16 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                            color: Theme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor
                                                                .withOpacity(
                                                                    0.1),
                                                          )
                                                        ],
                                                      ));
                                                }),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Obx(() => _homeController.showLoader.value
                                ? Positioned(
                                    bottom: 20,
                                    left: Get.width / 2 - 10,
                                    child: Center(
                                        child: CustomizedCircularProgress()))
                                : const SizedBox()),

                            /// search users logic and UI
                            // Obx(() => showUserSearch.value
                            //     ? GestureDetector(
                            //         onTap: () {
                            //           clearUserSearchData();
                            //         },
                            //         child: Container(
                            //           height: Get.height,
                            //           width: Get.width,
                            //           color: kPureBlack.withOpacity(0.5),
                            //         ),
                            //       )
                            //     : Container()),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.0 * SizeConfig.widthMultiplier!,
                                top: 20.0 * SizeConfig.widthMultiplier!,
                                right: 15.0 * SizeConfig.widthMultiplier!,
                              ),
                              child: SvgPicture.asset(
                                ImagePath.logo,
                                width: 80 * SizeConfig.widthMultiplier!,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: Get.width -
                                        150 * SizeConfig.widthMultiplier!,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            16 * SizeConfig.widthMultiplier!,
                                        vertical:
                                            12 * SizeConfig.heightMultiplier!),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.color,
                                      borderRadius: BorderRadius.circular(
                                          8 * SizeConfig.widthMultiplier!),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10 *
                                                  SizeConfig.widthMultiplier!,
                                            ),
                                            Icon(
                                              Icons.search,
                                              color: hintGrey,
                                              size: 20 *
                                                  SizeConfig.heightMultiplier!,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter()
                                                ],
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                controller:
                                                    searchUserController,
                                                onChanged: (value) async {
                                                  if (value.isNotEmpty) {
                                                    WidgetsBinding.instance!
                                                        .addPostFrameCallback(
                                                            (_) async {
                                                      showUserSearch.value =
                                                          true;
                                                      var users =
                                                          await CreatePostService
                                                              .getUsers(value);
                                                      _homeController
                                                              .searchUsersData
                                                              .value =
                                                          users.response!.data!;
                                                    });
                                                  } else {
                                                    WidgetsBinding.instance!
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      showUserSearch.value =
                                                          false;
                                                      _homeController
                                                          .searchUsersData
                                                          .value = [UserData()];
                                                    });
                                                  }
                                                  //_homeController.searchUsersData.value = users.response!.data!;
                                                },
                                                style: AppTextStyle
                                                    .normalGreenText
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color),
                                                onSubmitted: (value) {},
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                    10 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    10 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    10 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    10 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                  ),
                                                  // prefixIcon: Transform(
                                                  //   transform: Matrix4.translationValues(
                                                  //       0, 2, 0),
                                                  //   child: Icon(
                                                  //     Icons.search,
                                                  //     color: hintGrey,
                                                  //   ),
                                                  // ),
                                                  border: InputBorder.none,
                                                  hintText: 'search'.tr,
                                                  hintStyle: AppTextStyle
                                                      .smallGreyText
                                                      .copyWith(
                                                          fontSize: 14 *
                                                              SizeConfig
                                                                  .textMultiplier!,
                                                          color: hintGrey),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Obx(() =>
                                            showUserSearch.value &&
                                                    (_homeController
                                                            .searchUsersData
                                                            .isNotEmpty &&
                                                        _homeController
                                                                .searchUsersData[
                                                                    0]
                                                                .name !=
                                                            null)
                                                ? Container(
                                                    height: 250 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    padding: EdgeInsets.only(
                                                        bottom: 10 *
                                                            SizeConfig
                                                                .heightMultiplier!),
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemCount:
                                                            _homeController
                                                                .searchUsersData
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Obx(
                                                              () => Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16 *
                                                                                SizeConfig.widthMultiplier!),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (_homeController
                                                                            .searchUsersData[index]
                                                                            .trainerType!
                                                                            .isNotEmpty) {
                                                                          gotoIndividualPage(
                                                                              index,
                                                                              _homeController.searchUsersData[index].id!);
                                                                        } else {
                                                                          gotoIndividualUserPage(
                                                                              index,
                                                                              _homeController.searchUsersData[index].id!);
                                                                        }
                                                                      },
                                                                      child:
                                                                          PeopleTile(
                                                                        wantCheckBox:
                                                                            false,
                                                                        name: CapitalizeFunction.capitalize(_homeController
                                                                            .searchUsersData[index]
                                                                            .name!
                                                                            .capitalize!),
                                                                        subtitle: _homeController
                                                                            .searchUsersData[index]
                                                                            .name!,
                                                                        image: _homeController
                                                                            .searchUsersData[index]
                                                                            .profilePhoto!,
                                                                        onTap:
                                                                            (value) async {},
                                                                        value:
                                                                            false,
                                                                      ),
                                                                    ),
                                                                  ));
                                                        }))
                                                : Container())
                                      ],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.toNamed('/callBackPage');
                                  //   },
                                  //   child: Padding(
                                  //       padding: EdgeInsets.only(
                                  //           top: 23 *
                                  //               SizeConfig.heightMultiplier!,
                                  //           right: 15.0 *
                                  //               SizeConfig.widthMultiplier!),
                                  //       child: SvgPicture.asset(
                                  //         ImagePath.bellIcon,
                                  //         color: Colors.white,
                                  //         height: 19.5 *
                                  //             SizeConfig.heightMultiplier!,
                                  //         width:
                                  //             16 * SizeConfig.widthMultiplier!,
                                  //       )),
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
        ),
      ),
    );
  }

  void gotoIndividualPage(int index, String trainerId) async {
    TrainerController _trainerController = Get.find();
    if (_homeController.searchUsersData[index].trainerType != null) {
      _trainerController.atrainerDetail.value = Trainer();

      _trainerController.isProfileLoading.value = true;
      _trainerController.isMyTrainerProfileLoading.value = true;
      Navigator.pushNamed(context, RouteName.trainerProfileScreen);
      clearUserSearchData();

      var result = await TrainerServices.getATrainerDetail(trainerId);
      if (result.response!.data != null) {
        _trainerController.atrainerDetail.value = result.response!.data!;
      }

      _trainerController.planModel.value =
          await TrainerServices.getPlanByTrainerId(
              trainerId, _trainerController.currentPlanType);

      _trainerController.initialPostData.value =
          await TrainerServices.getTrainerPosts(trainerId, 0);
      _trainerController.isMyTrainerProfileLoading.value = false;
      _trainerController.loadingIndicator.value = false;
      if (_trainerController.initialPostData.value.response!.data!.isNotEmpty) {
        _trainerController.trainerPostList.value =
            _trainerController.initialPostData.value.response!.data!;
      } else {
        _trainerController.trainerPostList.clear();
      }
      _trainerController.isProfileLoading.value = false;
      _trainerController.isMyTrainerProfileLoading.value = false;
    }
  }

  void gotoIndividualUserPage(int index, String userId) async {
    final IndividualUserController _individualUserController =
        Get.put(IndividualUserController());
    _homeController.individualUserProfileData.value = UserProfileModel();
    _homeController.isIndividualUserProfileLoading.value = true;
    Navigator.pushNamed(context, RouteName.individualUserProfileScreen);
    clearUserSearchData();
    var result = await HomeService.getIndividualUserProfileData(userId: userId);
    if (result.response != null) {
      _homeController.individualUserProfileData.value = result;
    }
    _homeController.isIndividualUserProfileLoading.value = false;
    _homeController.isLoading.value = true;
    var response = await HomeService.getIndividualUserPosts(userId, 0);
    _individualUserController.userPostList.value = response.response!.data!;
    if (response.response!.data!.isNotEmpty) {
      _individualUserController.userPostList.value = response.response!.data!;
    } else {
      _individualUserController.userPostList.clear();
    }
    _homeController.isLoading.value = false;
  }

  void clearUserSearchData() {
    showUserSearch.value = false;
    _homeController.searchUsersData.value = [UserData()];
    searchUserController.clear();
  }

  void showDialogForLiveLimitExceeded(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20 * SizeConfig.widthMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier!,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Transform.translate(
                        offset: Offset(10 * SizeConfig.widthMultiplier!, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            radius: 20 * SizeConfig.imageSizeMultiplier!,
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150 * SizeConfig.heightMultiplier!,
                      width: 150 * SizeConfig.widthMultiplier!,
                      child: Image.asset(
                        ImagePath.animatedLiveLimitErrorIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    SizedBox(
                      width: 250 * SizeConfig.widthMultiplier!,
                    ),
                    Text(
                      "Something went wrong!".tr,
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "There is already 200 people in\nthis please join later."
                          .tr,
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40 * SizeConfig.heightMultiplier!,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Future<void> onTrendingPostRefresh() async {
    _homeController.initialPostData.value =
        await HomeService.getPosts(skip: null);

    if (_homeController.initialPostData.value.response!.data!.isNotEmpty) {
      _homeController.trendingPostList.value =
          _homeController.initialPostData.value.response!.data!;
    }
  }
}

refreshProfileData() async {
  HomeController _homeController = Get.find();
  var response = await CreatePostService.getUserProfile();
  if (response.response != null) {
    _homeController.userProfileData.value = response;
    _homeController.userProfileData.refresh();
  }
}
