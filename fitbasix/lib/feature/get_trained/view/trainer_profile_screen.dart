import 'dart:io';

// import 'package:cometchat/cometchat_sdk.dart' as cometChat;
import 'package:firebase_core/firebase_core.dart';
import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/image_viewer.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/my_trainers_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/view/chat_page.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/get_trained/view/followers.dart';
import 'package:fitbasix/feature/message/view/screens/message_list.dart';
import 'package:fitbasix/feature/message/view/web_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/number_format.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';

import '../../Home/model/RecentCommentModel.dart';

class TrainerProfileScreen extends StatefulWidget {
  String? trainerID;
  TrainerProfileScreen({this.trainerID, Key? key}) : super(key: key);

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  HomeController _homeController = Get.find();
  bool isMessageLoading = false;
  TrainerController _trainerController = Get.find();
  // var isPlanLoading = true.obs;

  getAllTrainerPlanData() async {
    if (widget.trainerID == null) {
      if (!_trainerController.isMyTrainerProfileLoading.value) {
        _trainerController.planModel.value = PlanModel();
        _trainerController.isPlanLoading.value = true;
        _trainerController.planModel.value =
            await TrainerServices.getPlanByTrainerId(
                    _trainerController.atrainerDetail.value.user!.id!,
                    _trainerController.currentPlanType)
                .then((value) {
          _trainerController.isPlanLoading.value = false;
          setState(() {});
          return value;
        });
      }
    }
  }

