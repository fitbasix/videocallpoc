import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SetDob extends StatelessWidget {
  var userStartedEditing = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "3", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: 2 * SizeConfig.heightMultiplier!,
              width: Get.width,
            ),
            Container(
              color: kGreenColor,
              height: 2 * SizeConfig.heightMultiplier!,
              width: Get.width * 0.375,
            ),
          ]),
          SizedBox(
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_dob'.tr,
              style: AppTextStyle.boldBlackText.copyWith(
                  color: Theme.of(context).textTheme.bodyText1!.color),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          datePicker(context),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: Obx(
                  ()=> GestureDetector(
                onTap:userStartedEditing.value?() {
                  Navigator.pushNamed(context, RouteName.setHeight);
                }:null,
                child: Container(
                  width: Get.width,
                  height: 48 * SizeConfig.heightMultiplier!,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
                    color: userStartedEditing.value?kgreen49:hintGrey,
                  ),
                  child: Center(
                    child: Text(
                      'proceed'.tr,
                      style: AppTextStyle.normalWhiteText.copyWith(
                          color: userStartedEditing.value?kPureWhite:greyBorder
                      ),
                    ),
                  ),
                ),
              ),
            )

            // ProceedButton(
            //     title: 'proceed'.tr,
            //     onPressed: () async {
            //       print(_spgController.selectedDate.value);
            //       Navigator.pushNamed(context, RouteName.setHeight);
            //     }),
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }

  Widget datePicker(BuildContext context) => Container(
    child: DatePickerWidget(
      looping: true,
      initialDate: DateTime.parse(_spgController.selectedDate.value),
      firstDate: DateTime(1900), //DateTime(1960),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      //   "dd-MMMM-yyyy",
      //locale: DatePicker.localeFromString('he'),
      onChange: (DateTime newDate, _) {
        userStartedEditing.value = true;
        DateTime _selectedDate = newDate;
        _spgController.selectedDate.value = _selectedDate.toString();
        // (DateFormat('LL-dd-yyyy').format(_selectedDate));
        // ignore: avoid_print
      },
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.transparent,
        itemHeight: 60*SizeConfig.heightMultiplier!,
        pickerHeight: 220 * SizeConfig.heightMultiplier!,
        // itemHeight: 75,
        // pickerHeight: 270 * SizeConfig.heightMultiplier!,
        itemTextStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 28 * SizeConfig.heightMultiplier!),
        dividerColor: Colors.transparent,
      ),
    ),
  );
}

final SPGController _spgController = Get.find();


