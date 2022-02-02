import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ConsumptionScreen extends StatelessWidget {
  const ConsumptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Container(
           // height: 244*SizeConfig.heightMultiplier!,
            color: kPureWhite,
            child:  ChartApp(),
          ),
        ],
      ),
    );
  }
}

class ChartApp extends StatefulWidget {
  //const ChartApp({Key? key}) : super(key: key);

  @override
  __ChartAppState createState() => __ChartAppState();
}

class __ChartAppState extends State<ChartApp> {
  List<ConsumptionData> data1 = [
    ConsumptionData('Mon', 25),
    ConsumptionData('Tue', 30),
    ConsumptionData('Wed', 30),
    ConsumptionData('Thu', 30),
    ConsumptionData('Fri', 30),
    ConsumptionData('Sat', 33),
    ConsumptionData('Sun', 30),
  ];
  List<ConsumptionData> data = [
    ConsumptionData('Mon', 20),
    ConsumptionData('Tue', 30),
    ConsumptionData('Wed', 25),
    ConsumptionData('Thu', 30),
    ConsumptionData('Fri', 27),
    ConsumptionData('Sat', 25),
    ConsumptionData('Sun', 27),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          //Initialize the chart widget
          SfCartesianChart(
              plotAreaBorderWidth: 0,
              // Axis
              primaryXAxis: CategoryAxis(
                isVisible: true,
                 interval: 1.0,
                majorTickLines: MajorTickLines(
                    size: 0, width: 0, color: Colors.transparent),
                //axisLine: AxisLine(color: Colors.transparent),
                // labelStyle: AppTextStyle.regularGreyText
                //     .copyWith(fontSize: 10 * SizeConfig.textMultiplier!),
                // majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
                majorGridLines: MajorGridLines(width: 0),
              ),
              // primaryXAxis: CategoryAxis(),
              // Chart title
              // Enable legend
              legend: Legend(isVisible: false),
          
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<ConsumptionData, String>>[
                //1 dataset
                AreaSeries<ConsumptionData, String>(
                    dataSource: data1,
                    opacity: 0.5,
                    // gradient color
                    gradient: const LinearGradient(colors: [
                      Colors.grey,
                      Colors.white,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    // color: Colors.grey.shade400,
                    xValueMapper: (ConsumptionData sales, _) => sales.weekDay,
                    yValueMapper: (ConsumptionData sales, _) => sales.value,
                    name: '',
                    //marker
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      // marker color
                      color: Colors.white,
                      borderColor: Colors.grey,
                    ),
                    // Enable data label
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false)),
                //2 dataset
                AreaSeries<ConsumptionData, String>(
                    dataSource: data,
                    opacity: 0.5,
                    // gradient color
                    gradient: const LinearGradient(colors: [
                      Colors.green,
                      Colors.white,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    //  color: Colors.green.shade200,
                    xValueMapper: (ConsumptionData sales, _) => sales.weekDay,
                    yValueMapper: (ConsumptionData sales, _) => sales.value,
                    name: '',
                    //marker
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      // marker color
                      color: Colors.green,
                      borderColor: Colors.green,
                    ),
                    // Enable data label
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false)),
              ]),
        ]));
  }
}

class ConsumptionData {
  ConsumptionData(this.weekDay, this.value);

  final String weekDay;
  final double value;
}
