import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/view/widgets/caloriesDetails.dart';
import 'package:fitbasix/feature/Home/view/widgets/healthData.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../controller/Home_Controller.dart';
import '../model/water_model.dart';
import 'consumption_screen.dart';


class CaloriesBurnetScreen extends StatefulWidget {
  const CaloriesBurnetScreen({Key? key}) : super(key: key);

  @override
  State<CaloriesBurnetScreen> createState() => _CaloriesBurnetScreenState();
}

class _CaloriesBurnetScreenState extends State<CaloriesBurnetScreen> {
  HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //leadingWidth: 20*SizeConfig.widthMultiplier!,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
              color: Theme.of(context).primaryColor,
            )),
        title: Text('Today’s Calories  Burned',style: AppTextStyle.black600Text.copyWith(color: Theme.of(context).primaryColor),),

        // Padding(
        //     padding: EdgeInsets.only(left: 5*SizeConfig.widthMultiplier!),
        //     child: Text(, style: AppTextStyle.hblack600Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color))),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //
        //       },
        //       icon: Icon(
        //         Icons.search,
        //         color: Theme.of(context).primaryColor,
        //         size: 25 * SizeConfig.heightMultiplier!,
        //       )),
        // ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Container(
              width:
              165*SizeConfig.widthMultiplier!,
              child: CaloriesBurnt(
                  _homeController
                      .caloriesBurnt.value
                      .toInt()
                      .toDouble(), () {

                // showDialog(
                //     context: context,
                //     builder: (_) =>
                //         HealthApp());
              },
                  //is connected
                  true,
                  //Passing context for theme
                  context),
            ),
          ),
          SizedBox(
            height: 45 * SizeConfig.heightMultiplier!,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('calories_burnt_text'.tr,
                    style: AppTextStyle.boldWhiteText
                        .copyWith(
                        fontSize: 14 *
                            SizeConfig.textMultiplier!)),
                Container(

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      ///buttons for changing dates
                      Container(
                        padding: EdgeInsets.only(top: 2*SizeConfig.heightMultiplier!),
                        width: 140*SizeConfig.widthMultiplier!,
                        child: Row(
                          children: [
                            ClipOval(
                              child: Material(
                                color: kBlack, // Button color
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.2), // Splash color
                                  onTap: () {},
                                  child: SizedBox(width: 16*SizeConfig.widthMultiplier!, height: 16*SizeConfig.heightMultiplier!, child: Icon(Icons.chevron_left_outlined,color: kPureWhite,size: 10*SizeConfig.heightMultiplier!,)),
                                ),
                              ),
                            ),
                            Spacer(),
                            Text('10 Feb - 16 Feb'),
                            Spacer(),
                            ClipOval(
                              child: Material(
                                color: kBlack, // Button color
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.2), // Splash color
                                  onTap: () {},
                                  child: SizedBox(width: 16*SizeConfig.widthMultiplier!, height: 16*SizeConfig.heightMultiplier!, child: Icon(Icons.chevron_right_outlined,color: kPureWhite,size: 10*SizeConfig.heightMultiplier!,)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 12*SizeConfig.heightMultiplier!,),
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
                            'Goal'.tr,
                            style: AppTextStyle
                                .normalWhiteText
                                .copyWith(
                                fontSize: 10 *
                                    SizeConfig
                                        .textMultiplier!),
                          ),
                          SizedBox(
                            width:
                            9 * SizeConfig.heightMultiplier!,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 8 *
                                    SizeConfig.widthMultiplier!,
                                width: 8 *
                                    SizeConfig.widthMultiplier!,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPink),
                              ),
                              SizedBox(
                                  width: 5 *
                                      SizeConfig
                                          .widthMultiplier!),
                              Text(
                                'Burned'.tr,
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
                      () => _homeController.monthlyHealthData.isEmpty
                      ? ChartApp(
                    waterDetails: [],
                  )
                      : Obx(
                        ()=> ChartAppCalories(
                          healthDataList: _homeController.monthlyHealthData.value,
                  ),
                      ))),
          SizedBox(
            height: 10 * SizeConfig.heightMultiplier!,
          ),
        ],
      ),
    );

  }
}

class ChartAppCalories extends StatefulWidget {
  //const ChartApp({Key? key}) : super(key: key);
  ChartAppCalories({Key? key, required this.healthDataList}) : super(key: key);
   List<MonthlyHealthData> healthDataList;
  @override
  __ChartAppCaloriesState createState() => __ChartAppCaloriesState();
}

class __ChartAppCaloriesState extends State<ChartAppCalories> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        enableAxisAnimation: true,
        plotAreaBorderWidth: 0,
        // Axis
        primaryXAxis: CategoryAxis(
          isVisible: true,
          interval: 1.0,
          majorTickLines: MajorTickLines(size: 0, width: 0, color: Colors.transparent),
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
        series: <ChartSeries<MonthlyHealthData, String>>[
          //1 dataset
          AreaSeries<MonthlyHealthData, String>(
              dataSource: widget.healthDataList,
              opacity: 0.5,
              // gradient color
              gradient: LinearGradient(colors: [
                Colors.white,
                grey2B,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              xValueMapper: (MonthlyHealthData sales, _) =>
              DateFormat('EEEE')
                  .format(sales.caloriesBurntDate!)
                  .toString()
                  .substring(0, 3) +
                  '\n' +
                  DateFormat('dd').format(sales.caloriesBurntDate!).toString(),
              yValueMapper: (MonthlyHealthData sales, _) =>
              sales.caloriesBurnt,
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
          AreaSeries<MonthlyHealthData, String>(
              dataSource: widget.healthDataList,
              opacity: 0.5,
              // gradient color
              gradient: const LinearGradient(colors: [
                kGreenColor,
                Colors.black,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              //  color: Colors.green.shade200,
              xValueMapper: (MonthlyHealthData sales, _) =>
              DateFormat('EEEE')
                  .format(sales.caloriesBurntDate!)
                  .toString()
                  .substring(0, 3) +
                  '\n' +
                  DateFormat('dd').format(sales.caloriesBurntDate!).toString(),
              yValueMapper: (MonthlyHealthData sales, _) =>
              sales.caloriesBurnt,
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