  @override
  void initState() {
    getAllTrainerPlanData();
    if (widget.trainerID != null) {
      setTrainerDataForUniLink();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TrainerController trainerController = Get.put(TrainerController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(
          () => !_trainerController.isMyTrainerProfileLoading.value
              ? TrainerPage(
                  trainerImage: trainerController
                      .atrainerDetail.value.user!.profilePhoto!,
                  trainerCoverImage: trainerController
                      .atrainerDetail.value.user!.coverPhoto!
                      .toString(),
                  isEnrolled:
                      _trainerController.atrainerDetail.value.isEnrolled!,
                  onFollow: () {
                    if (trainerController.atrainerDetail.value.isFollowing!) {
                      Get.dialog(
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20 * SizeConfig.widthMultiplier!),
                            child: const UnfollowDialog(),
                          ),
                          barrierColor: Colors.transparent);
                    } else {
                      trainerController.atrainerDetail.value.isFollowing = true;
                      trainerController.atrainerDetail.value.followers =
                          (int.tryParse(trainerController
                                      .atrainerDetail.value.followers!)! +
                                  1)
                              .toString();
                      TrainerServices.followTrainer(
                          trainerController.atrainerDetail.value.user!.id!);
                    }
                    setState(() {});
                  },
                  onMessage: () async {
                    if (_trainerController.atrainerDetail.value.isEnrolled!) {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();

                      var controller = Get.put(FirebaseChatController());
                      controller.getValues();
                      controller.receiverId =
                          _trainerController.atrainerDetail.value.user!.id!;
                      controller.senderPhoto = _trainerController
                          .atrainerDetail.value.user!.profilePhoto!;
                      controller.senderName = _trainerController
                          .atrainerDetail.value.user!.name!.capitalize!;
                      Get.to(
                        () => ChatPage(),
                      );
                      // String? userIdForCometChat = await sharedPreferences
                      //     .getString("userIdForCometChat");
                      // if (userIdForCometChat != null) {
                      //   bool userIsLoggedIn = await CometChatService()
                      //       .logInUser(userIdForCometChat);
                      //   if (userIsLoggedIn) {
                      //     if (_trainerController.atrainerDetail.value.chatId !=
                      //         null) {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => MessageList(
                      //                     chatId: _trainerController
                      //                         .atrainerDetail.value.chatId,
                      //                     trainerId: _trainerController
                      //                         .atrainerDetail.value.user!.id,
                      //                     profilePicURL: _trainerController
                      //                         .atrainerDetail
                      //                         .value
                      //                         .user!
                      //                         .profilePhoto,
                      //                     trainerTitle: _trainerController
                      //                         .atrainerDetail.value.user!.name,
                      //                     time: _trainerController
                      //                         .atrainerDetail.value.time,
                      //                     days: _trainerController
                      //                         .atrainerDetail.value.days,
                      //                   )));
                      //     }
                      //   }
                      // }

                      // String url = await TrainerServices.getEnablexUrl(
                      //     trainerController.atrainerDetail.value.user!.id.toString());

                      // if (!await launchUrl(Uri.parse(url))) throw 'Could not launch';
                      //       if(Platform.isAndroid){
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 InAppWebViewPage(
                      //                     url: url,
                      //               )));
                      //       }
                      //   else{
                      //   launch(url);
                      // }
                      // if (!isMessageLoading) {
                      //   isMessageLoading = true;
                      //   bool dialogCreatedPreviously = false;
                      //   int openPage = 0;
                      //   //133817477	user1
                      //   //133815819 trainer1
                      //   //133612091 trainer
                      //   final sharedPreferences =
                      //       await SharedPreferences.getInstance();
                      //   _homeController.userQuickBloxId.value =
                      //       sharedPreferences.getInt("userQuickBloxId")!;
                      //
                      //
                      //   // _homeController.userQuickBloxId.value == 133815819
                      //   //     ? 133819788
                      //   //    : 133815819;
                      //
                      //   QBSort sort = QBSort();
                      //   sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
                      //   sort.ascending = true;
                      //   try {
                      //     List<QBDialog?> dialogs = await QB.chat
                      //         .getDialogs(
                      //       sort: sort,
                      //     )
                      //         .then((value) async {
                      //       for (int i = 0; i < value.length; i++) {
                      //         if (value[i]!.occupantsIds!.contains(
                      //                 _homeController.userQuickBloxId.value) &&
                      //             value[i]!
                      //                 .occupantsIds!
                      //                 .contains(UserQuickBloxId)) {
                      //           dialogCreatedPreviously = true;
                      //           print(value[i]!.id.toString() + "maxxxx");
                      //           isMessageLoading = false;
                      //           if (openPage < 1) {
                      //
                      //             ++openPage;
                      //           }
                      //           isMessageLoading = false;
                      //           break;
                      //         }
                      //       }
                      //       if (!dialogCreatedPreviously) {
                      //         List<int> occupantsIds = [
                      //           _homeController.userQuickBloxId.value,
                      //           UserQuickBloxId
                      //         ];
                      //         String dialogName = UserQuickBloxId.toString() +
                      //             _homeController.userQuickBloxId.value
                      //                 .toString() +
                      //             DateTime.now().millisecond.toString();
                      //         int dialogType = QBChatDialogTypes.CHAT;
                      //         try {
                      //           QBDialog? createdDialog = await QB.chat
                      //               .createDialog(
                      //             occupantsIds,
                      //             dialogName,
                      //             dialogType: QBChatDialogTypes.CHAT,
                      //           )
                      //               .then((value) {
                      //             isMessageLoading = false;
                      //             if (openPage < 1) {
                      //               isMessageLoading = false;
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) => ChatScreen(
                      //                             userDialogForChat: value,
                      //                             opponentID: UserQuickBloxId,
                      //                             profilePicURL:
                      //                                 _trainerController
                      //                                     .atrainerDetail
                      //                                     .value
                      //                                     .user!
                      //                                     .profilePhoto,
                      //                             trainerId: _trainerController
                      //                                 .atrainerDetail
                      //                                 .value
                      //                                 .user!
                      //                                 .id,
                      //                             isCurrentlyEnrolled:
                      //                                 _trainerController
                      //                                     .atrainerDetail
                      //                                     .value
                      //                                     .isEnrolled,
                      //                             trainerTitle:
                      //                                 trainerController
                      //                                     .atrainerDetail
                      //                                     .value
                      //                                     .user!
                      //                                     .name!,
                      //                             time: trainerController
                      //                                 .atrainerDetail
                      //                                 .value
                      //                                 .time,
                      //                             days: trainerController
                      //                                 .atrainerDetail
                      //                                 .value
                      //                                 .days,
                      //                           )));
                      //               ++openPage;
                      //             }
                      //           });
                      //         } on PlatformException catch (e) {
                      //           isMessageLoading = false;
                      //           print(e.toString());
                      //         }
                      //       }
                      //       return value;
                      //     });
                      //   } on PlatformException catch (e) {
                      //     isMessageLoading = false;
                      //     // some error occurred, look at the exception message for more details
                      //   }
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text("Message is loading")));
                      // }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const EnrollTrainerDialog());
                    }
                  },
                  onEnroll: () {
                    Navigator.pushNamed(context, RouteName.trainerplanScreen);
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) => EnrollTrainerDialog());
                  },
                  onBack: () {
                    Navigator.pop(context);
                  },
                  name: trainerController
                      .atrainerDetail.value.user!.name!.capitalize!,
                  followersCount: NumberFormatter.textFormatter(
                      trainerController.atrainerDetail.value.followers!),
                  followingCount: NumberFormatter.textFormatter(
                      trainerController.atrainerDetail.value.following!),
                  rating: double.parse(
                      trainerController.atrainerDetail.value.rating!),
                  ratingCount: NumberFormatter.textFormatter(
                      trainerController.atrainerDetail.value.totalRating!),
                  totalPeopleTrained: NumberFormatter.textFormatter(
                      trainerController.atrainerDetail.value.trainees!),
                  strengths: trainerController.atrainerDetail.value.strength!,
                  aboutTrainer: trainerController.atrainerDetail.value.about!,
                  certifcateTitle:
                      trainerController.atrainerDetail.value.certificates!,
                  allPlans: trainerController.isProfileLoading.value ? [] : [],
                  isFollowing:
                      trainerController.atrainerDetail.value.isFollowing!,
                  id: trainerController.atrainerDetail.value.user!.id!,
                )
              : Center(
                  child: CustomizedCircularProgress(),
                ),
        ),
      ),
    );
  }

  void setTrainerDataForUniLink() async {
    _trainerController.isMyTrainerProfileLoading.value = true;
    var response = await TrainerServices.getATrainerDetail(
      widget.trainerID!,
    );
    _trainerController.atrainerDetail.value = response.response!.data!;
    _trainerController.isMyTrainerProfileLoading.value = false;
    _trainerController.setUp();
    _homeController.setup();
  }
}

