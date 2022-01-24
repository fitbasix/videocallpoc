import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';

class SetDob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: datePicker(),
    );
  }
}

Widget datePicker() => SafeArea(
      child: Scaffold(
        body: Center(
          child: DatePickerWidget(
            looping: true,
            initialDate: DateTime(1999),
            firstDate: DateTime(1994), //DateTime(1960),
            lastDate: DateTime.now(),
            dateFormat: "dd-MMMM-yyyy",
            //   "dd-MMMM-yyyy",
            //locale: DatePicker.localeFromString('he'),
            onChange: (DateTime newDate, _) {
              DateTime _selectedDate = newDate;
              // ignore: avoid_print
              print(_selectedDate);
            },
            pickerTheme: DateTimePickerTheme(
              backgroundColor: Colors.transparent,
              itemHeight: 75,
              pickerHeight: 270 * SizeConfig.heightMultiplier!,
              itemTextStyle: TextStyle(
                  color: lightBlack,
                  fontSize: 28 * SizeConfig.heightMultiplier!),
              dividerColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
