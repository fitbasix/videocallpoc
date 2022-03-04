import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../controller/bmr_controller.dart';
import '../model/bmr_calculation_model.dart';
import 'Appbar_forBmr.dart';

class BMRResultScreen extends StatefulWidget {
  const BMRResultScreen({Key? key}) : super(key: key);

  @override
  State<BMRResultScreen> createState() => _BMRResultScreenState();
}

class _BMRResultScreenState extends State<BMRResultScreen> {
  // var bmrresult = '1346';
  bool isReadmore = false;
  // final BmrController bmrController = Get.find(BmrController());
  final BmrController bmrcontroller = Get.put(BmrController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyF6,
      appBar: AppbarforBMRScreen(
        title: 'bmr_calc'.tr,
        parentContext: context,
        onRoute: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
          child: AnimatedContainer(
        // height: !isReadmore
        //  ? 191 * SizeConfig.heightMultiplier!
        //  : 515 * SizeConfig.heightMultiplier!,
        duration: Duration(milliseconds: 0),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(16 * SizeConfig.widthMultiplier!),
              //  height: 191 * SizeConfig.heightMultiplier!,
              //  padding: EdgeInsets.all(16*SizeConfig.widthMultiplier!),
              //  height: 300 * SizeConfig.heightMultiplier!,
              decoration: BoxDecoration(
                color: kPureWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24 * SizeConfig.widthMultiplier!,
                      right: 24 * SizeConfig.widthMultiplier!,
                      top: 16 * SizeConfig.heightMultiplier!,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'your_bmr'.tr,
                              style: AppTextStyle.hblackSemiBoldText,
                            ),
                            SizedBox(
                              height: 16 * SizeConfig.heightMultiplier!,
                            ),
                            // result
                            Text(
                              NumberFormat("#,###").format(double.parse(
                                  bmrcontroller
                                      .bmrresult.value.response!.data!.bmr
                                      .toString())),
                              style: AppTextStyle.hblackSemiBoldText.copyWith(
                                fontSize: 32 * SizeConfig.textMultiplier!,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 6 * SizeConfig.heightMultiplier!,
                            ),
                            Text(
                              'calories_day'.tr,
                              style: AppTextStyle.hblack400Text,
                            )
                          ],
                        ),
                        Spacer(),
                        SvgPicture.asset(ImagePath.bmrinfoImage,
                            height: 100 * SizeConfig.heightMultiplier!),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24 * SizeConfig.heightMultiplier!,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16 * SizeConfig.widthMultiplier!,
                      right: 16 * SizeConfig.widthMultiplier!,
                    ),
                    child: Container(
                      height: 1 * SizeConfig.heightMultiplier!,
                      color: greyF6,
                    ),
                  ),
                  isReadmore
                      ? buildText(
                          bmrcontroller.bmrresult.value.response!.data!.data!)
                      : Container(),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isReadmore = !isReadmore;
                          });
                        },
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(kPureWhite),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        0 * SizeConfig.widthMultiplier!)))),
                        child: Text(
                          (isReadmore ? 'view_less'.tr : 'view_more'.tr),
                          style: AppTextStyle.hmediumBlackText,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget buildText(List<BmrResult> calories) {
    return Padding(
      padding: EdgeInsets.only(
        //  top: 24*SizeConfig.heightMultiplier!,
        left: 16 * SizeConfig.widthMultiplier!,
        right: 16 * SizeConfig.widthMultiplier!,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 24 * SizeConfig.heightMultiplier!,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'bmr_moresummary'.tr,
              style: AppTextStyle.hnormal600BlackText,
              // maxLines: lines,
            ),
          ),
          ListView.builder(
              itemCount: calories.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 16 * SizeConfig.heightMultiplier!,
                    // bottom: 16*SizeConfig.heightMultiplier!,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 168 * SizeConfig.widthMultiplier!,
                        child: Text(
                          calories[index].name.toString(),
                          style: AppTextStyle.black400Text,
                        ),
                      ),
                      Text(
                        calories[index].value!.toInt().toString(),
                        style: AppTextStyle.hnormal600BlackText,
                      )
                    ],
                  ),
                );
              }),
          SizedBox(
            height: 24 * SizeConfig.heightMultiplier!,
          ),
          Padding(
              padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!,
              ),
              child: Container(
                height: 1 * SizeConfig.heightMultiplier!,
                color: greyF6,
              )),
        ],
      ),
    );
  }
}