class TrainerPage extends StatefulWidget {
  TrainerPage(
      {required this.trainerImage,
      required this.trainerCoverImage,
      required this.onFollow,
      required this.onMessage,
      required this.onBack,
      required this.followersCount,
      required this.followingCount,
      required this.ratingCount,
      required this.rating,
      required this.totalPeopleTrained,
      required this.strengths,
      required this.aboutTrainer,
      required this.certifcateTitle,
      required this.onEnroll,
      required this.name,
      required this.allPlans,
      required this.isFollowing,
      required this.isEnrolled,
      Key? key,
      required this.id})
      : super(key: key);
  final String trainerImage;
  final String trainerCoverImage;
  final String name;
  final String followersCount;
  final VoidCallback onFollow;
  final VoidCallback onEnroll;
  final VoidCallback onMessage;
  final VoidCallback onBack;
  final String followingCount;
  final String ratingCount;
  final String totalPeopleTrained;
  final double rating;
  final List<StrengthElement> strengths;
  final List<Certificate> certifcateTitle;
  final String aboutTrainer;
  final List<Plan> allPlans;
  final bool isFollowing;
  final bool isEnrolled;
  final String id;

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  final HomeController _homeController = Get.find();
  final ScrollController _scrollController = ScrollController();
  final TrainerController _trainerController = Get.find();



