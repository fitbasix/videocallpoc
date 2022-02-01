import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'dart:math';

class HealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

Widget WaterConsumed(double consumedWater, double totalWater) => Container(
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
            color: kPureWhite),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12.0 * SizeConfig.widthMultiplier!,
              vertical: 7 * SizeConfig.heightMultiplier!),
          child: Column(
            children: [
              SizedBox(
                height: 3 * SizeConfig.heightMultiplier!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'waterConsumed'.tr,
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                  ),
                  SvgPicture.asset(
                    ImagePath.water,
                    height: 20 * SizeConfig.heightMultiplier!,
                    width: 16 * SizeConfig.widthMultiplier!,
                  )
                ],
              ),
              SizedBox(
                height: 10 * SizeConfig.heightMultiplier!,
              ),
              CustomPaint(
                foregroundPainter: CirclePainter(consumedWater / totalWater),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          consumedWater.toStringAsFixed(1) + " ltr",
                          style: AppTextStyle.boldBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!),
                        ),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier!),
                        Text("of " + totalWater.toStringAsFixed(1) + " ltr",
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: hintGrey)),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    ImagePath.add,
                    height: 16 * SizeConfig.widthMultiplier!,
                    width: 16 * SizeConfig.widthMultiplier!,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );

Widget CaloryConsumption(
        String? totalCalory,
        String? carbsInGram,
        String? carbsInCal,
        String? proteinInGram,
        String? proteinCal,
        String? fatInGram,
        String? fatInCal) =>
    Container(
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
            color: kPureWhite),
        child: Column(
          children: [
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'caloryConsumption'.tr,
              style: AppTextStyle.normalBlackText
                  .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Text(totalCalory.toString(),
                style: AppTextStyle.boldBlackText
                    .copyWith(fontSize: 16 * SizeConfig.textMultiplier!)),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 25 * SizeConfig.textMultiplier!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        ImagePath.carbsIcon,
                        height: 40 * SizeConfig.widthMultiplier!,
                        width: 40 * SizeConfig.widthMultiplier!,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 8 * SizeConfig.widthMultiplier!,
                      ),
                      Text('carbs'.tr,
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(carbsInGram.toString(),
                          style: AppTextStyle.boldBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(carbsInCal.toString(),
                          style: AppTextStyle.normalBlackText.copyWith(
                              color: hintGrey,
                              fontSize: 14 * SizeConfig.textMultiplier!))
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        ImagePath.proteinIcon,
                        height: 40 * SizeConfig.widthMultiplier!,
                        width: 40 * SizeConfig.widthMultiplier!,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 8 * SizeConfig.widthMultiplier!,
                      ),
                      Text('protein'.tr,
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(proteinInGram.toString(),
                          style: AppTextStyle.boldBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(proteinCal.toString(),
                          style: AppTextStyle.normalBlackText.copyWith(
                              color: hintGrey,
                              fontSize: 14 * SizeConfig.textMultiplier!))
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        ImagePath.fatIcon,
                        height: 40 * SizeConfig.widthMultiplier!,
                        width: 40 * SizeConfig.widthMultiplier!,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 8 * SizeConfig.widthMultiplier!,
                      ),
                      Text('fat'.tr,
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(fatInGram.toString(),
                          style: AppTextStyle.boldBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(fatInCal.toString(),
                          style: AppTextStyle.normalBlackText.copyWith(
                              color: hintGrey,
                              fontSize: 14 * SizeConfig.textMultiplier!))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.widthMultiplier!,
            ),
          ],
        ),
      ),
    );

class CirclePainter extends CustomPainter {
  final strokeCircle = 7.0;
  double currentProgress;
  CirclePainter(this.currentProgress);
  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..color = Colors.blue.shade100
      ..strokeWidth = strokeCircle
      ..style = PaintingStyle.stroke;
    Offset center = Offset(size.width / 2, size.height / 2); // center of device
    double radius = 50;
    canvas.drawCircle(center, radius, circle);
    // Animation
    Paint animationArc = Paint()
      ..strokeWidth = strokeCircle
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double angle = (2 * (currentProgress / 100)) * pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget CaloriesBurnt(double burntCalories) => Container(
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
            color: kPureWhite),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12.0 * SizeConfig.widthMultiplier!,
              vertical: 7 * SizeConfig.heightMultiplier!),
          child: Column(
            children: [
              SizedBox(
                height: 3 * SizeConfig.heightMultiplier!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'caloriesBurnt'.tr,
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                  ),
                  SvgPicture.asset(
                    ImagePath.fire,
                    height: 20 * SizeConfig.heightMultiplier!,
                    width: 16 * SizeConfig.widthMultiplier!,
                  )
                ],
              ),
              SizedBox(
                height: 10 * SizeConfig.heightMultiplier!,
              ),
              CustomPaint(
                foregroundPainter: CirclePainter(0.0),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          burntCalories.toString() + " kcal",
                          style: AppTextStyle.boldBlackText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    ImagePath.power,
                    height: 16 * SizeConfig.widthMultiplier!,
                    width: 16 * SizeConfig.widthMultiplier!,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
