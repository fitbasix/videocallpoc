import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Bmr_calculator/controller/bmr_controller.dart';
import 'package:fitbasix/feature/Bmr_calculator/services/bmr_services.dart';
import 'package:fitbasix/feature/Bmr_calculator/view/Appbar_forBmr.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

enum Gender { male, female }

class BMRHomeScreen extends StatefulWidget {
  const BMRHomeScreen({Key? key}) : super(key: key);

  @override
  _BMRHomeScreenState createState() => _BMRHomeScreenState();
}

class _BMRHomeScreenState extends State<BMRHomeScreen> {
  // default values for design purpose
  Gender selectedgender = Gender.male;
  int age = 1;
  double bodyweight = 45.0;
  double height = 180;
  final BmrController bmrController = Get.put(BmrController());
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppbarforBMRScreen(
        onRoute: () {
          _homeController.selectedIndex.value = 0;
        },
        title: 'bmr_calc'.tr,
        parentContext: context,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0 * SizeConfig.widthMultiplier!),
              child: Column(
                children: [
                  //age & bodyweight section
                  Row(
                    children: [
                      // Age
                      Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.all(8 * SizeConfig.widthMultiplier!),
                          height: 180 * SizeConfig.heightMultiplier!,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0,2),
                                blurRadius: 10,
                                spreadRadius: -2,
                                color: greyBorder
                              )
                            ],
                            border: Border.all(color: greyBorder),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // width: 156 * SizeConfig.widthMultiplier!,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 12 * SizeConfig.widthMultiplier!,
                                      top: 12 * SizeConfig.heightMultiplier!,
                                    ),
                                    child: Text(
                                      'age'.tr,
                                      style: AppTextStyle.hblack400Text
                                          .copyWith(
                                          color: Theme.of(context).textTheme.bodyText1?.color),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 37 * SizeConfig.heightMultiplier!,
                                ),
                                Row(
                                  children: [
                                    RoundIconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (age > 0) {
                                              age--;
                                            }
                                          });
                                        },
                                       // color: kPureWhite,
                                        child: Icon(
                                          Icons.remove_circle,
                                          color: hintGrey,
                                        )
                                    ),
                                    Spacer(),
                                    Text(
                                      '$age',
                                      style: AppTextStyle.hblackSemiBoldText
                                          .copyWith(
                                        color: Theme.of(context).textTheme.bodyText1?.color,
                                              fontSize: 32 *
                                                  SizeConfig.textMultiplier!),
                                    ),
                                    Spacer(),
                                    RoundIconButton(
                                        onPressed: () {
                                          setState(() {
                                            age++;
                                          });
                                        },
                                       // color: Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Theme.of(context).primaryColor,
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8 * SizeConfig.heightMultiplier!,
                                ),
                                Center(
                                  child: Text(
                                    'year'.tr,
                                    style: AppTextStyle.hsmallGreenText
                                        .copyWith(
                                      color: Theme.of(context).textTheme.bodyText1?.color,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      // body weight
                      Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.all(8 * SizeConfig.widthMultiplier!),

                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0,2),
                                  blurRadius: 10,
                                  spreadRadius: -2,
                                  color: greyBorder
                              )
                            ],
                            border: Border.all(color: greyBorder),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 180 * SizeConfig.heightMultiplier!,
                          // width: 156 * SizeConfig.widthMultiplier!,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 12 * SizeConfig.widthMultiplier!,
                                      top: 12 * SizeConfig.heightMultiplier!,
                                    ),
                                    child: Text(
                                      'body_weight'.tr,
                                      style: AppTextStyle.hblack400Text
                                          .copyWith(
                                          color: Theme.of(context).textTheme.bodyText1?.color
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 37 * SizeConfig.heightMultiplier!,
                                ),
                                Row(
                                  children: [
                                    RoundIconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (bodyweight > 0) {
                                              bodyweight--;
                                            }
                                          });
                                        },
                                     //   color: kPureWhite,
                                        child: Icon(
                                          Icons.remove_circle,
                                          color: hintGrey,
                                        )
                                    ),
                                    Spacer(),
                                    Text(
                                      bodyweight.toString(),
                                      style: AppTextStyle.hblackSemiBoldText
                                          .copyWith(
                                          color: Theme.of(context).textTheme.bodyText1?.color,
                                              fontSize: 32 *
                                                  SizeConfig.textMultiplier!),
                                    ),
                                    Spacer(),
                                    RoundIconButton(
                                        onPressed: () {
                                          setState(() {
                                            bodyweight++;
                                          });
                                        },
                                        //color: Colors.black,
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Theme.of(context).primaryColor,
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8 * SizeConfig.heightMultiplier!,
                                ),
                                Center(
                                  child: Text(
                                    'kg'.tr,
                                    style: AppTextStyle.hsmallGreenText
                                        .copyWith(
                                   color: Theme.of(context).textTheme.bodyText1?.color,
                                        ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                  //Height
                  Container(
                    margin: EdgeInsets.all(8 * SizeConfig.widthMultiplier!),
                    decoration: BoxDecoration(
                      border: Border.all(color: greyBorder),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,2),
                            blurRadius: 10,
                            spreadRadius: -2,
                            color: greyBorder
                        )
                      ],
                    ),
                    // height: 195 * SizeConfig.heightMultiplier!,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'height'.tr,
                                style: AppTextStyle.hblack400Text
                                    .copyWith(
                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'feet_inches'.tr,
                                style: AppTextStyle.hblack400Text
                                    .copyWith( color: Theme.of(context).textTheme.bodyText1?.color,),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            (height * 0.0328084).toString().split(".")[0] +
                                '.' +
                                (int.parse((height * 0.0328084)
                                            .toString()
                                            .substring(2, 4)) *
                                        0.12)
                                    .toString()
                                    .substring(0, 2)
                                    .replaceAll(".", ""),
                            style: AppTextStyle.hblackSemiBoldText.copyWith(
                                color: Theme.of(context).textTheme.bodyText1?.color,
                                fontSize: 32 * SizeConfig.textMultiplier!),
                          ),
                          SizedBox(
                            height: 39 * SizeConfig.heightMultiplier!,
                          ),
                          Slider(
                              activeColor: kgreen49,
                              inactiveColor: klightgreenEB.withOpacity(0.5),
                              thumbColor: kgreen49,
                              value: height.toDouble(),
                              min: 100,
                              max: 300,
                              onChanged: (double newValue) {
                                setState(() {
                                  height = newValue;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8 * SizeConfig.heightMultiplier!,
                  ),
                  //gender selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedgender = Gender.male;
                          });
                        },
                        child: Container(
                          height: 52 * SizeConfig.heightMultiplier!,
                          width: 164 * SizeConfig.widthMultiplier!,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedgender == Gender.male
                                    ? kgreen4F
                                    : greyBorder),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0,2),
                                  blurRadius: 10,
                                  spreadRadius: -2,
                                  color: greyBorder
                              )
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: selectedgender == Gender.male
                                ? kgreen4F
                                : kBlack,
                          ),
                          child: Center(
                            child: Text(
                              'male'.tr,
                              style: selectedgender == Gender.male
                                  ? AppTextStyle.normalBlackText
                                      .copyWith(color: kPureWhite)
                                  : AppTextStyle.normalBlackText.copyWith(
                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedgender = Gender.female;
                            });
                          },
                          child: Container(
                            height: 52 * SizeConfig.heightMultiplier!,
                            width: 164 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedgender == Gender.female
                                        ? kgreen4F
                                        : greyBorder),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                color: selectedgender == Gender.female
                                    ? kgreen4F
                                    : kBlack),
                            child: Center(
                              child: Text(
                                'female'.tr,
                                style: selectedgender == Gender.female
                                    ? AppTextStyle.normalBlackText
                                        .copyWith(color: kPureWhite)
                                    : AppTextStyle.normalBlackText.copyWith(
                                        color: Theme.of(context).textTheme.bodyText1?.color,
                                      ),
                              ),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
            // bottom bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    16 * SizeConfig.widthMultiplier!,
                    8 * SizeConfig.heightMultiplier!,
                    16 * SizeConfig.widthMultiplier!,
                    16 * SizeConfig.heightMultiplier!),
                height: 72 * SizeConfig.heightMultiplier!,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Container(
                  height: 48 * SizeConfig.heightMultiplier!,
                  width: 328 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                    //  color: kgreen4F,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(kgreen4F),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8 * SizeConfig.widthMultiplier!)))),
                    onPressed: () async {
                      // API Call
                      bmrController.bmrresult.value =
                          await BmrServices.getbmrCalculations(
                              bodyweight,
                              height,
                              age,
                              selectedgender == Gender.male ? 1 : 2);
                      Navigator.pushNamed(context, RouteName.bmrresultScreen);
                    },
                    child: Text(
                      "calcuale_bmr".tr,
                      style: AppTextStyle.hboldWhiteText,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// RounndIconButton
class RoundIconButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  RoundIconButton({this.color, this.child, this.onPressed});
  final Color? color;
  final Widget? child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: child,
      onPressed: onPressed,
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(width: 20.0, height: 20.0),
      shape: CircleBorder(),
      fillColor: color,
    );
  }
}
