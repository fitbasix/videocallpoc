import 'dart:io';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class HealthApp extends StatefulWidget {
  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> _healthDataList = [];
  final HomeController homeController = Get.find();
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 10;
  double _mgdl = 10.0;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // define the types to get
    final types = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      // Uncomment this line on iOS - only available on iOS
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    // with coresponsing permissions
    final permissions = [HealthDataAccess.READ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday =
        now.subtract(Duration(hours: int.parse(DateFormat('kk').format(now))));

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        String time = DateFormat('kk').format(DateTime.now());
        print(int.parse(time));
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);

        // save all the new data points (only the first 100)
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
      homeController.caloriesBurnt.value = 0.0;
      // print the results
      _healthDataList.forEach((x) {
        homeController.caloriesBurnt.value =
            x.value.toDouble() + homeController.caloriesBurnt.value;
        print(homeController.caloriesBurnt.value);
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'caloriesBurnt', homeController.caloriesBurnt.value.toString());
      // update the UI to display the results
      setState(() {
        _state =
            _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }
      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          return ListTile(
            title: Text("${p.unit}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return Text('$_nofSteps steps and $_mgdl mgdl are inserted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return Text('Failed to add data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY) {
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.DATA_ADDED)
      return _dataAdded();
    else if (_state == AppState.STEPS_READY)
      return _stepsFetched();
    else if (_state == AppState.DATA_NOT_ADDED) return _dataNotAdded();

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(50 * SizeConfig.widthMultiplier!),
        backgroundColor: Colors.white,
        insetAnimationDuration: const Duration(milliseconds: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 24 * SizeConfig.widthMultiplier!,
              vertical: 30 * SizeConfig.heightMultiplier!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'track_calories_heading'.tr,
                style: AppTextStyle.boldBlackText
                    .copyWith(fontSize: 18 * SizeConfig.textMultiplier!),
              ),
              SizedBox(
                height: 12 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'calories_track_reson'.tr,
                style: AppTextStyle.normalBlackText.copyWith(
                    fontSize: 14 * SizeConfig.textMultiplier!, color: hintGrey),
              ),
              SizedBox(
                height: 48 * SizeConfig.heightMultiplier!,
              ),
              GestureDetector(
                onTap: () {
                  fetchData();
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Platform.isIOS
                      ? HealthTrackOptionTile(
                        widget: Container(),
                          imagePath: ImagePath.appleHealth,
                          applicationName: 'appleHealth'.tr,
                        )
                      : HealthTrackOptionTile(
                          imagePath: ImagePath.googleFit,
                          applicationName: 'googleFit'.tr,
                        ),
                ),
              ),
              SizedBox(
                height: 30 * SizeConfig.heightMultiplier!,
              ),
              HealthTrackOptionTile(
                imagePath: ImagePath.fitBit,
                applicationName: 'fitbit'.tr,
              ),
              SizedBox(
                height: 15 * SizeConfig.heightMultiplier!,
              ),
            ],

            /*AppBar(
              title: const Text('Health Example'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () {
                    fetchData();
                  },
                ),
                IconButton(
                  onPressed: () {
                    addData();
                  },
                  icon: Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () {
                    fetchStepData();
                  },
                  icon: Icon(Icons.nordic_walking),
                )
              ],
            ),*/
            // body: Center(
            //   child: _content(),
            // )),
          ),
        ));
  }
}

class HealthTrackOptionTile extends StatelessWidget {
  String imagePath;
  String applicationName;
  Widget? widget;
  HealthTrackOptionTile(
      {required this.imagePath, required this.applicationName,this.widget});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       widget==null? SvgPicture.asset(imagePath,
            width: 30 * SizeConfig.widthMultiplier!, fit: BoxFit.fitWidth):
             Image.asset(imagePath,
            width: 30 * SizeConfig.widthMultiplier!, fit: BoxFit.fitWidth),
        SizedBox(
          width: 11 * SizeConfig.widthMultiplier!,
        ),
        Text(applicationName,
            style: AppTextStyle.boldBlackText
                .copyWith(fontSize: 18 * SizeConfig.textMultiplier!))
      ],
    );
  }
}
