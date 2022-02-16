import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/feature/Bmr_calculator/view/Appbar_forBmr.dart';
import 'package:fitbasix/feature/Bmr_calculator/view/reusable_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/reponsive/SizeConfig.dart';

class BMRHomeScreen extends StatefulWidget {
  const BMRHomeScreen({Key? key}) : super(key: key);

  @override
  _BMRHomeScreenState createState() => _BMRHomeScreenState();
}

class _BMRHomeScreenState extends State<BMRHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyF6,
    appBar: AppbarforBMRScreen(
      title: 'BMR Calculator',
      parentContext: context,
    ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                //age & bodyweight section
                Row(
                  children: [
                    Reusablecard(
                      colour: kPureWhite,
                      cardwidget: Column(
                        children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Age',style: AppTextStyle.hblack400Text.copyWith(
                                color: kBlack
                              ),),
                            ),
                          SizedBox(
                            height: 37 * SizeConfig.heightMultiplier!,
                          )
                        ],
                      ),
                    ),
                    // body weight
                    Reusablecard(
                      colour: kPureWhite,
                      cardwidget: Column(
                        children: [

                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            // bottom bar
            Align(
              alignment:Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    16 * SizeConfig.widthMultiplier!,
                    8 * SizeConfig.heightMultiplier!,
                    16 * SizeConfig.widthMultiplier!,
                    16 * SizeConfig.heightMultiplier!),
                height: 72 * SizeConfig.heightMultiplier!,
                decoration: BoxDecoration(
                  color: kPureWhite,
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
                          backgroundColor:
                          MaterialStateProperty.all(kgreen4F),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8 * SizeConfig.widthMultiplier!)))),
                      onPressed: () {
                        // Calculate BMR button
                      },
                      child: Text(
                        "Calculate BMR".tr,
                        style: AppTextStyle.hboldWhiteText,
                      )),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
