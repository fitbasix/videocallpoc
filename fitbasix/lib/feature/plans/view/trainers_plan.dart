import 'dart:ui';

import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../get_trained/controller/trainer_controller.dart';
import '../../get_trained/model/PlanModel.dart';
import '../../get_trained/services/trainer_services.dart';
import '../../get_trained/view/widgets/star_rating.dart';

class TrainerPlansScreen extends StatelessWidget {
  TrainerPlansScreen({Key? key}) : super(key: key);
  @override
  // constant values for designing purpose
  // static const imageurl =
  //     "https://t4.ftcdn.net/jpg/04/41/05/23/360_F_441052304_xqszd9uBMcbW8dS3WD1JolMbztuF2KNx.jpg";
  // var planPrize = '\$120';
  // var peopleEnrolled = '234 ' + 'people_enrolled'.tr;
  // var planDuration = '12 '+'week_plan'.tr;
  // String ratingcount = '131';
  // void getPlan(TrainerController trainerController) async {
  //   trainerController.fullPlanInfoLoading.value = true;
  //   trainerController.fullPlanInfoLoading.value = false;
  // }

  Widget build(BuildContext context) {
    final TrainerController trainerController = Get.find();
    //getPlan(trainerController);
    List<Plan> plans = trainerController.isProfileLoading.value
        ? []
        : trainerController.planModel.value.response!.data!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7.41 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
              color: Theme.of(context).primaryColor,
            )),
        title:
            Text('select_plans_proceed'.tr, style: AppTextStyle.hblack600Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color)),
      ),
      ///remove ||plans.length==0 after testing
      body: plans.length != 0
          ? Padding(
        padding: EdgeInsets.only(top: 32*SizeConfig.heightMultiplier!),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  ///remove plans.length+2 after testing
                  children: List.generate(plans.length, (index) =>   BuildPlancard(
                  // planImage: plans[index].planIcon.toString(),
                  // planName: plans[index].planName.toString(),
                  // planPrize: 'AED ' + plans[index].prize.toString(),
                  // onPlanSelect: () async {
                  //   trainerController.selectedPlanId.value =
                  //       plans[index].id!;
                  //   Navigator.pushNamed(
                  //       context, RouteName.planInformationScreen);
                  // },
                  // peopleEnrolled: plans[index].trainees.toString() +
                  //     " " +
                  //     'people_enrolled'.tr,
                  // planDuration: plans[index].planDuration.toString() +
                  //     " " +
                  //     'week_plan'.tr,
                  // ratingCounts: plans[index].plansRating.toString(),
                  ///give the backend values here
                  context: context,
                  planImage: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&w=1000&q=80",
                  planName: plans[index].planName!,
                  planTitle: plans[index].planType!,
                  planDescription: plans[index].description!,
                  sessionCount: plans[index].session!,
                  planDuration: plans[index].planDuration!,
                      ////remove index==0 after testing
                  isDemoExpired:index==0&&!plans[index].isDemoAvailable!,
                  planPrice: plans[index].price!,
                  onPlanEnrollTapped: () async {
                    trainerController.weekAvailableSlots.value = [];
                    Navigator.pushNamed(context, RouteName.planTimingScreen);
                    trainerController.selectedPlan.value = plans[index];

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
                    trainerController.fullPlanDetails.value = await TrainerServices.getPlanById(plans[index].id!);

                    trainerController.availableSlots.value =
                        await TrainerServices.getEnrolledPlanDetails(plans[index].trainer!);
                    trainerController.isAvailableSlotDataLoading.value = false;

                  },
                  planFeaturesList:plans[index].keyPoints
              ),
               ))),
          )
          : SizedBox(),
    );
  }




  Widget BuildPlancard(
          {required String planImage,
            required String planTitle,
          required String planName,
            String? planDescription,
          required int planPrice,
            int? sessionCount,
            int? planDuration,
          required VoidCallback onPlanEnrollTapped,
          required BuildContext context,
            bool? isDemoExpired,
            List<String>? planFeaturesList
          }) =>
      Container(
        width: MediaQuery.of(context).size.width-40*SizeConfig.widthMultiplier!,
        padding: EdgeInsets.only(left: 16*SizeConfig.widthMultiplier!),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 16*SizeConfig.widthMultiplier!,vertical: 32*SizeConfig.heightMultiplier!),
          decoration: BoxDecoration(
            // image: DecorationImage(image: AssetImage(ImagePath.unselectedPlanBackgroundImage)),
            gradient: LinearGradient(colors: [
              isDemoExpired!?Color(0xff404040):Color(0xff333E33),
              isDemoExpired?Color(0xff111111):Color(0xff1C1E1C),
            ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight

            ),
              borderRadius: BorderRadius.all(Radius.circular(20*SizeConfig.widthMultiplier!))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planTitle,
                style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:36*SizeConfig.textMultiplier!,fontWeight: FontWeight.w600,color: Theme.of(context).textTheme.bodyText1!.color,height: 1),
              ),
              SizedBox(
                height: 32 * SizeConfig.heightMultiplier!,
              ),
              Text(
                planName,
                style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:24*SizeConfig.textMultiplier!,fontWeight: FontWeight.w600,color: Theme.of(context).textTheme.bodyText1!.color,height: 1),
              ),


              Text(
                planDescription!,
                style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:12*SizeConfig.textMultiplier!,fontWeight: FontWeight.w400,color: Theme.of(context).textTheme.headline6!.color,),
              ),

              SizedBox(
                height: 24 * SizeConfig.heightMultiplier!,
              ),

              Text(
                sessionCount!.toString() +" "+"session".tr,
                style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:24*SizeConfig.textMultiplier!,fontWeight: FontWeight.w600,color: Theme.of(context).textTheme.bodyText1!.color,height: 1),
              ),

              Text(
                "session_description".tr+" $planDuration "+"week".tr,
                style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:12*SizeConfig.textMultiplier!,fontWeight: FontWeight.w400,color: Theme.of(context).textTheme.headline6!.color,),
              ),

              SizedBox(
                height: 24 * SizeConfig.heightMultiplier!,
              ),


              Text(
                "AED "+planPrice.toString(),
                style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:36*SizeConfig.textMultiplier!,fontWeight: FontWeight.w600,color: Theme.of(context).textTheme.bodyText1!.color,),
              ),
              SizedBox(
                height: 24 * SizeConfig.heightMultiplier!,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: isDemoExpired?null:onPlanEnrollTapped,
                      child: Container(
                        width: 264*SizeConfig.widthMultiplier!,
                        height: 45 * SizeConfig.heightMultiplier!,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
                          color: isDemoExpired?hintGrey:kgreen49,
                        ),
                        child: Center(
                          child: Text(
                            isDemoExpired?"already_taken".tr:"enroll".tr,
                            style: AppTextStyle.normalWhiteText.copyWith(color: isDemoExpired?Color(0xff333333):kPureWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32*SizeConfig.heightMultiplier!,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(planFeaturesList!.length, (index) => Container(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15*SizeConfig.heightMultiplier!),
                    child: Row(
                      children: [
                        SvgPicture.asset(ImagePath.rightTickIcon,color:kgreen49,height: 15*SizeConfig.imageSizeMultiplier!,),
                        SizedBox(width: 11*SizeConfig.widthMultiplier!,),
                        Expanded(child: Text(planFeaturesList[index],style: AppTextStyle.hblackSemiBoldText.copyWith(fontSize:16*SizeConfig.textMultiplier!,fontWeight: FontWeight.w600,color: Theme.of(context).textTheme.bodyText1!.color,height: 1),))
                      ],
                    ),
                  ),
                )),
              ),
              SizedBox(
                height: 15 * SizeConfig.heightMultiplier!,
              ),


            ],
          ),
        ),
      );


}
