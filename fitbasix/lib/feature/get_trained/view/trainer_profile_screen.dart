import 'dart:async';

import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/number_format.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrainerController trainerController = Get.put(TrainerController());
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => TrainerPage(
            trainerImage:
                trainerController.atrainerDetail.value.user!.profilePhoto!,
            trainerCoverImage: trainerController
                .atrainerDetail.value.user!.coverPhoto!
                .toString(),
            onFollow: () {
              TrainerServices.followTrainer(
                  trainerController.atrainerDetail.value.user!.id!);
            },
            onMessage: () {},
            onEnroll: () {},
            onBack: () {
              Navigator.pop(context);
            },
            name: trainerController.atrainerDetail.value.user!.name!,
            followersCount: NumberFormatter.textFormatter(
                trainerController.atrainerDetail.value.followers!),
            followingCount: NumberFormatter.textFormatter(
                trainerController.atrainerDetail.value.following!),
            rating:
                double.parse(trainerController.atrainerDetail.value.rating!),
            ratingCount: NumberFormatter.textFormatter(
                trainerController.atrainerDetail.value.totalRating!),
            totalPeopleTrained: NumberFormatter.textFormatter(
                trainerController.atrainerDetail.value.trainees!),
            strengths: trainerController.atrainerDetail.value.strength!,
            aboutTrainer: trainerController.atrainerDetail.value.about!,
            certifcateTitle:
                trainerController.atrainerDetail.value.certificates!,
            allPlans: trainerController.isProfileLoading.value
                ? []
                : trainerController.planModel.value.response!.data!,
          ),
        ),
      ),
    );
  }
}

