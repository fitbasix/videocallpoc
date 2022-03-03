import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'dart:math';

import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../controller/Home_Controller.dart';

class HealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

Widget WaterConsumed(double consumedWater, double totalWater,
        VoidCallback onAddWater, HomeController homeController) =>
    Container(
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
                  Image.asset(
                    ImagePath.dropIcon,
                    height: 22 * SizeConfig.heightMultiplier!,
                    width: 17 * SizeConfig.widthMultiplier!,
                  )
                ],
              ),
              SizedBox(
                height: 31.5 * SizeConfig.heightMultiplier!,
              ),
              SizedBox(
                width: 30.5 * SizeConfig.widthMultiplier!,
                height: 61 * SizeConfig.heightMultiplier!,
                //padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: LiquidLinearProgressIndicator(
                  value: homeController.waterLevel.value, // Defaults to 0.5.
                  valueColor: const AlwaysStoppedAnimation(Colors
                      .lightBlue), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.grey
                      .shade200, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.blueAccent.shade100,
                  borderWidth: 0,
                  borderRadius: 30.0,
                  direction: Axis
                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                ),
              ),
              // CustomPaint(
              //   foregroundPainter: CirclePainter(
              //       (consumedWater / totalWater) * 100, Colors.blue),
              //   child: Container(
              //     width: 120,
              //     height: 120,
              //     color: Colors.white,
              //     child: Center(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             consumedWater.toStringAsFixed(1) + " ltr",
              //             style: AppTextStyle.boldBlackText.copyWith(
              //                 fontSize: 14 * SizeConfig.textMultiplier!),
              //           ),
              //           SizedBox(height: 2 * SizeConfig.heightMultiplier!),
              //           Text("of " + totalWater.toStringAsFixed(1) + " ltr",
              //               style: AppTextStyle.normalBlackText.copyWith(
              //                   fontSize: 12 * SizeConfig.textMultiplier!,
              //                   color: hintGrey)),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 32.5 * SizeConfig.heightMultiplier!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    consumedWater.toStringAsFixed(1) + " ltr",
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                  ),
                  SizedBox(width: 2 * SizeConfig.widthMultiplier!),
                  Text("of " + totalWater.toStringAsFixed(1) + " ltr",
                      style: AppTextStyle.normalBlackText.copyWith(
                          fontSize: 12 * SizeConfig.textMultiplier!,
                          color: hintGrey)),
                  Spacer(),
                  GestureDetector(
                    onTap: onAddWater,
                    child: Container(
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        ImagePath.add,
                        height: 16 * SizeConfig.widthMultiplier!,
                        width: 16 * SizeConfig.widthMultiplier!,
                      ),
                    ),
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
  Color color;
  CirclePainter(this.currentProgress, this.color);
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
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double angle = (2 * (currentProgress / 100)) * pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget CaloriesBurnt(double burntCalories, VoidCallback onTap,bool isConnected) => Container(
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
                  Image.asset(
                    ImagePath.fireIcon,
                    height: 20 * SizeConfig.heightMultiplier!,
                    width: 16 * SizeConfig.widthMultiplier!,
                  )
                ],
              ),
              SizedBox(
                height: 12 * SizeConfig.heightMultiplier!,
              ),
              Container(
                height: 100* SizeConfig.heightMultiplier!,
                width: 160* SizeConfig.widthMultiplier!,
                child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  //animationDuration: 1000,
                  axes: [
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 0,
                      interval: 10,
                      canScaleToFit: true,
                      showTicks: false,
                      showLabels: false,
                      axisLineStyle: AxisLineStyle(
                          //  color: kPureWhite,
                          thickness: 6.0 * SizeConfig.widthMultiplier!,
                          thicknessUnit: GaugeSizeUnit.logicalPixel),
                      // pointer marker & needle pointer
                      pointers: [
                        RangePointer(
                            value: isConnected?burntCalories:100,
                            color: isConnected?kgreen49:Color(0xffFF5A5A),
                            width: 6 * SizeConfig.widthMultiplier!,
                            sizeUnit: GaugeSizeUnit.logicalPixel),
                        NeedlePointer(
                            value: isConnected?burntCalories:0,
                            needleLength: 48,
                            lengthUnit: GaugeSizeUnit.logicalPixel,
                            needleColor: kgreen49,
                            needleStartWidth: 0.5 * SizeConfig.widthMultiplier!,
                            needleEndWidth: 4 * SizeConfig.widthMultiplier!,
                            knobStyle: KnobStyle(
                                knobRadius: 3 * SizeConfig.widthMultiplier!,
                                sizeUnit: GaugeSizeUnit.logicalPixel,
                                borderColor: kgreen49,
                                borderWidth: 2 * SizeConfig.widthMultiplier!,
                                color: kPureWhite)
                            )
                      ],
                    ),
                  ],
                ),
              ),
              // CustomPaint(
              //   foregroundPainter: CirclePainter(100.0, lightGrey),
              //   child: Container(
              //     width: 120,
              //     height: 120,
              //     color: Colors.white,
              //     child: Center(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             burntCalories.toString() + " kcal",
              //             style: AppTextStyle.boldBlackText.copyWith(
              //                 fontSize: 14 * SizeConfig.textMultiplier!),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 13 * SizeConfig.heightMultiplier!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isConnected?Text(
                    burntCalories.toString() + " kcal",
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                  )
                      :Text('Not Connected',
                  style: AppTextStyle.hmediumBlackText,),
                  Spacer(),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        ImagePath.power,
                        height: 16 * SizeConfig.widthMultiplier!,
                        width: 16 * SizeConfig.widthMultiplier!,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