  @override
  void initState() {
    super.initState();
    _trainerController.currentPostPage.value = 1;

    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        _trainerController.loadingIndicator.value = true;
        final postQuery = await TrainerServices.getTrainerPosts(
            _trainerController.atrainerDetail.value.user!.id!,
            _trainerController.currentPostPage.value * 5);
        _trainerController.trainerPostList.addAll(postQuery.response!.data!);
        _trainerController.currentPostPage.value++;
        if (postQuery.response!.data!.length < 5) {
          _trainerController.trainerPostList.addAll(postQuery.response!.data!);
          _trainerController.loadingIndicator.value = false;
          //return;
        } else {
          if (_trainerController.trainerPostList.last.id ==
              postQuery.response!.data!.last.id) {
            _trainerController.loadingIndicator.value = false;
            //return;
          }
          _trainerController.trainerPostList.addAll(postQuery.response!.data!);
        }

        _trainerController.loadingIndicator.value = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TrainerController trainerController = Get.put(TrainerController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 152 * SizeConfig.widthMultiplier!),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 187 * SizeConfig.heightMultiplier!,
                                  ),
                                  Text(
                                    widget.name.capitalize!,
                                    style: AppTextStyle.titleText.copyWith(
                                        fontSize:
                                            18 * SizeConfig.textMultiplier!,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color),
                                  ),
                                  SizedBox(
                                    height: 12 * SizeConfig.heightMultiplier!,
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => trainerController.atrainerDetail
                                                .value.isFollowing!
                                            ? CustomButton(
                                                title: 'following'.tr,
                                                onPress: widget.onFollow,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                textColor: kgreen49,
                                              )
                                            : CustomButton(
                                                title: 'follow'.tr,
                                                onPress: widget.onFollow,
                                                color: kGreenColor,
                                                textColor: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                      SizedBox(
                                        width: 8 * SizeConfig.widthMultiplier!,
                                      ),
                                      CustomButton(
                                        title: 'message'.tr,
                                        onPress: widget.onMessage,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        textColor: kgreen49,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24 * SizeConfig.heightMultiplier!,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24.0 * SizeConfig.widthMultiplier!,
                                  right: 27 * SizeConfig.heightMultiplier!),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.to(() => FollowersList(
                                              id: widget.id, index: 0,
                                            )),
                                        child: Column(
                                          children: [
                                            Text(widget.followersCount,
                                                style: AppTextStyle
                                                    .boldBlackText
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color)),
                                            Text('follower'.tr,
                                                style: AppTextStyle
                                                    .smallBlackText
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color,
                                                        fontSize: 12 *
                                                            SizeConfig
                                                                .textMultiplier!))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              25 * SizeConfig.widthMultiplier!),
                                      GestureDetector(
                                        onTap: () => Get.to(() => FollowersList(
                                              id: widget.id, index: 1,
                                            )),
                                        child: Column(
                                          children: [
                                            Text(widget.followingCount,
                                                style: AppTextStyle.boldBlackText
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color)),
                                            Text('following'.tr,
                                                style: AppTextStyle.smallBlackText
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color,
                                                        fontSize: 12 *
                                                            SizeConfig
                                                                .textMultiplier!))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1,
                                    height: 56 * SizeConfig.widthMultiplier!,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.color,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Text(
                                          //   widget.ratingCount.toString(),
                                          //   style:
                                          //       AppTextStyle.greenSemiBoldText,
                                          // ),
                                          // SizedBox(
                                          //     width: 8 *
                                          //         SizeConfig.widthMultiplier!),
                                          StarRating(
                                            rating: widget.rating,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            widget.totalPeopleTrained
                                                .toString(),
                                            style: AppTextStyle
                                                .greenSemiBoldText
                                                .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!),
                                          Text(
                                            'people_trained'.tr,
                                            style: AppTextStyle.smallBlackText
                                                .copyWith(
                                              fontSize: (12) *
                                                  SizeConfig.textMultiplier!,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        //extra text
                                        'view_and_review'.tr,
                                        style: AppTextStyle
                                            .smallBlackText
                                            .copyWith(
                                                fontSize: (12) *
                                                    SizeConfig.textMultiplier!,
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        ?.color,
                                                decoration:
                                                    TextDecoration.underline),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 28 * SizeConfig.heightMultiplier!),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24.0 * SizeConfig.widthMultiplier!),
                              child: Text(
                                'about'.tr,
                                textAlign: TextAlign.justify,
                                style: AppTextStyle.greenSemiBoldText.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
                                ),
                              ),
                            ),
                            SizedBox(height: 12 * SizeConfig.heightMultiplier!),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24.0 * SizeConfig.widthMultiplier!,
                                  right: 24.0 * SizeConfig.widthMultiplier!),
                              child: RichText(
                                text: TextSpan(
                                  text: widget.aboutTrainer,
                                  style: AppTextStyle.lightMediumBlackText
                                      .copyWith(
                                    fontSize: (14) * SizeConfig.textMultiplier!,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                  ),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            // SizedBox(
                            //     height:
                            //     23 * SizeConfig.heightMultiplier!),
                            widget.certifcateTitle.length == 0
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            24.0 * SizeConfig.widthMultiplier!,
                                        top: 24 * SizeConfig.heightMultiplier!,
                                        bottom:
                                            12 * SizeConfig.heightMultiplier!),
                                    child: Text(
                                      'achivement'.tr,
                                      style: AppTextStyle.greenSemiBoldText
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                      ),
                                    ),
                                  ),
                            widget.certifcateTitle.length == 0
                                ? Container()
                                : Container(
                                    height: 81 * SizeConfig.heightMultiplier!,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            widget.certifcateTitle.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: index == 0
                                                ? EdgeInsets.only(
                                                    left: 24.0 *
                                                        SizeConfig
                                                            .widthMultiplier!)
                                                : const EdgeInsets.only(),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 12.0 *
                                                      SizeConfig
                                                          .widthMultiplier!),
                                              child: AchivementCertificateTile(
                                                certificateDescription: widget
                                                    .certifcateTitle[index]
                                                    .certificateName!,
                                                certificateIcon: widget
                                                    .certifcateTitle[index]
                                                    .url!,
                                                color: index % 2 == 0
                                                    ? Theme.of(context)
                                                        .highlightColor
                                                    : Theme.of(context)
                                                        .indicatorColor,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

                            SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 24 * SizeConfig.heightMultiplier!),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            24.0 * SizeConfig.widthMultiplier!),
                                    child: Text(
                                      'strength'.tr,
                                      style: AppTextStyle.greenSemiBoldText
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          12 * SizeConfig.heightMultiplier!),
                                  Container(
                                    height: 28 * SizeConfig.heightMultiplier!,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget.strengths.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: index == 0
                                                ? EdgeInsets.only(
                                                    left: 24.0 *
                                                        SizeConfig
                                                            .widthMultiplier!)
                                                : EdgeInsets.only(
                                                    left: 8.0 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                            child: Container(
                                              height: 28 *
                                                  SizeConfig.heightMultiplier!,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      ?.color,
                                                  borderRadius:
                                                      BorderRadius.circular(28 *
                                                          SizeConfig
                                                              .heightMultiplier!)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                                child: Center(
                                                  child: Text(
                                                    widget.strengths[index].name
                                                        .toString(),
                                                    style: AppTextStyle
                                                        .lightMediumBlackText
                                                        .copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          ?.color,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //     left: 24.0 * SizeConfig.widthMultiplier!,
                                  //   ),
                                  //   child: Obx(() => trainerController
                                  //           .isProfileLoading.value
                                  //       ? Text('plan'.tr,
                                  //           style: AppTextStyle
                                  //               .greenSemiBoldText
                                  //               .copyWith(
                                  //             color: Theme.of(context).textTheme.bodyText1?.color,
                                  //           ))
                                  //       : widget.allPlans.length != 0
                                  //           ? Text('plan'.tr,
                                  //               style: AppTextStyle
                                  //                   .greenSemiBoldText
                                  //                   .copyWith(
                                  //                 color: Theme.of(context).textTheme.bodyText1?.color,
                                  //               ))
                                  //           : SizedBox()),
                                  // ),
                                  // SizedBox(
                                  //     height:
                                  //         12 * SizeConfig.heightMultiplier!),
                                  // Obx(() => trainerController
                                  //         .isProfileLoading.value
                                  //     ? Container(
                                  //         height: 250 *
                                  //             SizeConfig.heightMultiplier!,
                                  //         child: ListView.builder(
                                  //             scrollDirection: Axis.horizontal,
                                  //             itemCount: 4,
                                  //             shrinkWrap: true,
                                  //             itemBuilder:
                                  //                 (BuildContext context,
                                  //                     int index) {
                                  //               return Shimmer.fromColors(
                                  //                 baseColor:
                                  //                     const Color.fromRGBO(
                                  //                         230, 230, 230, 1),
                                  //                 highlightColor:
                                  //                     const Color.fromRGBO(
                                  //                         242, 245, 245, 1),
                                  //                 child: Padding(
                                  //                   padding: index == 0
                                  //                       ? EdgeInsets.only(
                                  //                           left: 24.0 *
                                  //                               SizeConfig
                                  //                                   .widthMultiplier!)
                                  //                       : EdgeInsets.only(
                                  //                           right: 8.0 *
                                  //                               SizeConfig
                                  //                                   .widthMultiplier!),
                                  //                   child: PlanTile(
                                  //                     rating: double.parse("2"),
                                  //                     planTitle: "",
                                  //                     planImage:
                                  //                         "https://randomuser.me/api/portraits/men/1.jpg",
                                  //                     palnTime: "",
                                  //                     likesCount: "",
                                  //                     ratingCount: "",
                                  //                   ),
                                  //                 ),
                                  //               );
                                  //             }),
                                  //       )
                                  //     : (widget.allPlans.length != 0
                                  //         ? Container(
                                  //             height: 250 *
                                  //                 SizeConfig.heightMultiplier!,
                                  //             child: ListView.builder(
                                  //                 scrollDirection:
                                  //                     Axis.horizontal,
                                  //                 itemCount:
                                  //                     widget.allPlans.length,
                                  //                 shrinkWrap: true,
                                  //                 itemBuilder:
                                  //                     (BuildContext context,
                                  //                         int index) {
                                  //                   return Padding(
                                  //                     padding: index == 0
                                  //                         ? EdgeInsets.only(
                                  //                             left: 24.0 *
                                  //                                 SizeConfig
                                  //                                     .widthMultiplier!,
                                  //                             right: 8.0 *
                                  //                                 SizeConfig
                                  //                                     .widthMultiplier!)
                                  //                         : EdgeInsets.only(
                                  //                             right: 8.0 *
                                  //                                 SizeConfig
                                  //                                     .widthMultiplier!),
                                  //                     child: PlanTile(
                                  //                       rating: double.parse(
                                  //                           widget
                                  //                               .allPlans[index]
                                  //                               .plansRating
                                  //                               .toString()),
                                  //                       planTitle: widget
                                  //                           .allPlans[index]
                                  //                           .planName!,
                                  //                       planImage: widget
                                  //                           .allPlans[index]
                                  //                           .planIcon!,
                                  //                       palnTime: 'planTime'
                                  //                           .trParams({
                                  //                         'duration': (widget
                                  //                                     .allPlans[
                                  //                                         index]
                                  //                                     .planDuration! %
                                  //                                 5)
                                  //                             .toString()
                                  //                       }),
                                  //                       likesCount: NumberFormatter
                                  //                           .textFormatter(widget
                                  //                               .allPlans[index]
                                  //                               .likesCount!
                                  //                               .toString()),
                                  //                       ratingCount: NumberFormatter
                                  //                           .textFormatter(widget
                                  //                               .allPlans[index]
                                  //                               .raters!
                                  //                               .toString()),
                                  //                     ),
                                  //                   );
                                  //                 }),
                                  //           )
                                  //         : SizedBox())),
                                ],
                              ),
                            ),
                            Obx(
                              () => _homeController.isLoading.value
                                  ? CustomizedCircularProgress()
                                  : ListView.builder(
                                      itemCount: _trainerController
                                                  .trainerPostList.length ==
                                              0
                                          ? 0
                                          : _trainerController
                                              .trainerPostList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        return Obx(() => Column(
                                              children: [
                                                Container(
                                                  height: 16 *
                                                      SizeConfig
                                                          .heightMultiplier!,
                                                  color: kBackgroundColor,
                                                ),
                                                PostTile(
                                                  isMe: _trainerController
                                                      .trainerPostList[index]
                                                      .isMe!,
                                                  userID: _trainerController
                                                      .trainerPostList[index]
                                                      .userId!
                                                      .id,
                                                  isTrainerProfile: true,
                                                  comment: _homeController
                                                                  .commentsMap[
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id!] ==
                                                          null
                                                      ? _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .commentgiven
                                                      : _homeController
                                                              .commentsMap[
                                                          _trainerController
                                                              .trainerPostList[
                                                                  index]
                                                              .id],
                                                  name: _trainerController
                                                      .trainerPostList[index]
                                                      .userId!
                                                      .name!
                                                      .capitalize!,
                                                  profilePhoto:
                                                      _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .userId!
                                                          .profilePhoto!,
                                                  category: _trainerController
                                                      .trainerPostList[index]
                                                      .postCategory![0]
                                                      .name!
                                                      .capitalize!,
                                                  date: DateFormat.d()
                                                      .add_MMM()
                                                      .format(_trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .updatedAt!),
                                                  place: _trainerController
                                                              .trainerPostList[
                                                                  index]
                                                              .location!
                                                              .placeName!
                                                              .length ==
                                                          0
                                                      ? ''
                                                      : _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .location!
                                                          .placeName![1]
                                                          .toString(),
                                                  imageUrl: _trainerController
                                                              .trainerPostList[
                                                                  index]
                                                              .files!
                                                              .length ==
                                                          0
                                                      ? []
                                                      : _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .files!,
                                                  caption: _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .caption ??
                                                      '',
                                                  likes: _homeController
                                                                  .updateCount[
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id] ==
                                                          null
                                                      ? _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .likes
                                                          .toString()
                                                      : _homeController
                                                          .updateCount[
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id]!
                                                          .likes!
                                                          .toString(),
                                                  comments: _homeController
                                                                  .updateCount[
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id] ==
                                                          null
                                                      ? _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .comments
                                                          .toString()
                                                      : _homeController
                                                          .updateCount[
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id]!
                                                          .comments!
                                                          .toString(),
                                                  hitLike: () async {
                                                    bool val = _homeController
                                                                    .LikedPostMap[
                                                                _trainerController
                                                                    .trainerPostList[
                                                                        index]
                                                                    .id!] ==
                                                            null
                                                        ? _trainerController
                                                            .trainerPostList[
                                                                index]
                                                            .isLiked!
                                                        : _homeController
                                                                .LikedPostMap[
                                                            _trainerController
                                                                .trainerPostList[
                                                                    index]
                                                                .id!]!;
                                                    if (val) {
                                                      _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .isLiked = false;
                                                      _trainerController
                                                              .trainerPostList[
                                                                  index]
                                                              .likes =
                                                          (_trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .likes! -
                                                              1);
                                                      await HomeService.unlikePost(
                                                          postId:
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id!);
                                                    } else {
                                                      _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .isLiked = true;
                                                      _trainerController
                                                              .trainerPostList[
                                                                  index]
                                                              .likes =
                                                          (_trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .likes! +
                                                              1);
                                                      await HomeService.likePost(
                                                          postId:
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id!);
                                                    }
                                                    RecentCommentModel
                                                        recentComment =
                                                        RecentCommentModel();
                                                    recentComment = await HomeService
                                                        .recentComment(
                                                            postId: _trainerController
                                                                .trainerPostList[
                                                                    index]
                                                                .id!);
                                                    // _homeController.commentsMap[_homeController.post.value.id.toString()] =
                                                    //     recentComment.response!.data!.comment;
                                                    _homeController.updateCount[
                                                        _trainerController
                                                            .trainerPostList[
                                                                index]
                                                            .id!] = recentComment
                                                        .response!.data!.data;
                                                    setState(() {});
                                                  },
                                                  addComment: () {
                                                    // HomeService.addComment(
                                                    //     _trainerController
                                                    //         .trainerPostList[
                                                    //             index]
                                                    //         .id!,
                                                    //     _homeController
                                                    //         .comment.value);

                                                    setState(() {});

                                                    _homeController
                                                        .commentController
                                                        .clear();
                                                  },
                                                  postId: _trainerController
                                                      .trainerPostList[index]
                                                      .id!,
                                                  isLiked: _homeController
                                                                  .LikedPostMap[
                                                              _trainerController
                                                                  .trainerPostList[
                                                                      index]
                                                                  .id!] ==
                                                          null
                                                      ? _trainerController
                                                          .trainerPostList[
                                                              index]
                                                          .isLiked!
                                                      : _homeController
                                                              .LikedPostMap[
                                                          _trainerController
                                                              .trainerPostList[
                                                                  index]
                                                              .id]!,
                                                  onTap: () async {
                                                    _homeController.commentsList
                                                        .clear();
                                                    _homeController.viewReplies!
                                                        .clear();
                                                    Navigator.pushNamed(context,
                                                        RouteName.postScreen);

                                                    _homeController.postLoading
                                                        .value = true;
                                                    var postData = await HomeService
                                                        .getPostById(
                                                            _trainerController
                                                                .trainerPostList[
                                                                    index]
                                                                .id!);

                                                    _homeController.post.value =
                                                        postData
                                                            .response!.data!;

                                                    _homeController.postLoading
                                                        .value = false;
                                                    _homeController
                                                        .commentsLoading
                                                        .value = true;
                                                    _homeController.postComments
                                                            .value =
                                                        await HomeService.fetchComment(
                                                            postId: _trainerController
                                                                .trainerPostList[
                                                                    index]
                                                                .id!);

                                                    if (_homeController
                                                            .postComments
                                                            .value
                                                            .response!
                                                            .data!
                                                            .length !=
                                                        0) {
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
                                                  people: _trainerController
                                                      .trainerPostList[index]
                                                      .people!,
                                                ),
                                              ],
                                            ));
                                      }),
                            ),
                            SizedBox(
                              height: 100 * SizeConfig.heightMultiplier!,
                            )
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 177 * SizeConfig.heightMultiplier!,
                          child: Image.network(
                            widget.trainerCoverImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 127 * SizeConfig.heightMultiplier!,
                          left: 16 * SizeConfig.widthMultiplier!,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4 * SizeConfig.widthMultiplier!,
                                    color: kPureWhite),
                                shape: BoxShape.circle),
                            height: 120 * SizeConfig.widthMultiplier!,
                            width: 120 * SizeConfig.widthMultiplier!,
                            child: CircleAvatar(
                              radius: 60 * SizeConfig.heightMultiplier!,
                              backgroundImage:
                                  NetworkImage(widget.trainerImage),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 16 * SizeConfig.heightMultiplier!,
                            left: 16 * SizeConfig.widthMultiplier!,
                            child: GestureDetector(
                              onTap: widget.onBack,
                              child: Container(
                                height: 40 * SizeConfig.heightMultiplier!,
                                width: 40 * SizeConfig.heightMultiplier!,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                child: SvgPicture.asset(
                                  ImagePath.backIcon,
                                  color: Theme.of(context).primaryColor,
                                  height: 15,
                                  width: 7,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => _trainerController.loadingIndicator.value
                ? Positioned(
                    bottom: 90 * SizeConfig.heightMultiplier!,
                    left: Get.width / 2 - 10,
                    child: Center(child: CustomizedCircularProgress()))
                : const SizedBox()),

            //To be docked at bottom center
            Obx(() => _trainerController.isPlanLoading.value == false
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: 8 * SizeConfig.heightMultiplier!,
                          bottom: 16 * SizeConfig.heightMultiplier!,
                          left: 24 * SizeConfig.widthMultiplier!,
                          right: 24 * SizeConfig.widthMultiplier!),
                      child: GestureDetector(
                        onTap: widget.isEnrolled ? null : widget.onEnroll,
                        child: Container(
                          decoration: BoxDecoration(
                              color: widget.isEnrolled ? hintGrey : kgreen4F,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 31.0 * SizeConfig.widthMultiplier!,
                                vertical: 14 * SizeConfig.heightMultiplier!),
                            child: Text(
                              widget.isEnrolled
                                  ? 'already_enrolled'.tr
                                  : 'enroll_trainer'.tr,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.titleText.copyWith(
                                  fontSize: 18 * SizeConfig.textMultiplier!,
                                  color: kPureWhite),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container())
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.title,
      required this.onPress,
      required this.color,
      required this.textColor})
      : super(key: key);

  final String title;
  final VoidCallback onPress;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          height: 28 * SizeConfig.heightMultiplier!,
          padding: EdgeInsets.symmetric(
              vertical: 4 * SizeConfig.heightMultiplier!,
              horizontal: 12 * SizeConfig.widthMultiplier!),
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: kgreen49),
              borderRadius: BorderRadius.circular(8.0)),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.greenSemiBoldText.copyWith(color: textColor),
            ),
          )),
    );
  }
}

