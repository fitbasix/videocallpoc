import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/dailyGoalDropDown.dart';
import 'package:fitbasix/feature/Home/view/widgets/reminderDropDown.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'widgets/water_capsule.dart';

class ConsumptionScreen extends StatelessWidget {
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Text(
          'today_consumption'.tr,
          style: AppTextStyle.boldBlackText.copyWith(
              color: lightBlack, fontSize: 16 * SizeConfig.textMultiplier!),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(
          () => _homeController.isConsumptionLoading.value
              ? Center(
                  child: CustomizedCircularProgress(),
                )
              : Container(
                  color: kBackgroundColor,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 * SizeConfig.widthMultiplier!),
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16 * SizeConfig.heightMultiplier!,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'goal'.tr,
                                            style: AppTextStyle.boldBlackText
                                                .copyWith(
                                                    fontSize: 14 *
                                                        SizeConfig
                                                            .textMultiplier!),
                                          ),
                                          SizedBox(
                                            height: 12 *
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: lightGrey)),
                                            width: 132 *
                                                SizeConfig.widthMultiplier!,
                                            height: 48 *
                                                SizeConfig.heightMultiplier!,
                                            child: DailyGoalDropDown(
                                                listofItems:
                                                    _homeController.Watergoal,
                                                onChanged: (Value) {
                                                  _homeController
                                                      .goalWater.value = Value;
                                                },
                                                hint: _homeController
                                                    .goalWater.value),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25 * SizeConfig.heightMultiplier!,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'completed'.tr,
                                            style: AppTextStyle.boldBlackText
                                                .copyWith(
                                                    fontSize: 14 *
                                                        SizeConfig
                                                            .textMultiplier!),
                                          ),
                                          SizedBox(
                                            height: 26 *
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (_homeController
                                                            .waterLevel.value *
                                                        _homeController
                                                            .waterDetails
                                                            .value
                                                            .response!
                                                            .data![0]
                                                            .totalWaterRequired!)
                                                    .toStringAsFixed(2),
                                                style: AppTextStyle
                                                    .normalBlackText,
                                              ),
                                              SizedBox(
                                                width: 3 *
                                                    SizeConfig.widthMultiplier!,
                                              ),
                                              Text(
                                                "ltr",
                                                style: AppTextStyle.NormalText
                                                    .copyWith(color: grey183),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25 * SizeConfig.heightMultiplier!,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'status'.tr,
                                            style: AppTextStyle.boldBlackText
                                                .copyWith(
                                                    fontSize: 14 *
                                                        SizeConfig
                                                            .textMultiplier!),
                                          ),
                                          SizedBox(
                                            height: 26 *
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Text(
                                            _homeController.waterStatus.value,
                                            style: AppTextStyle.boldBlackText
                                                .copyWith(color: kGreenColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  'Timings'.tr,
                                  style: AppTextStyle.boldBlackText.copyWith(
                                      fontSize:
                                          14 * SizeConfig.textMultiplier!),
                                ),
                                SizedBox(
                                  height: 12 * SizeConfig.heightMultiplier!,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        _homeController.selectTime(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                width: 1.5, color: lightGrey)),
                                        height:
                                            48 * SizeConfig.heightMultiplier!,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 16 *
                                                  SizeConfig.widthMultiplier!,
                                              right: 10 *
                                                  SizeConfig.widthMultiplier!),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                 _homeController.formatedTime(_homeController
                                                        .waterTimingFrom.value),
                                                style: AppTextStyle.NormalText,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                    SizedBox(
                                      width: 8 * SizeConfig.widthMultiplier!,
                                    ),
                                    Text(
                                      'to'.tr,
                                      style: AppTextStyle.normalBlackText
                                          .copyWith(
                                              fontSize: 14 *
                                                  SizeConfig.textMultiplier!,
                                              color: hintGrey),
                                    ),
                                    SizedBox(
                                      width: 8 * SizeConfig.widthMultiplier!,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        _homeController.selectTime2(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                width: 1.5, color: lightGrey)),
                                        height:
                                            48 * SizeConfig.heightMultiplier!,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 16 *
                                                  SizeConfig.widthMultiplier!,
                                              right: 10 *
                                                  SizeConfig.widthMultiplier!),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _homeController.formatedTime(_homeController
                                                        .waterTimingTo.value),
                                                style: AppTextStyle.NormalText,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                                SizedBox(
                                  height: 24 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  'reminder'.tr,
                                  style: AppTextStyle.boldBlackText.copyWith(
                                      fontSize:
                                          14 * SizeConfig.textMultiplier!),
                                ),
                                SizedBox(
                                  height: 12 * SizeConfig.heightMultiplier!,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              width: 1.5, color: lightGrey)),
                                      height: 48 * SizeConfig.heightMultiplier!,
                                      child: ReminderDropDown(
                                          listofItems: _homeController
                                              .waterSource
                                              .value
                                              .response!
                                              .data!,
                                          hint: _homeController
                                              .waterReminder.value,
                                          onChanged: (Value) {
                                            _homeController
                                                .waterReminder.value = Value;
                                            // TimeOfDay parseTimeOfDay(String t) {
                                            //   // DateTime dateTime =
                                            //   //     DateFormat('hh:mm')
                                            //   //         .parse(t);
                                            //   // print(dateTime.toString());
                                            //   return TimeOfDay(
                                            //       hour: int.parse(t.split(":")[0]),
                                            //       minute: int.parse(t.split(":")[1]));
                                            // }

                                            // TimeOfDay time =
                                            //     parseTimeOfDay("06:54");
                                            // print(time.toString() + "time");
                                          }),
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 12 * SizeConfig.heightMultiplier!,
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    String s = "12:24";
                                    _homeController
                                        .iswaterNotificationDataUpdating.value = true;
                                    await HomeService.updateWaterNotificationDetails(
                                        _homeController.goalWater.value,
                                       _homeController.waterTimingFrom.value.hour.toString()+":"+_homeController.waterTimingFrom.value.minute.toString(),
                                        _homeController.waterTimingTo.value.hour.toString()+":"+_homeController.waterTimingTo.value.minute.toString(),
                                        _homeController
                                            .waterReminder.value.serialId!);
                                            _homeController.userProfileData.value = await CreatePostService.getUserProfile();
                                    _homeController
                                        .iswaterNotificationDataUpdating.value = false;
                                  },
                                  child: Container(
                                      width: Get.width -
                                          32 * SizeConfig.widthMultiplier!,
                                      height: 48 * SizeConfig.heightMultiplier!,
                                      color: kGreenColor,
                                      child: Center(
                                        child: _homeController
                                        .iswaterNotificationDataUpdating.value?
                                        Center(child: CircularProgressIndicator(color: Colors.white),)
                                        :Text(
                                          "Save Changes",
                                          style: AppTextStyle.white400Text,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 16 * SizeConfig.heightMultiplier!,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16 * SizeConfig.heightMultiplier!,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('water_intake'.tr,
                                      style: AppTextStyle.boldBlackText
                                          .copyWith(
                                              fontSize: 14 *
                                                  SizeConfig.textMultiplier!)),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 8 *
                                                  SizeConfig.widthMultiplier!,
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier!,
                                                      color: kGreyColor),
                                                  color: kPureWhite),
                                            ),
                                            SizedBox(
                                                width: 5 *
                                                    SizeConfig
                                                        .widthMultiplier!),
                                            Text(
                                              'goal'.tr,
                                              style: AppTextStyle
                                                  .normalBlackText
                                                  .copyWith(
                                                      fontSize: 10 *
                                                          SizeConfig
                                                              .textMultiplier!),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              4 * SizeConfig.heightMultiplier!,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 8 *
                                                  SizeConfig.widthMultiplier!,
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kGreenColor),
                                            ),
                                            SizedBox(
                                                width: 5 *
                                                    SizeConfig
                                                        .widthMultiplier!),
                                            Text(
                                              'intake'.tr,
                                              style: AppTextStyle
                                                  .normalBlackText
                                                  .copyWith(
                                                      fontSize: 10 *
                                                          SizeConfig
                                                              .textMultiplier!),
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
                                      waterDetails: _homeController.waterDetails
                                          .value.response!.data!.reversed
                                          .toList(),
                                    ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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