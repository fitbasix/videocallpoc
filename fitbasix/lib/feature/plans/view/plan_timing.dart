import 'dart:ui';

import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/plans/view/plan_info.dart';
import 'package:fitbasix/feature/plans/view/trainers_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../get_trained/controller/trainer_controller.dart';

class PlanTimingUI extends StatefulWidget {
  PlanTimingUI({Key? key}) : super(key: key);

  @override
  State<PlanTimingUI> createState() => _PlanTimingUIState();
}

class _PlanTimingUIState extends State<PlanTimingUI> {
  final TrainerController trainerController = Get.find();
  var imageurl =
      "https://s3-alpha-sig.figma.com/img/a2f9/9007/54ca7015b64810f8e3185115236ee597?Expires=1646611200&Signature=GnAVttQd8W9Gbw72FGeDEuRqcIwRIv7TzsltIw9CpqBZKHnqC5WcG4dQ6j168SFz0sl6lHk2qlzE1TrFdZIIcmc~ue0wIEy2lvghS86Kr7xQpTRqbF0fakP-El-nUTxcg~X2kQm8kKtgPgFW3qmlWlPAMKlgHQO62TzPY8sngV5GEP4fFjjHfLHC~f-3kUUX-jPPU62t79Zb7svcWbBUKjh0zP-bzpv1j1tjbHayvqzH~PJRDBlJwdclSzkAoguX~bMeyFelgsApFhl~saCTFb~~YY1gKzIPFaG94ft3fTYcKtLLeCiYq-JpyFFX-UrLfrz3lMjIbgGrfSdMQMGuWg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA";
  bool isButtonActive = false;
  bool isDaySelected = false;
  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        title: Text('plan_timings'.tr, style: AppTextStyle.hblack600Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Obx(
          () => trainerController.isAvailableSlotDataLoading.value
              ? Center(child: CustomizedCircularProgress())
              : Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120 * SizeConfig.heightMultiplier!,
                        child: Image.network(
                          trainerController
                              .fullPlanDetails.value.response!.data!.planIcon
                              .toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // SizedBox(
                      //   height: 32*SizeConfig.heightMultiplier!,
                      // ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 32 * SizeConfig.heightMultiplier!,
                          horizontal: 16 * SizeConfig.widthMultiplier!,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trainerController.selectedPlan.value.planName.toString(),
                              style: AppTextStyle.hnormal600BlackText.copyWith(
                                fontSize: (24) * SizeConfig.textMultiplier!,
                                color: Theme.of(context).textTheme.bodyText1!.color
                              ),
                            ),
                            SizedBox(
                              height: 8 * SizeConfig.heightMultiplier!,
                            ),
                            // Text(
                            //     trainerController.fullPlanDetails.value
                            //             .response!.data!.planName
                            //             .toString() +
                            //         " by " +
                            //         trainerController.fullPlanDetails.value
                            //             .response!.data!.trainer!.name
                            //             .toString(),
                            //     style: AppTextStyle.hblack400Text),
                            SizedBox(
                              height: 32 * SizeConfig.heightMultiplier!,
                            ),
                            Text('plan_pricing'.tr,
                                style: AppTextStyle.hblackSemiBoldText
                                    .copyWith(letterSpacing: -0.08,color: Theme.of(context).textTheme.bodyText1!.color,height: 1)),
                            SizedBox(
                              height: 12 * SizeConfig.heightMultiplier!,
                            ),
                            Text(
                              'AED ' +
                                  trainerController.fullPlanDetails.value
                                      .response!.data!.price
                                      .toString(),
                              style: AppTextStyle.hblackSemiBoldText.copyWith(
                                  fontSize: (24) * SizeConfig.textMultiplier!,
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  height: 1,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              height: 32 * SizeConfig.heightMultiplier!,
                            ),

                            //select week
                            Text('select_week'.tr,
                                style: AppTextStyle.hblackSemiBoldText
                                    .copyWith(letterSpacing: -0.08,color: Theme.of(context).textTheme.bodyText1!.color)),
                            SizedBox(
                              height: 12 * SizeConfig.heightMultiplier!,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16 * SizeConfig.heightMultiplier!,),
                                child: Text(
                                    DateFormat("dd MMM").format(
                                            trainerController
                                                .availableSlots
                                                .value
                                                .response!
                                                .data![0]
                                                .date!) +
                                        " to " +
                                        DateFormat("dd MMM").format(
                                            trainerController
                                                .availableSlots
                                                .value
                                                .response!
                                                .data![trainerController
                                                        .availableSlots
                                                        .value
                                                        .response!
                                                        .data!
                                                        .length -
                                                    1]
                                                .date!),
                                    style: AppTextStyle.normalBlackText
                                        .copyWith(
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                            letterSpacing: -0.08,
                                           )),
                              ),
                            ),
                            SizedBox(
                              height: 32 * SizeConfig.heightMultiplier!,
                            ),

                            //select timeslot
                            Text('select_timeslot'.tr,
                                style: AppTextStyle.hblackSemiBoldText
                                    .copyWith(letterSpacing: -0.08,color: Theme.of(context).textTheme.bodyText1!.color)),
                            SizedBox(
                              height: 12 * SizeConfig.heightMultiplier!,
                            ),
                            //grid view of time slot
                            Obx(
                              () {
                                print(trainerController
                                    .availableSlots.value.response!.data!
                                    .where((element) =>
                                element.date ==
                                    trainerController.availableSlots.value
                                        .response!.data![0].date)
                                    .length.toString() +" nnnnn");
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: trainerController
                                      .availableSlots.value.response!.data!
                                      .where((element) =>
                                          element.date ==
                                          trainerController.availableSlots.value
                                              .response!.data![0].date)
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing:
                                              8 * SizeConfig.widthMultiplier!,
                                          mainAxisSpacing:
                                              8 * SizeConfig.heightMultiplier!,
                                          mainAxisExtent: 46 *
                                              SizeConfig.heightMultiplier!),
                                  itemBuilder: (context, index) => Obx(
                                        () => TimeSLotSelect(
                                          istimeSlotSelected: trainerController
                                                      .TimeSlotSelected.value ==
                                                  trainerController
                                                      .getAllSlots[
                                                          trainerController
                                                              .availableSlots
                                                              .value
                                                              .response!
                                                              .data![index]
                                                              .time!]
                                                      .serialId
                                              ? true
                                              : false,
                                          isDisabled: false.obs,
                                          onTap: () async {
                                            trainerController.selectedTimeSlot.value = index;
                                            trainerController
                                                    .TimeSlotSelected.value =
                                                trainerController
                                                    .getAllSlots[
                                                        trainerController
                                                            .availableSlots
                                                            .value
                                                            .response!
                                                            .data![index]
                                                            .time!]
                                                    .serialId!;
                                            trainerController
                                                .weekAvailableSlots.value = [];
                                            trainerController
                                                .selectedDays.value = [];
                                            var output = await TrainerServices
                                                .getAllWeekDays(
                                                trainerController.atrainerDetail.value.user!.id!,
                                                    trainerController
                                                        .TimeSlotSelected
                                                        .value);
                                            trainerController.weekAvailableSlots
                                                .value = output.response!.data!;
                                            // isTimeSlotSelected
                                          },
                                          time: trainerController
                                              .getAllSlots[trainerController
                                                  .availableSlots
                                                  .value
                                                  .response!
                                                  .data![index]
                                                  .time!]
                                              .name,
                                        ),
                                      ));}
                            ),
                            // select days
                            SizedBox(
                              height: 32 * SizeConfig.heightMultiplier!,
                            ),
                            Obx(
                                ()=> trainerController
                                    .weekAvailableSlots.length ==
                                    0? Container():Text('select_days'.tr,
                                  style: AppTextStyle.hblackSemiBoldText
                                      .copyWith(letterSpacing: -0.08,color: Theme.of(context).textTheme.bodyText1!.color)),
                            ),
                            SizedBox(
                              height: 12 * SizeConfig.heightMultiplier!,
                            ),
                            Obx(
                              () => trainerController
                                          .weekAvailableSlots.length ==
                                      0
                                  ? Container()
                                  : Container(
                                      height: 46 * SizeConfig.heightMultiplier!,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: List.generate(trainerController
                                            .weekAvailableSlots.length, (index){
                               
                                          return GestureDetector(
                                          onTap: () {
                                            if(trainerController.weekAvailableSlots[index].isAvailable != 0 && trainerController.weekAvailableSlots[index].isAvailable != 3){
                                              if (trainerController.selectedDays.indexOf(trainerController.weekAvailableSlots[index]
                                                  .id!) !=
                                                  -1) {
                                                trainerController.selectedDays
                                                    .remove(trainerController
                                                    .weekAvailableSlots[
                                                index]
                                                    .id!);
                                              } else {
                                                trainerController.selectedDays
                                                    .add(trainerController
                                                    .weekAvailableSlots[
                                                index]
                                                    .id!);
                                              }

                                              setState(() {});
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: (trainerController.weekAvailableSlots[index].isAvailable != 0 && trainerController.weekAvailableSlots[index].isAvailable != 3)?Border.all(
                                                  color: trainerController
                                                      .selectedDays
                                                      .indexOf(trainerController
                                                      .weekAvailableSlots[
                                                  index].id!) !=
                                                      -1
                                                      ? kgreen49
                                                      : kLightGrey,
                                                  width: trainerController
                                                      .selectedDays
                                                      .indexOf(trainerController
                                                      .weekAvailableSlots[
                                                  index]
                                                      .id!) !=
                                                      -1
                                                      ? 1.5 *
                                                      SizeConfig
                                                          .widthMultiplier!
                                                      : 1 *
                                                      SizeConfig
                                                          .widthMultiplier!
                                              ):Border.all(color: Colors.transparent),
                                              color: (trainerController.weekAvailableSlots[index].isAvailable != 0 && trainerController.weekAvailableSlots[index].isAvailable != 3)?Colors.transparent:kBlack,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            width: 40 *
                                                SizeConfig.widthMultiplier!,
                                            height: 46 *
                                                SizeConfig
                                                    .heightMultiplier!,
                                            child: Center(
                                              child: Text(
                                                DateFormat("EEE")
                                                    .format(trainerController
                                                    .weekAvailableSlots[
                                                index]
                                                    .date!)
                                                    .toString(),
                                                style: trainerController
                                                    .selectedDays
                                                    .indexOf(trainerController
                                                    .weekAvailableSlots[
                                                index]
                                                    .id!) !=
                                                    -1
                                                    ? AppTextStyle
                                                    .hblackSemiBoldText
                                                    .copyWith(
                                                    color: kgreen49)
                                                    : AppTextStyle
                                                    .hblack400Text
                                                    .copyWith(
                                                    color: greyB7),
                                              ),
                                            ),
                                          ),
                                        );}),
                                      )
                                    ),
                            ),

                            SizedBox(
                              height: 32 * SizeConfig.heightMultiplier!,
                            ),
                            //book Session button
                            Obx(
                              () => Padding(
                                padding: EdgeInsets.only(
                                  left: 8 * SizeConfig.widthMultiplier!,
                                  right: 8 * SizeConfig.widthMultiplier!,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        trainerController.selectedDays.length !=
                                                    0 &&
                                                (trainerController.selectedDays
                                                            .length ==
                                                        3)
                                            ? kgreen4F
                                            : hintGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: double.infinity *
                                      SizeConfig.widthMultiplier!,
                                  height: 48 * SizeConfig.heightMultiplier!,
                                  child: TextButton(
                                    onPressed: () async {
                                      if (trainerController
                                                  .selectedDays.length !=
                                              0 &&
                                          (trainerController
                                                      .selectedDays.length %
                                                  3 ==
                                              0)) {
                                        List<int> selectedDays = [];
                                        trainerController.selectedDays.forEach((days) {
                                          selectedDays.add(trainerController.weekAvailableSlots[trainerController.weekAvailableSlots.indexWhere((element) => element.id ==days)].day!);
                                        });

                                       await TrainerServices.bookSlot(
                                         trainerController.selectedDays,
                                          trainerController.selectedPlan.value.id!,
                                           trainerController
                                               .availableSlots
                                               .value
                                               .response!
                                               .data![trainerController.selectedTimeSlot.value].time!,
                                         selectedDays
                                       ).then((value){
                                         showDialogForSessionBooked(context);
                                         Future.delayed(Duration(seconds: 3),(){
                                           Navigator.pop(context);
                                           Navigator.pop(context);
                                           Navigator.pop(context);
                                         });
                                       });

                                        // Navigator.pop(context);
                                        // Navigator.pop(context);
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             TrainerPlansScreen()),
                                        //  (route) => false);
                                      }
                                    },
                                    child: Text('Book Session'.tr,
                                        style: isDaySelected
                                            ? AppTextStyle.hboldWhiteText
                                            : AppTextStyle.hboldWhiteText
                                                .copyWith(color: Theme.of(context).textTheme.bodyText1!.color)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      )),
    );
  }

    void showDialogForSessionBooked(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Container(
            color: kBlack.withOpacity(0.6),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10*SizeConfig.widthMultiplier!),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8*SizeConfig.imageSizeMultiplier!)
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  content: Stack(
                    children: [
                      SizedBox(
                        height: 330*SizeConfig.heightMultiplier!,
                        width: 250*SizeConfig.widthMultiplier!,
                        child: Image.asset(ImagePath.animatedCongratulationIcon,fit: BoxFit.cover,),),
                      Container(
                        height: 330*SizeConfig.heightMultiplier!,
                        width: 250*SizeConfig.widthMultiplier!,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 42*SizeConfig.heightMultiplier!,
                                width: 42*SizeConfig.widthMultiplier!,
                                child: SvgPicture.asset(ImagePath.greenRightTick),),
                              SizedBox(height: 8*SizeConfig.heightMultiplier!,),
                              Text("congratulations".tr,style: AppTextStyle.black400Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color,fontSize: 24*SizeConfig.textMultiplier!,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                              SizedBox(height: 8*SizeConfig.heightMultiplier!,),
                              Text("plan_booked_text".tr,style: AppTextStyle.black400Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),
          ),
        );



      },
    );
  }
}

class TimeSLotSelect extends StatelessWidget {
  TimeSLotSelect(
      {this.isDisabled,
      this.time,
      required this.istimeSlotSelected,
      required this.onTap,
      Key? key})
      : super(key: key);
  String? time;
  bool istimeSlotSelected;
  int? status;
  RxBool? isDisabled = true.obs;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: istimeSlotSelected ? kgreen49 : greyBorder,
                width: 1 * SizeConfig.widthMultiplier!),
            color: !isDisabled!.value
                ? istimeSlotSelected
                    ? kgreen49
                    : Colors.transparent
                : kLightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 104 * SizeConfig.widthMultiplier!,
          height: 46 * SizeConfig.heightMultiplier!,
          child: Center(
            child: Text(
              time.toString(),
              style: !isDisabled!.value
                  ? istimeSlotSelected
                      ? AppTextStyle.hnormal600BlackText
                          .copyWith(color: Theme.of(context).textTheme.bodyText1!.color)
                      : AppTextStyle.hblack400Text.copyWith( color: Theme.of(context).textTheme.bodyText1!.color)
                  : AppTextStyle.black400Text.copyWith(color: hintGrey),
            ),
          ),
        ),
      ),
    );
  }
}
