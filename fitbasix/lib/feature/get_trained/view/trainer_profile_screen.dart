import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrainerPage(
        trainerImage:
            'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg',
        onFollow: () {},
        onMessage: () {},
        onEnroll: () {},
        onBack: () {},
        name: "vartika Mangal",
        followersCount: "16.8k",
        followingCount: "1.3k",
        rating: 5.0,
        ratingCount: 431,
        totalPeopleTrained: 120,
        strengths: [
          'Sports Nutrition',
          'Fat-Loss',
          'General Well being',
          'General Well being'
        ],
        aboutTrainer:
            "Hi, This is Jonathan. I am certified by Institute Viverra cras facilisis massa amet, hendrerit nunc. Tristique tellus, massa scelerisque tincidunt neque dui metus, id pellentesque./n/nLet’s start your fitness journey!!!",
        certifcateTitle: [
          'Specialist in Sports Nutrition from ISSA...',
          'Specialist in Sports Nutrition from ISSA...'
        ],
      ),
    );
  }
}

class TrainerPage extends StatelessWidget {
  const TrainerPage(
      {required this.trainerImage,
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
      Key? key})
      : super(key: key);
  final String trainerImage;
  final String name;
  final String followersCount;
  final VoidCallback onFollow;
  final VoidCallback onEnroll;
  final VoidCallback onMessage;
  final VoidCallback onBack;
  final String followingCount;
  final int ratingCount;
  final int totalPeopleTrained;
  final double rating;
  final List<String> strengths;
  final List<String> certifcateTitle;
  final String aboutTrainer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 177 * SizeConfig.heightMultiplier!,
                          child: Image.asset(
                            ImagePath.trainerCoverImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 127 * SizeConfig.heightMultiplier!,
                          left: Get.width / 2 - 50,
                          child: Container(
                            height: 100,
                            child: CircleAvatar(
                              radius: 50 * SizeConfig.heightMultiplier!,
                              backgroundImage: NetworkImage(trainerImage),
                            ),
                          ),
                        ),
                        Positioned(
                            child: GestureDetector(
                          onTap: onBack,
                          child: Container(
                            height: 40 * SizeConfig.heightMultiplier!,
                            width: 40 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: SvgPicture.asset(
                              ImagePath.backIcon,
                              color: kPureBlack,
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 243 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      name,
                      style: AppTextStyle.titleText
                          .copyWith(fontSize: 18 * SizeConfig.textMultiplier!),
                    ),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          title: 'follow'.tr,
                          onPress: onFollow,
                          color: kGreenColor,
                        ),
                        SizedBox(
                          width: 12 * SizeConfig.widthMultiplier!,
                        ),
                        CustomButton(
                            title: 'message'.tr,
                            onPress: onMessage,
                            color: kGreyColor)
                      ],
                    ),
                    SizedBox(
                      height: 24 * SizeConfig.heightMultiplier!,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24.0 * SizeConfig.widthMultiplier!,
                          right: 27 * SizeConfig.heightMultiplier!),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(followersCount,
                                      style: AppTextStyle.boldBlackText),
                                  Text('follower'.tr,
                                      style: AppTextStyle.smallBlackText)
                                ],
                              ),
                              SizedBox(width: 25 * SizeConfig.widthMultiplier!),
                              Column(
                                children: [
                                  Text(followingCount,
                                      style: AppTextStyle.boldBlackText),
                                  Text('following'.tr,
                                      style: AppTextStyle.smallBlackText)
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    ratingCount.toString(),
                                    style: AppTextStyle.greenSemiBoldText,
                                  ),
                                  SizedBox(
                                      width: 8 * SizeConfig.widthMultiplier!),
                                  StarRating(
                                    rating: rating,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    totalPeopleTrained.toString(),
                                    style: AppTextStyle.greenSemiBoldText
                                        .copyWith(color: lightBlack),
                                  ),
                                  SizedBox(
                                      width: 8 * SizeConfig.widthMultiplier!),
                                  Text(
                                    'people_trained'.tr,
                                    style: AppTextStyle.smallBlackText,
                                  )
                                ],
                              ),
                              Text(
                                'view_and_review'.tr,
                                style: AppTextStyle.smallBlackText.copyWith(
                                    color: greyColor,
                                    decoration: TextDecoration.underline),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24.0 * SizeConfig.heightMultiplier!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'strength'.tr,
                            style: AppTextStyle.greenSemiBoldText
                                .copyWith(color: lightBlack),
                          ),
                          SizedBox(height: 12 * SizeConfig.heightMultiplier!),
                          Container(
                            height: 28 * SizeConfig.heightMultiplier!,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: strengths.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            8.0 * SizeConfig.widthMultiplier!),
                                    child: Container(
                                      height: 28 * SizeConfig.heightMultiplier!,
                                      decoration: BoxDecoration(
                                          color: offWhite,
                                          borderRadius: BorderRadius.circular(
                                              28 *
                                                  SizeConfig
                                                      .heightMultiplier!)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12 *
                                                SizeConfig.widthMultiplier!),
                                        child: Text(
                                          strengths[index],
                                          style:
                                              AppTextStyle.lightMediumBlackText,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                          Text(
                            'achivement'.tr,
                            style: AppTextStyle.greenSemiBoldText
                                .copyWith(color: lightBlack),
                          ),
                          SizedBox(height: 12 * SizeConfig.heightMultiplier!),
                          Container(
                            height: 79 * SizeConfig.heightMultiplier!,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: certifcateTitle.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            8.0 * SizeConfig.widthMultiplier!),
                                    child: AchivementCertificateTile(
                                      certificateDescription:
                                          certifcateTitle[index],
                                      color: index % 2 == 0
                                          ? oceanBlue
                                          : lightOrange,
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                          Text(
                            'about'.tr,
                            style: AppTextStyle.greenSemiBoldText
                                .copyWith(color: lightBlack),
                          ),
                          SizedBox(height: 12 * SizeConfig.heightMultiplier!),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 24.0 * SizeConfig.widthMultiplier!),
                            child: Text(
                              aboutTrainer,
                              style: AppTextStyle.lightMediumBlackText.copyWith(
                                  fontSize: (14) * SizeConfig.textMultiplier!),
                            ),
                          ),
                          SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                          Text('plan'.tr,
                              style: AppTextStyle.greenSemiBoldText
                                  .copyWith(color: lightBlack)),
                          SizedBox(height: 12 * SizeConfig.heightMultiplier!),
                          PlanTile(
                            rating: 5,
                            planTitle: "Sports Nutrition",
                            palnTime: "8 weeks plan",
                            likesCount: "16.8k",
                            ratingCount: "123",
                          ),
                          SizedBox(height: 224 * SizeConfig.heightMultiplier!),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            //To be docked at bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: kPureWhite,
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
                              vertical: 10 * SizeConfig.widthMultiplier!),
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
          width: 102 * SizeConfig.widthMultiplier!,
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
      {required this.color, required this.certificateDescription, Key? key})
      : super(key: key);
  final Color color;
  final String certificateDescription;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79 * SizeConfig.heightMultiplier!,
      width: 214 * SizeConfig.widthMultiplier!,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: color),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 38 * SizeConfig.widthMultiplier!,
              width: 38 * SizeConfig.widthMultiplier!,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: kDarkGrey)),
          SizedBox(
            width: 8 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30 * SizeConfig.widthMultiplier!,
                width: 144 * SizeConfig.heightMultiplier!,
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
      Key? key})
      : super(key: key);
  final double rating;
  final String planTitle;
  final String palnTime;
  final String likesCount;
  final String ratingCount;
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
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
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
