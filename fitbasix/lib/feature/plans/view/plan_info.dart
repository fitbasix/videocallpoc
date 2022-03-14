import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/plans/view/widget/custom_buttonforplan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/universal_widgets/number_format.dart';
import '../../get_trained/controller/trainer_controller.dart';
import '../../get_trained/services/trainer_services.dart';
import '../../get_trained/view/widgets/star_rating.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PlanInformationUI extends StatefulWidget {
  PlanInformationUI({Key? key}) : super(key: key);

  @override
  _PlanInformationUIState createState() => _PlanInformationUIState();
}

// var imageurl =
//     "https://s3-alpha-sig.figma.com/img/a2f9/9007/54ca7015b64810f8e3185115236ee597?Expires=1646611200&Signature=GnAVttQd8W9Gbw72FGeDEuRqcIwRIv7TzsltIw9CpqBZKHnqC5WcG4dQ6j168SFz0sl6lHk2qlzE1TrFdZIIcmc~ue0wIEy2lvghS86Kr7xQpTRqbF0fakP-El-nUTxcg~X2kQm8kKtgPgFW3qmlWlPAMKlgHQO62TzPY8sngV5GEP4fFjjHfLHC~f-3kUUX-jPPU62t79Zb7svcWbBUKjh0zP-bzpv1j1tjbHayvqzH~PJRDBlJwdclSzkAoguX~bMeyFelgsApFhl~saCTFb~~YY1gKzIPFaG94ft3fTYcKtLLeCiYq-JpyFFX-UrLfrz3lMjIbgGrfSdMQMGuWg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA";
// var trainernetworkimage =
//     "https://s3-alpha-sig.figma.com/img/3602/51de/062e5d1fd0d2c7f3ae10cd8973b3a786?Expires=1646611200&Signature=Tizz9xU3c44ik2xIGwP3UiQsxNRb6AQG1iM8idByENnF2PrH9K1V90zMc3fY8jgYWObS-e767vFy0CjKZPenEbBpx3fOSa2O4jaaOMdWVptfrQJyG024A1lvudJ5INSCyJgu6kKemRVwX27MtbNAv9~7OMIhul7wY~apbwwiJc0cWZ8s9abvx3qhSaIKsaTrnaj61VzJfMdLH4dpMvwyrrJSX01GKZp0pnZaJhq20V5etaPsu1bL4c~DfvOT6UZDmIgmFLBi7dlVfJ0Je5FPn2-blSJdjPgsPjs-S36hpq7zMO~bxrgRQAYSQO7xVsFS7Hjnb0TuOzCGrTCyHT-xnA__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA";

class _PlanInformationUIState extends State<PlanInformationUI> {
  final TrainerController trainerController = Get.find();
  void getPlan() async {
    trainerController.fullPlanInfoLoading.value = true;
    trainerController.fullPlanDetails.value = await TrainerServices.getPlanById(
        trainerController.selectedPlanId.value);
    trainerController.fullPlanInfoLoading.value = false;
  }

