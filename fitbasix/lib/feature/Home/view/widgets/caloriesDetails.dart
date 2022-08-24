import 'dart:io';

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

Widget WaterConsumed(
        double consumedWater,
        double totalWater,
        VoidCallback onAddWater,
        HomeController homeController,
        BuildContext context) =>
    GestureDetector(
      onTap: onAddWater,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
            color: const Color(0xff0F191F)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12.0 * SizeConfig.widthMultiplier!,
              vertical: 7 * SizeConfig.heightMultiplier!),
          child: Column(
            children: [
              SizedBox(
                height: 5 * SizeConfig.heightMultiplier!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Water Consumed',
                    style: AppTextStyle.boldBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText2?.color,
                        fontSize: 12 * SizeConfig.textMultiplier!),
                  ),
                  SvgPicture.asset(
                    ImagePath.add,
                    color: kPureWhite,
                  )
                ],
              ),
              Container(
                height: 120 * SizeConfig.heightMultiplier!,
                width: 160 * SizeConfig.widthMultiplier!,
                child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  axes: [
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 0,
                      interval: 10,
                      canScaleToFit: true,
                      showTicks: false,
                      showLabels: false,
                      annotations: [
                        GaugeAnnotation(
                            widget: Padding(
                          padding: EdgeInsets.only(
                              top: 30 * SizeConfig.heightMultiplier!),
                          child: Column(
                            children: [
                              Text(
                                '${homeController.waterLevel.value.toStringAsFixed(1)} L',
                                style: AppTextStyle.boldWhiteText.copyWith(
                                    fontSize: 25 * SizeConfig.textMultiplier!,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text("of " + totalWater.toStringAsFixed(1) + "L",
                                  style: AppTextStyle.normalBlackText.copyWith(
                                      color: kgrey,
                                      fontSize: 12 * SizeConfig.textMultiplier!,
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        )),
                      ],
                      axisLineStyle: AxisLineStyle(
                        cornerStyle: CornerStyle.bothCurve,
                          color: kPureWhite,
                          thickness: 12.0 * SizeConfig.widthMultiplier!,
                          thicknessUnit: GaugeSizeUnit.logicalPixel),
                      // pointer marker & needle pointer
                      pointers: [
                        RangePointer(
                          cornerStyle: CornerStyle.bothCurve,
                          gradient: const SweepGradient(
                            colors: [
                              Color(0xff9DDCFF),
                              Color(0xff31B5FF),
                            ],
                          ),
                          value:
                              (homeController.waterLevel.value / totalWater) *
                                  100,
                          width: 12 * SizeConfig.widthMultiplier!,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                        ),
                      ],
                    ),
                  ],
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
              // SizedBox(
              //   height: 22.5 * SizeConfig.heightMultiplier!,
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text(
              //       consumedWater.toStringAsFixed(1) + " ltr",
              //       style: AppTextStyle.boldBlackText.copyWith(
              //           color: Theme.of(context).textTheme.bodyText2?.color,
              //           fontSize: 14 * SizeConfig.textMultiplier!),
              //     ),
              //     SizedBox(width: 2 * SizeConfig.widthMultiplier!),
              //     Text("of " + totalWater.toStringAsFixed(1) + " ltr",
              //         style: AppTextStyle.normalBlackText.copyWith(
              //           color: Theme.of(context).textTheme.bodyText2?.color,
              //           fontSize: 12 * SizeConfig.textMultiplier!,
              //           //  color: hintGrey
              //         )),
              //     Spacer(),
              //     Container(
              //       color: Colors.transparent,
              //       child: SvgPicture.asset(
              //         ImagePath.add,
              //         height: 14 * SizeConfig.widthMultiplier!,
              //         width: 14 * SizeConfig.widthMultiplier!,
              //         color: Theme.of(context).textTheme.bodyText2?.color,
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier!,
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
        String? fatInCal,
        BuildContext context) =>
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
          color: Theme.of(context).cardColor),
      child: Column(
        children: [
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.heightMultiplier!),
            child: Row(
              children: [
                Text(
                  'Today’s Requirements',
                  style: AppTextStyle.normalBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 14 * SizeConfig.textMultiplier!),
                ),
                const Spacer(),
                Text(totalCalory.toString(),
                    style: AppTextStyle.boldBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 16 * SizeConfig.textMultiplier!)),
              ],
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
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
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize: 14 * SizeConfig.textMultiplier!)),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text(carbsInGram.toString(),
                            style: AppTextStyle.boldBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!)),
                        SizedBox(
                          width: 2,
                        ),
                        Text(carbsInCal.toString(),
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!))
                      ],
                    ),
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
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize: 14 * SizeConfig.textMultiplier!)),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text(proteinInGram.toString(),
                            style: AppTextStyle.boldBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!)),
                        SizedBox(
                          width: 2,
                        ),
                        Text(proteinCal.toString(),
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!))
                      ],
                    ),
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
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize: 14 * SizeConfig.textMultiplier!)),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text(fatInGram.toString(),
                            style: AppTextStyle.boldBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!)),
                        SizedBox(
                          width: 2,
                        ),
                        Text(fatInCal.toString(),
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.widthMultiplier!,
          ),
        ],
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