class AchivementCertificateTile extends StatelessWidget {
  const AchivementCertificateTile(
      {required this.color,
      required this.certificateDescription,
      required this.certificateIcon,
      Key? key})
      : super(key: key);
  final Color color;
  final String certificateDescription;
  final String certificateIcon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(certificateIcon);
        Get.to(() => ImageViewer(
              imgUrl: certificateIcon,
              label: certificateDescription.capitalize!,
            ));
      },
      child: Container(
        //79
        height: 81 * SizeConfig.heightMultiplier!,
        //214
        width: 214 * SizeConfig.widthMultiplier!,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 12 * SizeConfig.widthMultiplier!,
            ),
            CircleAvatar(
              radius: 19 * SizeConfig.heightMultiplier!,
              backgroundImage: NetworkImage(certificateIcon),
            ),
            SizedBox(
              width: 8 * SizeConfig.widthMultiplier!,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //height: 30 * SizeConfig.widthMultiplier!,
                  width: 134 * SizeConfig.heightMultiplier!,
                  child: Text(certificateDescription.capitalize!,
                      style: AppTextStyle.lightMediumBlackText.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyText1?.color)),
                ),
                SizedBox(
                  height: 4 * SizeConfig.heightMultiplier!,
                ),
                Text('certified'.tr,
                    style: AppTextStyle.lightMediumBlackText.copyWith(
                        fontSize: 12 * SizeConfig.textMultiplier!,
                        color: Theme.of(context).textTheme.bodyText1?.color))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PlanTile extends StatelessWidget {
  const PlanTile(
      {required this.rating,
      required this.planTitle,
      required this.likesCount,
      required this.ratingCount,
      required this.palnTime,
      required this.planImage,
      Key? key})
      : super(key: key);
  final double rating;
  final String planTitle;
  final String palnTime;
  final String likesCount;
  final String ratingCount;
  final String planImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250 * SizeConfig.heightMultiplier!,
      width: 160 * SizeConfig.widthMultiplier!,
      child: Card(
        color: Theme.of(context).textTheme.headline5?.color,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 144 * SizeConfig.heightMultiplier!,
              width: 160 * SizeConfig.widthMultiplier!,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
                child: Image.network(
                  planImage,
                  height: 144 * SizeConfig.heightMultiplier!,
                  width: 160 * SizeConfig.widthMultiplier!,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 8 * SizeConfig.heightMultiplier!),
            Padding(
              padding: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier!),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StarRating(
                            rating: rating,
                            color: kOrange,
                            axisAlignmentFromStart: true),
                        SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                        Text('(' + ratingCount + ')',
                            style: AppTextStyle.smallBlackText.copyWith(
                              fontSize: (12) * SizeConfig.textMultiplier!,
                              color:
                                  Theme.of(context).textTheme.headline3?.color,
                            ))
                      ],
                    ),
                    SizedBox(height: 4 * SizeConfig.heightMultiplier!),
                    Text(
                      planTitle,
                      style: AppTextStyle.lightMediumBlackText.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    SizedBox(height: 5.5 * SizeConfig.heightMultiplier!),
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagePath.clockIcon,
                          height: 10 * SizeConfig.widthMultiplier!,
                          width: 10 * SizeConfig.widthMultiplier!,
                          fit: BoxFit.contain,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        SizedBox(
                          width: 5.5 * SizeConfig.widthMultiplier!,
                        ),
                        Text(palnTime,
                            style: AppTextStyle.lightMediumBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 12 * SizeConfig.textMultiplier!))
                      ],
                    ),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 10.0 * SizeConfig.widthMultiplier!),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(likesCount,
                              style: AppTextStyle.greenSemiBoldText.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color)),
                          SizedBox(
                            width: 5.5 * SizeConfig.widthMultiplier!,
                          ),
                          SvgPicture.asset(
                            ImagePath.thumsUpIcon,
                            height: 12 * SizeConfig.heightMultiplier!,
                            width: 13.4 * SizeConfig.widthMultiplier!,
                            fit: BoxFit.contain,
                            color: Theme.of(context).textTheme.bodyText1?.color,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9 * SizeConfig.heightMultiplier!,
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

class UnfollowDialog extends StatefulWidget {
  const UnfollowDialog({Key? key}) : super(key: key);

  @override
  State<UnfollowDialog> createState() => _UnfollowDialogState();
}

class _UnfollowDialogState extends State<UnfollowDialog> {
  var trainerController = Get.find<TrainerController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: kBlack,
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
        ),
        padding: EdgeInsets.symmetric(
            vertical: 15 * SizeConfig.heightMultiplier!,
            horizontal: 15 * SizeConfig.widthMultiplier!),
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to unfollow ?',
              style: AppTextStyle.whiteTextWithWeight600
                  .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
            ),
            SizedBox(
              height: 20 * SizeConfig.heightMultiplier!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    trainerController.atrainerDetail.value.isFollowing = false;
                    trainerController.atrainerDetail.value.followers =
                        (int.tryParse(trainerController
                                    .atrainerDetail.value.followers!)! -
                                1)
                            .toString();
                    trainerController.atrainerDetail.refresh();
                    TrainerServices.unFollowTrainer(
                        trainerController.atrainerDetail.value.user!.id!);
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: kBlack),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0 * SizeConfig.heightMultiplier!,
                          horizontal: 23 * SizeConfig.widthMultiplier!),
                      child: Text(
                        'Yes',
                        style: AppTextStyle.normalWhiteText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20 * SizeConfig.widthMultiplier!,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kgreen4F),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0 * SizeConfig.heightMultiplier!,
                          horizontal: 23 * SizeConfig.widthMultiplier!),
                      child: Text(
                        'Cancel',
                        style: AppTextStyle.normalWhiteText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
    );
  }
}