  @override
  void initState() {
    getPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPureWhite,
        body: Obx(
          () => trainerController.fullPlanInfoLoading.value
              ? Center(
                  child: CustomizedCircularProgress(),
                )
              : TrainerPlanScreen(
                  backgroundUrl: trainerController
                      .fullPlanDetails.value.response!.data!.planIcon
                      .toString(),
                  onGetdemo: () async {
                    trainerController.weekAvailableSlots.value = [];
                    Navigator.pushNamed(context, RouteName.planTimingScreen);
                    // trainerController.fullPlanDetails.value.response!.data!
                    //             .isEnrolled ==
                    //         false
                    //     ? Navigator.pushNamed(
                    //         context, RouteName.planTimingScreen)
                    //     : "";
                    trainerController.isAvailableSlotDataLoading.value = true;
                    var output = await TrainerServices.getAllTimeSlot();
                    trainerController.getAllSlots.value =
                        output.response!.data!;

                    // trainerController.availableSlots.value =
                    //     await TrainerServices.getEnrolledPlanDetails(
                    //         trainerController.fullPlanDetails.value.response!
                    //             .data!.trainer!.trainerId!);
                    trainerController.isAvailableSlotDataLoading.value = false;
                  },
                  onEnrollnow: () async {
                    trainerController.weekAvailableSlots.value = [];
                    Navigator.pushNamed(context, RouteName.planTimingScreen);
                    // trainerController.fullPlanDetails.value.response!.data!
                    //             .isEnrolled ==
                    //         false
                    //     ? Navigator.pushNamed(
                    //         context, RouteName.planTimingScreen)
                    //     : "";
                    trainerController.isAvailableSlotDataLoading.value = true;
                    var output = await TrainerServices.getAllTimeSlot();
                    trainerController.getAllSlots.value =
                        output.response!.data!;

                    // trainerController.availableSlots.value =
                    //     await TrainerServices.getEnrolledPlanDetails(
                    //         trainerController.fullPlanDetails.value.response!
                    //             .data!.trainer!.trainerId!);
                    trainerController.isAvailableSlotDataLoading.value = false;
                  },
                  onfollowtrainer: () {
                    // trainerController.fullPlanDetails.value.response!.data!
                    //     .trainer!.isFollowing = true;
                    // trainerController.fullPlanDetails.value.response!.data!
                    //     .trainer!.followers = (int.tryParse(trainerController
                    //         .fullPlanDetails
                    //         .value
                    //         .response!
                    //         .data!
                    //         .trainer!
                    //         .followers!
                    //         .toString())! +
                    //     1);
                    TrainerServices.followTrainer(
                        trainerController.atrainerDetail.value.user!.id!);
                    setState(() {});
                  },
                  // isFollowing: trainerController.fullPlanDetails.value.response!
                  //     .data!.trainer!.isFollowing,
                  onmessagetrainer: () {},
                  // trainerName: trainerController
                  //     .fullPlanDetails.value.response!.data!.trainer!.name
                  //     .toString(),
                  // planLanguage: trainerController
                  //     .fullPlanDetails.value.response!.data!.language
                  //     .toString(),
                  planduration: trainerController
                          .fullPlanDetails.value.response!.data!.planDuration
                          .toString() +
                      ' weeks',
                  plandescription: trainerController
                      .fullPlanDetails.value.response!.data!.description
                      .toString(),
                  plankeypoints: trainerController
                      .fullPlanDetails.value.response!.data!.keyPoints!,
                  // planequipment: trainerController
                  //     .fullPlanDetails.value.response!.data!.equipments!,
                  planprizing: 'AED ' +
                      trainerController
                          .fullPlanDetails.value.response!.data!.price
                          .toString(),
                  // traineravatarUrl: trainerController.fullPlanDetails.value
                  //     .response!.data!.trainer!.profilePhoto,
                  // followerscount: NumberFormatter.textFormatter(
                  //     trainerController.fullPlanDetails.value.response!.data!
                  //         .trainer!.followers!
                  //         .toString()),
                  // followingcount: NumberFormatter.textFormatter(
                  //     trainerController.fullPlanDetails.value.response!.data!
                  //         .trainer!.followings!
                  //         .toString()),
                  // rating: trainerController
                  //     .fullPlanDetails.value.response!.data!.plansRating!,
                  // ratingCount: NumberFormatter.textFormatter(trainerController
                  //     .fullPlanDetails.value.response!.data!.raters
                  //     .toString()),
                  // totalPeopleTrained: NumberFormatter.textFormatter(
                  //     trainerController
                  //         .fullPlanDetails.value.response!.data!.trainees
                  //         .toString()),
                  // reviewdiscription:
                  //     'Venenatis, feugiat quis nibh faucibus pellentesque. '
                  //     'Dignissim sed feugiat turpis tortor. Viverra sed '
                  //     'dictumst scelerisque nunc, at eu ullamcorper.'
                  //     ' Enim, sagittis consectetur vitae elementum diam interdum. ',
                  // reviewdate: '3 days ago',
                  // reviewStarcount: '5',
                  // reviewPersonName: 'Rajesh Sharma',
                  // reviewPersonDetail: '18 plans/member since 2022',
                  // totalreviewrating: '4.7',
                ),
        ));
  }
}

