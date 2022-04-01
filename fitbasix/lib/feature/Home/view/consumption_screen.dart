
import 'dart:io';

import 'dart:developer';



import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

import 'widgets/water_capsule.dart';

class ConsumptionScreen extends StatelessWidget {
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SvgPicture.asset(
                  ImagePath.backIcon,
                  width: 7 * SizeConfig.widthMultiplier!,
                  height: 12 * SizeConfig.heightMultiplier!,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            )),
        title: Text(
          'today_consumption'.tr,
          style: AppTextStyle.boldBlackText.copyWith(
              color: Theme.of(context).textTheme.bodyText1?.color,
              fontSize: 16 * SizeConfig.textMultiplier!),
        ),
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: SingleChildScrollView(
        child: Obx(
          () => _homeController.isConsumptionLoading.value
              ? Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          100 * SizeConfig.heightMultiplier!,
                      child: CustomizedCircularProgress()),
                )
              : Container(
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).secondaryHeaderColor,
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
                                                            .textMultiplier!,
                                                    color: Theme.of(context)
                                                        .primaryColor),
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
                                                    width: 1,
                                                    color: greyBorder)),
                                            width: 132 *
                                                SizeConfig.widthMultiplier!,
                                            height: 48 *
                                                SizeConfig.heightMultiplier!,
                                            child: DailyGoalDropDown(
                                                context: context,
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
                                                            .textMultiplier!,
                                                    color: Theme.of(context)
                                                        .primaryColor),
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
                                                    .normalWhiteText
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color),
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
                                                            .textMultiplier!,
                                                    color: Theme.of(context)
                                                        .primaryColor),
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
                                      fontSize: 14 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context).primaryColor),
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
                                                width: 1, color: greyBorder)),
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
                                                _homeController.formatedTime(
                                                    _homeController
                                                        .waterTimingFrom.value),
                                                style: AppTextStyle
                                                    .normalWhiteText,
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
                                                width: 1, color: greyBorder)),
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
                                                _homeController.formatedTime(
                                                    _homeController
                                                        .waterTimingTo.value),
                                                style: AppTextStyle
                                                    .normalWhiteText,
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
                                      fontSize: 14 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context).primaryColor),
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
                                              width: 1, color: greyBorder)),
                                      height: 48 * SizeConfig.heightMultiplier!,
                                      child: ReminderDropDown(
                                          listofItems: _homeController
                                              .waterSource
                                              .value
                                              .response!
                                              .data!,
                                          context: context,
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
                                  // onDoubleTap: (){
                                  //   showDemoNotification();
                                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("showing demo notification")));
                                  // },
                                  onTap: () async {
                                    String s = "12:24";
                                    _homeController
                                        .iswaterNotificationDataUpdating
                                        .value = true;
                                    await HomeService
                                        .updateWaterNotificationDetails(
                                            _homeController.goalWater.value,
                                            _homeController
                                                    .waterTimingFrom.value.hour
                                                    .toString() +
                                                ":" +
                                                _homeController.waterTimingFrom
                                                    .value.minute
                                                    .toString(),
                                            _homeController
                                                    .waterTimingTo.value.hour
                                                    .toString() +
                                                ":" +
                                                _homeController
                                                    .waterTimingTo.value.minute
                                                    .toString(),
                                            _homeController
                                                .waterReminder.value.serialId!);
                                    _homeController.userProfileData.value =
                                        await CreatePostService
                                            .getUserProfile();
                                    _homeController
                                        .iswaterNotificationDataUpdating
                                        .value = false;
                                    setNotificationDetailsForConsumption(
                                        _homeController
                                            .waterTimingFrom.value.hour,
                                        _homeController
                                            .waterTimingFrom.value.minute,
                                        _homeController
                                            .waterTimingTo.value.hour,
                                        _homeController
                                            .waterTimingTo.value.minute,
                                        _homeController
                                            .waterReminder.value.serialId!);
                                  },
                                  child: Container(
                                      width: Get.width -
                                          32 * SizeConfig.widthMultiplier!,
                                      height: 48 * SizeConfig.heightMultiplier!,
                                      decoration: BoxDecoration(
                                        color: kgreen49,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: _homeController
                                                .iswaterNotificationDataUpdating
                                                .value
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.white),
                                              )
                                            : Text(
                                                "Save Changes",
                                                style:
                                                    AppTextStyle.white400Text,
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
                        color: Theme.of(context).secondaryHeaderColor,
                        child: Center(
                          child: AnimatedLiquidCustomProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        height: 16 * SizeConfig.heightMultiplier!,
                      ),
                      Container(
                        height: 244 * SizeConfig.heightMultiplier!,
                        color: Theme.of(context).secondaryHeaderColor,
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
                                      style: AppTextStyle.boldWhiteText
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
                                                  .normalWhiteText
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
                                                  .normalWhiteText
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
                                child: Obx(
                                    () => _homeController.updateWaterData.value
                                        ? ChartApp(
                                            waterDetails: [],
                                          )
                                        : ChartApp(
                                            waterDetails: _homeController
                                                .waterDetails
                                                .value
                                                .response!
                                                .data!
                                                .reversed
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

  // void setNotificationDetailsForConsumption(int fromHour,int fromMinute,int toHour,int toMinute, int reminderSerialNo) async{
  //   bool canceled = await AndroidAlarmManager.cancel(0).then((value){
  //     AndroidAlarmManager.periodic(Duration(seconds: 30), 0, showWaterConsumptionNotification,allowWhileIdle: true,exact: true,startAt: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,fromHour,fromMinute));
  //     return value;
  //   });
  // }

    void setNotificationDetailsForConsumption(int fromHour, int fromMinute,
      int toHour, int toMinute, int reminderSerialNo) async {
      AwesomeNotifications().cancelAll();
      if(reminderSerialNo >0){
        DateTime startTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,fromHour,fromMinute);
        DateTime endTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,toHour,toMinute).subtract(Duration(minutes: reminderSerialNo));
        int notificationId = 1;
        while((startTime.isBefore(endTime)&&endTime.isAfter(startTime))){
          startTime = startTime.add(Duration(minutes: reminderSerialNo));
          await AwesomeNotifications().createNotification(
              content: NotificationContent(
                displayOnForeground: true,
                displayOnBackground: true,
                id: notificationId,
                channelKey: 'basic_channel',
                title: 'Water Reminder',
                body: 'drink Water $notificationId',
                wakeUpScreen: true,
                category: NotificationCategory.Reminder,
                payload: {'uuid': 'uuid-test'},
                autoDismissible: false,
              ),
              schedule:NotificationCalendar(
                  second: startTime.second,
                  year: startTime.year,
                  minute: startTime.minute,
                  repeats: true,
                  allowWhileIdle: true,
                  preciseAlarm: true,
                timeZone: AwesomeNotifications.localTimeZoneIdentifier

              )

          );
          print(startTime.toString()+" bbbbb");

        }
      }
  }
  void showDemoNotification() async {
    DateTime time = DateTime.now();
    AwesomeNotifications().cancelAll();
    for(int i = 1;i<=20;i++){
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            displayOnForeground: true,
            displayOnBackground: true,
            id: i,
            channelKey: 'basic_channel',
            title: 'water in take demo',
            body: 'This notification was scheduled $i',
            wakeUpScreen: true,
            category: NotificationCategory.Reminder,
            payload: {'uuid': 'uuid-test'},
            autoDismissible: false,
          ),
          schedule:NotificationCalendar(
              second: time.second,
              year: time.year,
              minute: time.minute,
              repeats: true,
              allowWhileIdle: true,
              preciseAlarm: true
          )
      );
      time = time.add(Duration(minutes: 1));
      print(time);
    }
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
        enableAxisAnimation: true,
        plotAreaBorderWidth: 0,
        // Axis
        primaryXAxis: CategoryAxis(
          isVisible: true,
          interval: 1.0,
          majorTickLines:
              MajorTickLines(size: 0, width: 0, color: Colors.transparent),
          majorGridLines: MajorGridLines(color: greyBorder, width: 0.2),
          axisLine: AxisLine(color: greyBorder, width: 0.5),
          labelStyle: AppTextStyle.normalWhiteText
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
              gradient: LinearGradient(colors: [
                Colors.white,
                grey2B,
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
                Colors.black,
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

void showWaterConsumptionNotification(int time) async {
  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  if (Platform.isIOS) SharedPreferencesIOS.registerWith();
  print("calledddd1123");
  print(DateTime.now());
  SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance().then((value) {
    DateTime endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        value.getInt("endHour")!,
        value.getInt("endMinute")!
    );
    DateTime startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        value.getInt("startHour")!,
        value.getInt("startMinute")!
    );
    if (DateTime.now().isBefore(endTime)&&DateTime.now().isAfter(startTime)) {
      print("calledddd");
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Water',
        body: 'Drink water',
      ));
    }
    return value;
  });
}


