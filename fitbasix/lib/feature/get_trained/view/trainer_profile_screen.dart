import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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

class TrainerPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final TrainerController trainerController = Get.put(TrainerController());
    return Scaffold(
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
                                    name,
                                    style: AppTextStyle.titleText.copyWith(
                                        fontSize:
                                            18 * SizeConfig.textMultiplier!),
                                  ),
                                  SizedBox(
                                    height: 12 * SizeConfig.heightMultiplier!,
                                  ),
                                  CustomButton(
                                    title: 'send_a_message'.tr,
                                    onPress: onFollow,
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
                                          Text(followersCount,
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
                                          Text(followingCount,
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
                                            ratingCount.toString(),
                                            style:
                                                AppTextStyle.greenSemiBoldText,
                                          ),
                                          SizedBox(
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!),
                                          StarRating(
                                            rating: rating,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            totalPeopleTrained.toString(),
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
                                  left: 24.0 * SizeConfig.widthMultiplier!),
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
                                        itemCount: strengths.length,
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
                                                    strengths[index]
                                                        .name
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
                                  certifcateTitle.length == 0
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
                                  certifcateTitle.length == 0
                                      ? Container()
                                      : Container(
                                          height:
                                              79 * SizeConfig.heightMultiplier!,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: certifcateTitle.length,
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
                                                        certifcateTitle[index]
                                                            .certificateName!,
                                                    certificateIcon:
                                                        certifcateTitle[index]
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
                                      aboutTrainer,
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
                                      : allPlans.length != 0
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
                                      : (allPlans.length != 0
                                          ? Container(
                                              height: 238 *
                                                  SizeConfig.heightMultiplier!,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: allPlans.length,
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
                                                            allPlans[index]
                                                                .plansRating
                                                                .toString()),
                                                        planTitle:
                                                            allPlans[index]
                                                                .planName!,
                                                        planImage:
                                                            allPlans[index]
                                                                .planIcon!,
                                                        palnTime: 'planTime'
                                                            .trParams({
                                                          'duration': (allPlans[
                                                                          index]
                                                                      .planDuration! %
                                                                  5)
                                                              .toString()
                                                        }),
                                                        likesCount: NumberFormatter
                                                            .textFormatter(
                                                                allPlans[index]
                                                                    .likesCount!
                                                                    .toString()),
                                                        ratingCount: NumberFormatter
                                                            .textFormatter(
                                                                allPlans[index]
                                                                    .raters!
                                                                    .toString()),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          : SizedBox())),
                                  SizedBox(
                                      height:
                                          224 * SizeConfig.heightMultiplier!),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 177 * SizeConfig.heightMultiplier!,
                          child: Image.network(
                            trainerCoverImage,
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
                              backgroundImage: NetworkImage(trainerImage),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 16 * SizeConfig.heightMultiplier!,
                            left: 16 * SizeConfig.widthMultiplier!,
                            child: GestureDetector(
                              onTap: onBack,
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
                        onPressed: onFollow,
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
                      onTap: onEnroll,
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