class TrainerPlanScreen extends StatefulWidget {
  final String? backgroundUrl;
  final String? traineravatarUrl;
  final VoidCallback? onGetdemo;
  final VoidCallback? onEnrollnow;
  final VoidCallback? onfollowtrainer;
  final VoidCallback? onmessagetrainer;
  //final String? planLanguage;
  final String? planduration;
  final String? plandescription;
  final List<String> plankeypoints;
  //final List<String> planequipment;
  final String? planprizing;
  final String? trainerName;
  final String? followerscount;
  final String? followingcount;
  //final String? ratingCount;
  //final String? totalPeopleTrained;
  //final double? rating;
  final String? reviewdiscription;
  final String? reviewdate;
  final String? reviewStarcount;
  final String? reviewPersonName;
  final String? reviewPersonDetail;
  final String? reviewPersonCircleavatar;
  final String? totalreviewrating;
  final bool? isFollowing;
  double? value = 1.0;

  TrainerPlanScreen(
      {this.backgroundUrl,
      this.onGetdemo,
      this.onEnrollnow,
      this.followingcount,
      this.followerscount,
      this.trainerName,
      this.plandescription,
      this.planduration,
      //required this.planequipment,
      required this.plankeypoints,
      //this.planLanguage,
      this.planprizing,
      //this.rating,
      // this.ratingCount,
      // this.totalPeopleTrained,
      this.traineravatarUrl,
      this.onfollowtrainer,
      this.onmessagetrainer,
      this.reviewdate,
      this.reviewdiscription,
      this.reviewStarcount,
      this.reviewPersonName,
      this.reviewPersonDetail,
      this.reviewPersonCircleavatar,
      this.totalreviewrating,
      this.isFollowing,
      Key? key})
      : super(key: key);
  @override
  _TrainerPlanScreenState createState() => _TrainerPlanScreenState();
}