class TrainerPage extends StatefulWidget {
  const TrainerPage(
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
      Key? key})
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

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  final HomeController _homeController = Get.find();
  final ScrollController _scrollController = ScrollController();
  final TrainerController _trainerController = Get.find();
  final List<PostsModel> _list = <PostsModel>[];
  final StreamController<List<PostsModel>> postController =
      StreamController<List<PostsModel>>.broadcast();

  @override
  void initState() {
    var postQuery = HomeService.getPosts();
    postQuery.listen((event) {
      _list.addAll(event);
      postController.sink.add(_list);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        var postQuery = TrainerServices.getTrainerPosts(
            _trainerController.atrainerDetail.value.user!.id!);
        postQuery.listen((event) {
          if (event[0].response!.data!.length < 5) {
            _list.addAll(event);
            postController.sink.add(_list);
            return;
          } else {
            _list.addAll(event);
            postController.sink.add(_list);
          }
        });
        _trainerController.currentPage.value++;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TrainerController trainerController = Get.put(TrainerController());
    return Scaffold(
      backgroundColor: kPureWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 187 * SizeConfig.heightMultiplier!,
                                  ),
                                  Text(
                                    widget.name,
                                    style: AppTextStyle.titleText.copyWith(
                                        fontSize:
                                            18 * SizeConfig.textMultiplier!),
                                  ),
                                  SizedBox(
                                    height: 12 * SizeConfig.heightMultiplier!,
                                  ),
                                  CustomButton(
                                    title: 'send_a_message'.tr,
                                    onPress: widget.onFollow,
                                    color: kGreenColor,
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
                                      Column(
                                        children: [
                                          Text(widget.followersCount,
                                              style:
                                                  AppTextStyle.boldBlackText),
                                          Text('follower'.tr,
                                              style:
                                                  AppTextStyle.smallBlackText)
                                        ],
                                      ),
                                      SizedBox(
                                          width:
                                              25 * SizeConfig.widthMultiplier!),
                                      Column(
                                        children: [
                                          Text(widget.followingCount,
                                              style:
                                                  AppTextStyle.boldBlackText),
                                          Text('following'.tr,
                                              style:
                                                  AppTextStyle.smallBlackText)
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1,
                                    height: 56 * SizeConfig.widthMultiplier!,
                                    color: kDarkGrey,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.ratingCount.toString(),
                                            style:
                                                AppTextStyle.greenSemiBoldText,
                                          ),
                                          SizedBox(
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!),
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
                                                .copyWith(color: lightBlack),
                                          ),
                                          SizedBox(
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!),
                                          Text(
                                            'people_trained'.tr,
                                            style: AppTextStyle.smallBlackText,
                                          )
                                        ],
                                      ),
                                      Text(
                                        'view_and_review'.tr,
                                        style: AppTextStyle.smallBlackText
                                            .copyWith(
                                                color: greyColor,
                                                decoration:
                                                    TextDecoration.underline),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24.0 * SizeConfig.widthMultiplier!,
                                  bottom: 24 * SizeConfig.heightMultiplier!),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'strength'.tr,
                                    style: AppTextStyle.greenSemiBoldText
                                        .copyWith(color: lightBlack),
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
                                                ? EdgeInsets.all(0)
                                                : EdgeInsets.only(
                                                    left: 8.0 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                            child: Container(
                                              height: 28 *
                                                  SizeConfig.heightMultiplier!,
                                              decoration: BoxDecoration(
                                                  color: offWhite,
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
                                                        .lightMediumBlackText,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  widget.certifcateTitle.length == 0
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              top: 24 *
                                                  SizeConfig.heightMultiplier!,
                                              bottom: 12 *
                                                  SizeConfig.heightMultiplier!),
                                          child: Text(
                                            'achivement'.tr,
                                            style: AppTextStyle
                                                .greenSemiBoldText
                                                .copyWith(color: lightBlack),
                                          ),
                                        ),
                                  widget.certifcateTitle.length == 0
                                      ? Container()
                                      : Container(
                                          height:
                                              79 * SizeConfig.heightMultiplier!,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  widget.certifcateTitle.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0 *
                                                          SizeConfig
                                                              .widthMultiplier!),
                                                  child:
                                                      AchivementCertificateTile(
                                                    certificateDescription:
                                                        widget
                                                            .certifcateTitle[
                                                                index]
                                                            .certificateName!,
                                                    certificateIcon: widget
                                                        .certifcateTitle[index]
                                                        .url!,
                                                    color: index % 2 == 0
                                                        ? oceanBlue
                                                        : lightOrange,
                                                  ),
                                                );
                                              }),
                                        ),
                                  SizedBox(
                                      height:
                                          24 * SizeConfig.heightMultiplier!),
                                  Text(
                                    'about'.tr,
                                    style: AppTextStyle.greenSemiBoldText
                                        .copyWith(color: lightBlack),
                                  ),
                                  SizedBox(
                                      height:
                                          12 * SizeConfig.heightMultiplier!),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            24.0 * SizeConfig.widthMultiplier!),
                                    child: Text(
                                      widget.aboutTrainer,
                                      style: AppTextStyle.lightMediumBlackText
                                          .copyWith(
                                              fontSize: (14) *
                                                  SizeConfig.textMultiplier!),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          24 * SizeConfig.heightMultiplier!),
                                  Obx(() => trainerController
                                          .isProfileLoading.value
                                      ? Text('plan'.tr,
                                          style: AppTextStyle.greenSemiBoldText
                                              .copyWith(color: lightBlack))
                                      : widget.allPlans.length != 0
                                          ? Text('plan'.tr,
                                              style: AppTextStyle
                                                  .greenSemiBoldText
                                                  .copyWith(color: lightBlack))
                                          : SizedBox()),
                                  SizedBox(
                                      height:
                                          12 * SizeConfig.heightMultiplier!),
                                  Obx(() => trainerController
                                          .isProfileLoading.value
                                      ? Container(
                                          height: 238 *
                                              SizeConfig.heightMultiplier!,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 4,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Shimmer.fromColors(
                                                  baseColor:
                                                      const Color.fromRGBO(
                                                          230, 230, 230, 1),
                                                  highlightColor:
                                                      const Color.fromRGBO(
                                                          242, 245, 245, 1),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0 *
                                                            SizeConfig
                                                                .widthMultiplier!),
                                                    child: PlanTile(
                                                      rating: double.parse("2"),
                                                      planTitle: "",
                                                      planImage:
                                                          "https://randomuser.me/api/portraits/men/1.jpg",
                                                      palnTime: "",
                                                      likesCount: "",
                                                      ratingCount: "",
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      : (widget.allPlans.length != 0
                                          ? Container(
                                              height: 238 *
                                                  SizeConfig.heightMultiplier!,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      widget.allPlans.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0 *
                                                              SizeConfig
                                                                  .widthMultiplier!),
                                                      child: PlanTile(
                                                        rating: double.parse(
                                                            widget
                                                                .allPlans[index]
                                                                .plansRating
                                                                .toString()),
                                                        planTitle: widget
                                                            .allPlans[index]
                                                            .planName!,
                                                        planImage: widget
                                                            .allPlans[index]
                                                            .planIcon!,
                                                        palnTime: 'planTime'
                                                            .trParams({
                                                          'duration': (widget
                                                                      .allPlans[
                                                                          index]
                                                                      .planDuration! %
                                                                  5)
                                                              .toString()
                                                        }),
                                                        likesCount: NumberFormatter
                                                            .textFormatter(widget
                                                                .allPlans[index]
                                                                .likesCount!
                                                                .toString()),
                                                        ratingCount: NumberFormatter
                                                            .textFormatter(widget
                                                                .allPlans[index]
                                                                .raters!
                                                                .toString()),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          : SizedBox())),
                                ],
                              ),
                            ),
                            Container(
                              height: 16 * SizeConfig.heightMultiplier!,
                              color: kBackgroundColor,
                            ),
                            StreamBuilder<List<PostsModel>>(
                                stream: postController.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return ListView.builder(
                                              itemCount: snapshot.data![index]
                                                  .response!.data!.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (_, index2) {
                                                return Column(
                                                  children: [
                                                    PostTile(
                                                      name: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .userId!
                                                          .name!,
                                                      profilePhoto: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .userId!
                                                          .profilePhoto!,
                                                      category: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .postCategory![0]
                                                          .name!,
                                                      date: DateFormat.d()
                                                          .add_MMM()
                                                          .format(snapshot
                                                              .data![index]
                                                              .response!
                                                              .data![index2]
                                                              .updatedAt!),
                                                      place: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .location!
                                                          .placeName![1]
                                                          .toString(),
                                                      imageUrl: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .files![0],
                                                      caption: snapshot
                                                              .data![index]
                                                              .response!
                                                              .data![index2]
                                                              .caption ??
                                                          '',
                                                      likes: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .likes
                                                          .toString(),
                                                      comments: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .comments
                                                          .toString(),
                                                      hitLike: () {
                                                        HomeService.likePost(
                                                            postId: snapshot
                                                                .data![index]
                                                                .response!
                                                                .data![index2]
                                                                .id!);
                                                        setState(() {});
                                                      },
                                                      addComment: () {
                                                        HomeService.addComment(
                                                            snapshot
                                                                .data![index]
                                                                .response!
                                                                .data![index2]
                                                                .id!,
                                                            _homeController
                                                                .comment.value);

                                                        setState(() {});
                                                        _homeController
                                                            .commentController
                                                            .clear();
                                                      },
                                                      postId: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .id!,
                                                      isLiked: snapshot
                                                          .data![index]
                                                          .response!
                                                          .data![index2]
                                                          .isLiked!,
                                                    ),
                                                    Container(
                                                      height: 16 *
                                                          SizeConfig
                                                              .heightMultiplier!,
                                                      color: kBackgroundColor,
                                                    )
                                                  ],
                                                );
                                              });
                                        });
                                  return Center(
                                    child: CustomizedCircularProgress(),
                                  );
                                }),
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
                            fit: BoxFit.fill,
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
                                    color: Colors.white),
                                child: SvgPicture.asset(
                                  ImagePath.backIcon,
                                  color: kPureBlack,
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

            //To be docked at bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: kPureWhite,
                padding: EdgeInsets.symmetric(
                    vertical: 8 * SizeConfig.heightMultiplier!,
                    horizontal: 16 * SizeConfig.widthMultiplier!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: widget.onFollow,
                        icon: Icon(
                          Icons.person_add,
                          color: kGreenColor,
                        ),
                        label: Text(
                          'follow'.tr,
                          style: AppTextStyle.titleText.copyWith(
                              fontSize: 18 * SizeConfig.textMultiplier!,
                              color: kGreenColor),
                        )),
                    GestureDetector(
                      onTap: widget.onEnroll,
                      child: Container(
                        decoration: BoxDecoration(
                            color: kGreenColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 31.0 * SizeConfig.widthMultiplier!,
                              vertical: 14 * SizeConfig.heightMultiplier!),
                          child: Text(
                            'enroll'.tr,
                            style: AppTextStyle.titleText.copyWith(
                                fontSize: 18 * SizeConfig.textMultiplier!,
                                color: kPureWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
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
      required this.color})
      : super(key: key);

  final String title;
  final VoidCallback onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          height: 28 * SizeConfig.heightMultiplier!,
          width: 140 * SizeConfig.widthMultiplier!,
          padding: EdgeInsets.symmetric(
            vertical: 4 * SizeConfig.heightMultiplier!,
          ),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(8.0)),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.greenSemiBoldText.copyWith(color: kPureWhite),
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
    return Container(
      height: 79 * SizeConfig.heightMultiplier!,
      width: 222 * SizeConfig.widthMultiplier!,
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
                child: Text(certificateDescription,
                    style: AppTextStyle.lightMediumBlackText
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier!,
              ),
              Text('certified'.tr,
                  style: AppTextStyle.lightMediumBlackText
                      .copyWith(fontSize: 12 * SizeConfig.textMultiplier!))
            ],
          )
        ],
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
      height: 238 * SizeConfig.heightMultiplier!,
      width: 160 * SizeConfig.widthMultiplier!,
      child: Card(
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
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
                            style: AppTextStyle.smallBlackText
                                .copyWith(color: greyColor))
                      ],
                    ),
                    SizedBox(height: 4 * SizeConfig.heightMultiplier!),
                    Text(
                      planTitle,
                      style: AppTextStyle.lightMediumBlackText
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5.5 * SizeConfig.heightMultiplier!),
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagePath.clockIcon,
                          height: 10 * SizeConfig.widthMultiplier!,
                          width: 10 * SizeConfig.widthMultiplier!,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 5.5 * SizeConfig.widthMultiplier!,
                        ),
                        Text(palnTime,
                            style: AppTextStyle.lightMediumBlackText.copyWith(
                                fontSize: 10 * SizeConfig.textMultiplier!))
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
                              style: AppTextStyle.greenSemiBoldText
                                  .copyWith(color: lightBlack)),
                          SizedBox(
                            width: 5.5 * SizeConfig.widthMultiplier!,
                          ),
                          SvgPicture.asset(
                            ImagePath.thumsUpIcon,
                            height: 12 * SizeConfig.heightMultiplier!,
                            width: 13.4 * SizeConfig.widthMultiplier!,
                            fit: BoxFit.contain,
                          )
                        ],
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
