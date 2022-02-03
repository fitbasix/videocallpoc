import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'widgets/water_capsule.dart';

class ConsumptionScreen extends StatelessWidget {
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: kBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 160 * SizeConfig.heightMultiplier!,
            ),
            Container(
              height: 182 * SizeConfig.heightMultiplier!,
              color: kPureWhite,
              child: Center(
                child: AnimatedLiquidCustomProgressIndicator(),
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Container(
              height: 244 * SizeConfig.heightMultiplier!,
              color: kPureWhite,
              child: Column(
                children: [
                  SizedBox(
                    height: 16 * SizeConfig.heightMultiplier!,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.widthMultiplier!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('water_intake'.tr,
                            style: AppTextStyle.boldBlackText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!)),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 8 * SizeConfig.widthMultiplier!,
                                    width: 8 * SizeConfig.widthMultiplier!,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width:
                                                2 * SizeConfig.widthMultiplier!,
                                            color: kGreyColor),
                                        color: kPureWhite),
                                  ),
                                  SizedBox(
                                      width: 5 * SizeConfig.widthMultiplier!),
                                  Text(
                                    'goal'.tr,
                                    style: AppTextStyle.normalBlackText
                                        .copyWith(
                                            fontSize: 10 *
                                                SizeConfig.textMultiplier!),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 4 * SizeConfig.heightMultiplier!,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8 * SizeConfig.widthMultiplier!,
                                    width: 8 * SizeConfig.widthMultiplier!,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kGreenColor),
                                  ),
                                  SizedBox(
                                      width: 5 * SizeConfig.widthMultiplier!),
                                  Text(
                                    'intake'.tr,
                                    style: AppTextStyle.normalBlackText
                                        .copyWith(
                                            fontSize: 10 *
                                                SizeConfig.textMultiplier!),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5 * SizeConfig.heightMultiplier!,
                  ),
                  Container(
                      height: 190 * SizeConfig.heightMultiplier!,
                      child: Obx(() => ChartApp(
                            waterDetails: _homeController
                                .waterDetails.value.response!.data!,
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartApp extends StatefulWidget {
  //const ChartApp({Key? key}) : super(key: key);
  ChartApp({required this.waterDetails});
  final List<ConsumedWater> waterDetails;
  @override
  __ChartAppState createState() => __ChartAppState();
}

class __ChartAppState extends State<ChartApp> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        // Axis
        primaryXAxis: CategoryAxis(
          isVisible: true,
          interval: 1.0,
          majorTickLines:
              MajorTickLines(size: 0, width: 0, color: Colors.transparent),
          //axisLine: AxisLine(color: Colors.transparent),
          labelStyle: AppTextStyle.normalBlackText
              .copyWith(fontSize: 10 * SizeConfig.textMultiplier!),
          // majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          majorGridLines: MajorGridLines(width: 0),
        ),
        legend: Legend(isVisible: false),

        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<ConsumedWater, String>>[
          //1 dataset
          AreaSeries<ConsumedWater, String>(
              dataSource: widget.waterDetails,
              opacity: 0.5,
              // gradient color
              gradient: const LinearGradient(colors: [
                GreyColor,
                Colors.white,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              xValueMapper: (ConsumedWater sales, _) =>
                  DateFormat('EEEE')
                      .format(sales.createdAt!)
                      .toString()
                      .substring(0, 3) +
                  '\n' +
                  DateFormat('dd').format(sales.createdAt!).toString(),
              yValueMapper: (ConsumedWater sales, _) =>
                  sales.totalWaterRequired,
              name: '',
              //marker
              markerSettings: const MarkerSettings(
                isVisible: true,
                // marker color
                color: Colors.white,
                borderColor: GreyColor,
              ),
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: false)),
          //2 dataset
          AreaSeries<ConsumedWater, String>(
              dataSource: widget.waterDetails,
              opacity: 0.5,
              // gradient color
              gradient: const LinearGradient(colors: [
                kGreenColor,
                Colors.white,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              //  color: Colors.green.shade200,
              xValueMapper: (ConsumedWater sales, _) =>
                  DateFormat('EEEE')
                      .format(sales.createdAt!)
                      .toString()
                      .substring(0, 3) +
                  '\n' +
                  DateFormat('dd').format(sales.createdAt!).toString(),
              yValueMapper: (ConsumedWater sales, _) =>
                  sales.totalWaterConsumed,
              name: '',
              //marker
              markerSettings: const MarkerSettings(
                isVisible: true,
                // marker color
                color: kGreenColor,
                borderColor: kGreenColor,
              ),
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: false)),
        ]);
  }
}
