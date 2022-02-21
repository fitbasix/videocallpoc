import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../controller/profile_controller.dart';

final ProfileController _profileController = Get.find();

Widget dobPicker() => Container(
      child: DatePickerWidget(
        looping: true,
        initialDate: DateTime.parse(_profileController.selectedDate.value),
        firstDate: DateTime(1994), //DateTime(1960),
        lastDate: DateTime.now(),
        dateFormat: "dd-MMMM-yyyy",
        //   "dd-MMMM-yyyy",
        //locale: DatePicker.localeFromString('he'),
        onChange: (DateTime newDate, _) {
          DateTime _selectedDate = newDate;
          _profileController.selectedDate.value = _selectedDate.toString();
          _profileController.DOBController.text =
              _profileController.selectedDate.value;
          // (DateFormat('LL-dd-yyyy').format(_selectedDate));
          // ignore: avoid_print
        },
        pickerTheme: DateTimePickerTheme(
          backgroundColor: Colors.transparent,
          itemHeight: 75,
          pickerHeight: 270 * SizeConfig.heightMultiplier!,
          itemTextStyle: TextStyle(
              color: lightBlack, fontSize: 28 * SizeConfig.heightMultiplier!),
          dividerColor: Colors.transparent,
        ),
      ),
    );