class _TrainerPlanScreenState extends State<TrainerPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 216 * SizeConfig.heightMultiplier!),
                  //trainerplanInfoWidget
                  _BuildTrainerPlanInfo(),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1 * SizeConfig.heightMultiplier!,
                    height: 1 * SizeConfig.heightMultiplier!,
                  ),
                  //
                  //trainerinfoWidget
                  // _BuildTrainerinfo(),
                  Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1 * SizeConfig.heightMultiplier!,
                    height: 1 * SizeConfig.heightMultiplier!,
                  ),
                  // Review of the plan
                  // _BuildReviewofPlan(),

                  // get a demo & enroll button
                  Container(
                    decoration: BoxDecoration(color: kPureWhite, boxShadow: [
                      BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.1),
                          blurRadius: 4.0, // soften the shadow
                          spreadRadius: 4.0,
                          offset: Offset(0, -2.0))
                    ]),
                    padding: EdgeInsets.only(
                        top: 8 * SizeConfig.heightMultiplier!,
                        bottom: 16 * SizeConfig.heightMultiplier!,
                        right: 16 * SizeConfig.widthMultiplier!,
                        left: 42.5 * SizeConfig.widthMultiplier!),
                    height: 72 * SizeConfig.heightMultiplier!,
                    width: double.infinity,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Text(
                            'get_a_demo'.tr,
                            style: AppTextStyle.boldBlackText
                                .copyWith(color: kgreen4F),
                          ),
                          onTap: widget.onGetdemo!,
                        ),
                        Spacer(),
                        CustomButtonPlanScreen(
                          colour: kgreen4F,
                          width: 156 * SizeConfig.widthMultiplier!,
                          height: 48 * SizeConfig.heightMultiplier!,
                          onpressed: widget.onEnrollnow!,
                          Text: Text('enroll_now'.tr,
                              style: AppTextStyle.hboldWhiteText),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                height: 216 * SizeConfig.heightMultiplier!,
                child: Image.network(
                  widget.backgroundUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              //backbutton
              Positioned(
                  top: 8 * SizeConfig.heightMultiplier!,
                  left: 16 * SizeConfig.widthMultiplier!,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40 * SizeConfig.heightMultiplier!,
                      width: 40 * SizeConfig.heightMultiplier!,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: SvgPicture.asset(
                        ImagePath.backIcon,
                        color: kPureBlack,
                        height: 12,
                        width: 7.41,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  //Icon Widget used in keypoints,equipment,Instructed
  Widget _BuildIcon(
    String? title,
    ImageIcon? Icon,
  ) =>
      Padding(
        padding: EdgeInsets.only(
          bottom: 8 * SizeConfig.heightMultiplier!,
          // right: 32*SizeConfig.widthMultiplier!
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon!,
            SizedBox(
              width: 8 * SizeConfig.widthMultiplier!,
            ),
            Expanded(
              child: Text(
                title!,
                style: AppTextStyle.hblack400Text.copyWith(color: kBlack),
              ),
            ),
          ],
        ),
      );

  //trainer plan info
  Widget _BuildTrainerPlanInfo() => Container(
        margin: EdgeInsets.symmetric(
          vertical: 24 * SizeConfig.heightMultiplier!,
          horizontal: 16 * SizeConfig.widthMultiplier!,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'loose_fat_buildmuscle'.tr,
              style: AppTextStyle.boldBlackText
                  .copyWith(color: kPureBlack, letterSpacing: -0.08),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            //rating section
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            //instructor
            Text('instructed_by'.tr + " " + widget.trainerName!.tr,
                style: AppTextStyle.hblackSemiBoldText),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            //plan duration & language
            // _BuildIcon(
            //     widget.planLanguage!.tr,
            //     ImageIcon(
            //       AssetImage(
            //         ImagePath.planlanguageIcon,
            //       ),
            //       size: 15 * SizeConfig.imageSizeMultiplier!,
            //       color: hintGrey,
            //     )),

            _BuildIcon(
                widget.planduration!.tr,
                ImageIcon(
                  AssetImage(ImagePath.plantimerPNGIcon),
                  size: 15 * SizeConfig.imageSizeMultiplier!,
                  color: hintGrey,
                )),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            //Description
            Text('description'.tr,
                style: AppTextStyle.hblackSemiBoldText
                    .copyWith(letterSpacing: -0.08)),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            Text(widget.plandescription!.tr,
                style: AppTextStyle.hblackSemiBoldText.copyWith(
                    fontWeight: FontWeight.w400, fontStyle: FontStyle.normal)),
            SizedBox(
              height: 24 * SizeConfig.heightMultiplier!,
            ),
            //Key points
            Text('key_points'.tr,
                style: AppTextStyle.hblackSemiBoldText
                    .copyWith(letterSpacing: -0.08)),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            ListView.builder(
                itemCount: widget.plankeypoints.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _BuildIcon(
                      widget.plankeypoints[index],
                      ImageIcon(
                        AssetImage(ImagePath.plangreentickIcon),
                        size: 15 * SizeConfig.imageSizeMultiplier!,
                        color: kgreen4F,
                      ));
                }),

            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            //Equipment
            Text('equipment'.tr,
                style: AppTextStyle.hblackSemiBoldText
                    .copyWith(letterSpacing: -0.08)),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            // ListView.builder(
            //     itemCount: widget.planequipment.length,
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     itemBuilder: (BuildContext context, int index) {
            //       return _BuildIcon(
            //           widget.planequipment[index],
            //           ImageIcon(
            //             AssetImage(ImagePath.planredIcon),
            //             size: 8 * SizeConfig.imageSizeMultiplier!,
            //             color: Color(0xFFD05252),
            //           ));
            //     }),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            //Plan Prizing
            Text('plan_pricing'.tr,
                style: AppTextStyle.hblackSemiBoldText
                    .copyWith(letterSpacing: -0.08)),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            Text(
              widget.planprizing!.tr,
              style: AppTextStyle.hblackSemiBoldText.copyWith(
                  fontSize: (24) * SizeConfig.textMultiplier!,
                  letterSpacing: 1),
            ),
          ],
        ),
      );

  //Trainer info widget
  // Widget _BuildTrainerinfo() => Container(
  //       padding: EdgeInsets.all(24 * SizeConfig.widthMultiplier!),
  //       child: Column(
  //         children: [
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               CircleAvatar(
  //                 radius: 30 * SizeConfig.heightMultiplier!,
  //                 backgroundImage: NetworkImage(widget.traineravatarUrl!),
  //               ),
  //               SizedBox(
  //                 width: 16 * SizeConfig.widthMultiplier!,
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     widget.trainerName!.tr,
  //                     style: AppTextStyle.boldBlackText
  //                         .copyWith(color: kBlack, letterSpacing: -0.08),
  //                   ),
  //                   SizedBox(
  //                     height: 8 * SizeConfig.heightMultiplier!,
  //                   ),
  //                   Row(
  //                     children: [
  //                       widget.isFollowing == true
  //                           ? CustomButtonPlanScreen(
  //                               colour: kgreen4F,
  //                               width: 102 * SizeConfig.widthMultiplier!,
  //                               height: 28 * SizeConfig.heightMultiplier!,
  //                               onpressed: () {},
  //                               Text: Text(
  //                                 'following'.tr,
  //                                 style: AppTextStyle.hboldWhiteText.copyWith(
  //                                   fontSize: (12) * SizeConfig.textMultiplier!,
  //                                 ),
  //                               ),
  //                             )
  //                           : CustomButtonPlanScreen(
  //                               colour: kgreen4F,
  //                               width: 102 * SizeConfig.widthMultiplier!,
  //                               height: 28 * SizeConfig.heightMultiplier!,
  //                               onpressed: widget.onfollowtrainer!,
  //                               Text: Text(
  //                                 'follow'.tr,
  //                                 style: AppTextStyle.hboldWhiteText.copyWith(
  //                                   fontSize: (12) * SizeConfig.textMultiplier!,
  //                                 ),
  //                               ),
  //                             ),
  //                       SizedBox(
  //                         width: 12 * SizeConfig.widthMultiplier!,
  //                       ),
  //                       CustomButtonPlanScreen(
  //                         colour: greyB7,
  //                         width: 102 * SizeConfig.widthMultiplier!,
  //                         height: 28 * SizeConfig.heightMultiplier!,
  //                         onpressed: widget.onmessagetrainer!,
  //                         Text: Text(
  //                           'message'.tr,
  //                           style: AppTextStyle.hboldWhiteText.copyWith(
  //                             fontSize: (12) * SizeConfig.textMultiplier!,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //           SizedBox(
  //             height: 24 * SizeConfig.heightMultiplier!,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   //following
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(widget.followerscount!.tr,
  //                           style: AppTextStyle.boldBlackText
  //                               .copyWith(color: kBlack, letterSpacing: -0.08)),
  //                       Text('follower'.tr,
  //                           style: AppTextStyle.smallBlackText
  //                               .copyWith(color: kBlack, letterSpacing: -0.08))
  //                     ],
  //                   ),
  //                   SizedBox(width: 25 * SizeConfig.widthMultiplier!),
  //                   //following
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(widget.followingcount!.tr,
  //                           style: AppTextStyle.boldBlackText
  //                               .copyWith(color: kBlack, letterSpacing: -0.08)),
  //                       Text('following'.tr,
  //                           style: AppTextStyle.smallBlackText.copyWith(
  //                             color: kBlack,
  //                             letterSpacing: -0.08,
  //                           ))
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               Container(
  //                 width: 1 * SizeConfig.widthMultiplier!,
  //                 height: 56 * SizeConfig.heightMultiplier!,
  //                 color: kDarkGrey,
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text(
  //                         widget.ratingCount!.tr,
  //                         style: AppTextStyle.greenSemiBoldText.copyWith(
  //                           color: kgreen4F,
  //                           letterSpacing: -0.08,
  //                         ),
  //                       ),
  //                       SizedBox(width: 8 * SizeConfig.widthMultiplier!),
  //                       StarRating(
  //                         rating: widget.rating!,
  //                       )
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Text(
  //                         widget.totalPeopleTrained!,
  //                         style: AppTextStyle.greenSemiBoldText.copyWith(
  //                           color: kPureBlack,
  //                           letterSpacing: -0.08,
  //                         ),
  //                       ),
  //                       SizedBox(width: 8 * SizeConfig.widthMultiplier!),
  //                       Text(
  //                         'people_trained'.tr,
  //                         style: AppTextStyle.smallBlackText.copyWith(
  //                             letterSpacing: -0.08, color: kPureBlack),
  //                       )
  //                     ],
  //                   ),
  //                   Text(
  //                     //extra text
  //                     'view_and_review'.tr,
  //                     style: AppTextStyle.smallBlackText.copyWith(
  //                         color: greyColor,
  //                         decoration: TextDecoration.underline),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     );

  //Widget review of plan
  Widget _BuildReviewofPlan() => Container(
        padding: EdgeInsets.only(
            left: 16 * SizeConfig.widthMultiplier!,
            right: 16 * SizeConfig.widthMultiplier!,
            top: 16 * SizeConfig.heightMultiplier!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'review_for_plan'.tr,
              style: AppTextStyle.hblack600Text
                  .copyWith(color: kBlack, letterSpacing: -0.08),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.totalreviewrating!.tr,
                  style: AppTextStyle.hblack600Text.copyWith(
                      fontSize: (36) * SizeConfig.textMultiplier!,
                      color: kBlack,
                      letterSpacing: -0.08),
                ),
                SizedBox(
                  width: 4 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  'plan_rating'.tr,
                  style: AppTextStyle.hblack400Text
                      .copyWith(color: kBlack, letterSpacing: -0.08),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 12 * SizeConfig.heightMultiplier!,
                  bottom: 12 * SizeConfig.heightMultiplier!),
              child: Row(
                children: [
                  Expanded(
                    child: LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: widget.value!,
                      backgroundColor: kLightGrey,
                      progressColor: hintGrey,
                      barRadius: Radius.circular(8),
                    ),
                  ),
                  SizedBox(
                    width: 16 * SizeConfig.widthMultiplier!,
                  ),
                  StarRating(
                    rating: (widget.value!) * 5,
                  ),
                  SizedBox(
                    width: 8 * SizeConfig.widthMultiplier!,
                  ),
                  //print value in percent
                  Text(
                    (widget.value! * 100).floor().toString() + '%',
                    style: AppTextStyle.hblack400Text.copyWith(color: hintGrey),
                  )
                ],
              ),
            ),

            SizedBox(height: 24 * SizeConfig.heightMultiplier!),
            //review
            Row(
              children: [
                CircleAvatar(
                  radius: 16 * SizeConfig.heightMultiplier!,
                  backgroundImage:
                      NetworkImage(widget.reviewPersonCircleavatar!),
                ),
                SizedBox(
                  width: 14 * SizeConfig.widthMultiplier!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reviewPersonName!.tr,
                      style: AppTextStyle.hnormal600BlackText
                          .copyWith(color: kBlack),
                    ),
                    Text(
                      widget.reviewPersonDetail!.tr,
                      style: AppTextStyle.hnormal600BlackText.copyWith(
                        color: hintGrey,
                        fontSize: (12) * SizeConfig.textMultiplier!,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                //review star
                Image.asset(
                  ImagePath.starrating_full,
                  width: 16 * SizeConfig.widthMultiplier!,
                  height: 16 * SizeConfig.heightMultiplier!,
                  //size: 16,
                  color: kgreen4F,
                ),
                SizedBox(
                  width: 4 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  widget.reviewStarcount!.tr,
                  style:
                      AppTextStyle.greenSemiBoldText.copyWith(color: kgreen49),
                )
              ],
            ),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            //review description
            Text(
              widget.reviewdiscription!.tr,
              style: AppTextStyle.hblack400Text.copyWith(color: kBlack),
            ),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            // review duration
            Text(
              widget.reviewdate!.tr,
              style: AppTextStyle.hnormal600BlackText.copyWith(
                color: hintGrey,
              ),
            ),
            SizedBox(
              height: 33 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      );
}
