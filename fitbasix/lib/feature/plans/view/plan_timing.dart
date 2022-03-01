import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class PlanTimingUI extends StatefulWidget {
  PlanTimingUI({Key? key}) : super(key: key);

  @override
  State<PlanTimingUI> createState() => _PlanTimingUIState();
}

class _PlanTimingUIState extends State<PlanTimingUI> {
  var imageurl =
      "https://s3-alpha-sig.figma.com/img/a2f9/9007/54ca7015b64810f8e3185115236ee597?Expires=1646611200&Signature=GnAVttQd8W9Gbw72FGeDEuRqcIwRIv7TzsltIw9CpqBZKHnqC5WcG4dQ6j168SFz0sl6lHk2qlzE1TrFdZIIcmc~ue0wIEy2lvghS86Kr7xQpTRqbF0fakP-El-nUTxcg~X2kQm8kKtgPgFW3qmlWlPAMKlgHQO62TzPY8sngV5GEP4fFjjHfLHC~f-3kUUX-jPPU62t79Zb7svcWbBUKjh0zP-bzpv1j1tjbHayvqzH~PJRDBlJwdclSzkAoguX~bMeyFelgsApFhl~saCTFb~~YY1gKzIPFaG94ft3fTYcKtLLeCiYq-JpyFFX-UrLfrz3lMjIbgGrfSdMQMGuWg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA";
  bool isButtonActive = false;
  bool isDaySelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            ImagePath.backIcon,
            width: 7.41 * SizeConfig.widthMultiplier!,
            height: 12 * SizeConfig.heightMultiplier!,
          ),
        ),
        title: Text('plan_timings'.tr, style: AppTextStyle.hblack600Text),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 120 * SizeConfig.heightMultiplier!,
                child: Image.network(
                  imageurl,
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
                      'week_free_demo'.tr,
                      style: AppTextStyle.hnormal600BlackText.copyWith(
                        fontSize: (24) * SizeConfig.textMultiplier!,
                      ),
                    ),
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier!,
                    ),
                    Text('loose_fat_buildmuscle_by '+'Jonathan Swift',
                        style: AppTextStyle.hblack400Text),
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    ),
                    Text('plan_pricing'.tr,
                        style: AppTextStyle.hblackSemiBoldText
                            .copyWith(letterSpacing: -0.08)),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      '\$0',
                      style: AppTextStyle.hblackSemiBoldText.copyWith(
                          fontSize: (24) * SizeConfig.textMultiplier!,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    ),

                    //select week
                    Text('select_week'.tr,
                        style: AppTextStyle.hblackSemiBoldText
                            .copyWith(letterSpacing: -0.08)),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16 * SizeConfig.heightMultiplier!,
                          horizontal: 54 * SizeConfig.widthMultiplier!),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              ImagePath.backIcon,
                              width: 7.41 * SizeConfig.widthMultiplier!,
                              height: 12 * SizeConfig.heightMultiplier!,
                            ),
                          ),
                          SizedBox(
                            width: 32 * SizeConfig.widthMultiplier!,
                          ),
                          //week dates
                          Text('14 Feb to 20 Feb'.tr,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  letterSpacing: -0.08, color: kBlack)),
                          SizedBox(
                            width: 32 * SizeConfig.widthMultiplier!,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              ImagePath.reverseBackIcon,
                              width: 7.41 * SizeConfig.widthMultiplier!,
                              height: 12 * SizeConfig.heightMultiplier!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    ),

                    //select timeslot
                    Text('select_timeslot'.tr,
                        style: AppTextStyle.hblackSemiBoldText
                            .copyWith(letterSpacing: -0.08)),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    //grid view of time slot
                    GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 9,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8 * SizeConfig.widthMultiplier!,
                          mainAxisSpacing: 8 * SizeConfig.heightMultiplier!,
                          mainAxisExtent: 46 * SizeConfig.heightMultiplier!),
                      itemBuilder: (context, index) =>TimeSLotSelect(
                        isDisabled: true.obs,
                      )
                    ),
                    // select days
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    ),
                    Text('select_days'.tr,
                        style: AppTextStyle.hblackSemiBoldText
                            .copyWith(letterSpacing: -0.08)),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDaySelected = !isDaySelected;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isDaySelected ? kgreen49 : kLightGrey,
                              width: isDaySelected
                                  ? 1.5 * SizeConfig.widthMultiplier!
                                  : 1 * SizeConfig.widthMultiplier!),
                          color: kPureWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 40 * SizeConfig.widthMultiplier!,
                        height: 46 * SizeConfig.heightMultiplier!,
                        child: Center(
                          child: Text(
                            'Mon'.tr,
                            style: isDaySelected
                                ? AppTextStyle.hblackSemiBoldText
                                    .copyWith(color: kgreen49)
                                : AppTextStyle.hblack400Text
                                    .copyWith(color: greyB7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    ),
                    //book Session button
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8 * SizeConfig.widthMultiplier!,
                        right: 8 * SizeConfig.widthMultiplier!,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDaySelected ? kgreen4F : kLightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity * SizeConfig.widthMultiplier!,
                        height: 48 * SizeConfig.heightMultiplier!,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Book Session'.tr,
                              style: isDaySelected
                                  ? AppTextStyle.hboldWhiteText
                                  : AppTextStyle.hboldWhiteText
                                      .copyWith(color: greyB7)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}


class   TimeSLotSelect extends StatelessWidget {
   TimeSLotSelect(
       { this.isDisabled,Key? key}) : super(key: key);

  var istimeSlotSelected = false.obs;
  RxBool? isDisabled = true.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isDisabled!.value?() {
        istimeSlotSelected.value = !istimeSlotSelected.value;
      }:null,
      child: Obx(()=>
         Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: istimeSlotSelected.value ? kgreen49 : kLightGrey,
                width: 1 * SizeConfig.widthMultiplier!),
            color: !isDisabled!.value?
            istimeSlotSelected.value ? kgreen49 : kPureWhite
                :kLightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 104 * SizeConfig.widthMultiplier!,
          height: 46 * SizeConfig.heightMultiplier!,
          child: Center(
            child: Text(
              '9 -11 AM',
              style: !isDisabled!.value
                  ?istimeSlotSelected.value
                  ?AppTextStyle.hnormal600BlackText.copyWith(
                  color: kPureWhite
              ) :AppTextStyle.hblack400Text
                  .copyWith(color: kBlack)
              :AppTextStyle.black400Text.copyWith(
                color: hintGrey
              ),
            ),
          ),
        ),
      ),
    );
  }
}