Widget CaloriesBurnt(double burntCalories, VoidCallback onTap, bool isConnected,
        BuildContext context) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
            color: const Color(0xff1F1D0E)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12.0 * SizeConfig.widthMultiplier!,
              vertical: 7 * SizeConfig.heightMultiplier!),
          child: Column(
            children: [
              SizedBox(
                height: 5 * SizeConfig.heightMultiplier!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calories Burnt',
                    style: AppTextStyle.boldBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 12 * SizeConfig.textMultiplier!),
                  ),
                  Platform.isIOS
                      ? Image.asset(
                          ImagePath.health,
                          height: 19 * SizeConfig.heightMultiplier!,
                        )
                      : SvgPicture.asset(
                          ImagePath.gfit,
                        )
                ],
              ),
              // SizedBox(
              //   height: 12 * SizeConfig.heightMultiplier!,
              // ),
              SizedBox(
                height: 120 * SizeConfig.heightMultiplier!,
                width: 160 * SizeConfig.widthMultiplier!,
                child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  axes: [
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 0,
                      interval: 10,
                      canScaleToFit: true,
                      showTicks: false,
                      showLabels: false,
                      axisLineStyle: AxisLineStyle(
                        cornerStyle: CornerStyle.bothCurve,
                          color: kPureWhite,
                          thickness: 12.0 * SizeConfig.widthMultiplier!,
                          thicknessUnit: GaugeSizeUnit.logicalPixel),
                      annotations: [
                        GaugeAnnotation(
                            widget: Padding(
                          padding: EdgeInsets.only(
                              top: 30 * SizeConfig.heightMultiplier!),
                          child: Column(
                            children: [
                              Text(
                                burntCalories.toString(),
                                style: AppTextStyle.boldWhiteText.copyWith(
                                    fontSize: 25 * SizeConfig.textMultiplier!,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text("Kcal",
                                  style: AppTextStyle.normalBlackText.copyWith(
                                      color: kgrey,
                                      fontSize: 12 * SizeConfig.textMultiplier!,
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        )),
                      ],
                      pointers: [
                        RangePointer(
                            gradient: const SweepGradient(
                              colors: [
                                Color(0xffFFF176),
                                Color(0xffF54633),
                              ],
                            ),
                            value: isConnected ? 60 : 100,
                            cornerStyle: CornerStyle.bothCurve,
                            width: 12 * SizeConfig.widthMultiplier!,
                            sizeUnit: GaugeSizeUnit.logicalPixel),
                        // NeedlePointer(
                        //     value: isConnected ? burntCalories : 0,
                        //     needleLength: 45 * SizeConfig.heightMultiplier!,
                        //     lengthUnit: GaugeSizeUnit.logicalPixel,
                        //     needleColor:
                        //         Theme.of(context).primaryIconTheme.color,
                        //     needleStartWidth:
                        //         0.5 * SizeConfig.widthMultiplier!,
                        //     needleEndWidth: 4 * SizeConfig.widthMultiplier!,
                        //     knobStyle: KnobStyle(
                        //         knobRadius: 3 * SizeConfig.widthMultiplier!,
                        //         sizeUnit: GaugeSizeUnit.logicalPixel,
                        //         borderColor:
                        //             Theme.of(context).primaryIconTheme.color,
                        //         borderWidth: 2 * SizeConfig.widthMultiplier!,
                        //         color: kgreen49))
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
              // SizedBox(
              //   height: 13 * SizeConfig.heightMultiplier!,
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     isConnected
              //         ? RichText(
              //             textAlign: TextAlign.left,
              //             text: TextSpan(children: [
              //               WidgetSpan(
              //                   child: Container(
              //                 constraints: BoxConstraints(
              //                     maxWidth: 80 * SizeConfig.widthMultiplier!),
              //                 child: Text(
              //                   burntCalories.toString(),
              //                   style: AppTextStyle.boldBlackText.copyWith(
              //                       color: Theme.of(context)
              //                           .textTheme
              //                           .bodyText1
              //                           ?.color,
              //                       fontSize: 14 * SizeConfig.textMultiplier!,
              //                       height: 1),
              //                   overflow: TextOverflow.ellipsis,
              //                   maxLines: 1,
              //                 ),
              //               )),
              //               TextSpan(
              //                 text: " kcal",
              //                 style: AppTextStyle.boldBlackText.copyWith(
              //                     color: Theme.of(context)
              //                         .textTheme
              //                         .bodyText1
              //                         ?.color,
              //                     fontSize: 14 * SizeConfig.textMultiplier!,
              //                     height: 1),
              //               ),
              //             ]),
              //           )
              //         // Text(
              //         //   "999999999" + " kcal",
              //         //   style: AppTextStyle.boldBlackText
              //         //       .copyWith(
              //         //       color: Theme.of(context).textTheme.bodyText1?.color,
              //         //       fontSize: 14 * SizeConfig.textMultiplier!),
              //         // )
              //         : Text(
              //             'Not Connected',
              //             style: AppTextStyle.hmediumBlackText.copyWith(
              //               color: Theme.of(context).textTheme.bodyText1?.color,
              //             ),
              //           ),
              //     Spacer(),
              //     Container(
              //       color: Colors.transparent,
              //       child: SvgPicture.asset(
              //         ImagePath.power,
              //         height: 18 * SizeConfig.widthMultiplier!,
              //         width: 18 * SizeConfig.widthMultiplier!,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier!,
              )
            ],
          ),
        ),
      ),
    );
