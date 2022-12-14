import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../controller/profile_controller.dart';

final ProfileController _profileController = Get.find();

Widget dobPicker(
    BuildContext context
    ) => Container(
      child: DatePickerWidget(
        looping: true,
        initialDate: DateTime.parse((_profileController.homeController
                    .userProfileData.value.response!.data!.profile!.dob ??
                DateTime.now())
            .toString()),
        firstDate: DateTime(1900), //DateTime(1960),
        lastDate: DateTime.now(),
        dateFormat: "dd-MMMM-yyyy",
        //   "dd-MMMM-yyyy",
        //locale: DatePicker.localeFromString('he'),
        onChange: (DateTime newDate, _) {
          DateTime _selectedDate = newDate;
          _profileController.selectedDate.value =
              DateFormat("dd/LL/yyyy").format(newDate);
          _profileController.DOBController.text =
              DateFormat("dd/LL/yyyy").format(newDate);
          // (DateFormat('LL-dd-yyyy').format(_selectedDate));
          // ignore: avoid_print
        },
        pickerTheme: DateTimePickerTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          itemHeight: 75*SizeConfig.heightMultiplier!,
          pickerHeight: 270 * SizeConfig.heightMultiplier!,
          itemTextStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyText1?.color,
              fontSize: 28 * SizeConfig.heightMultiplier!),
          dividerColor: Colors.transparent,
        ),
      ),
    );
