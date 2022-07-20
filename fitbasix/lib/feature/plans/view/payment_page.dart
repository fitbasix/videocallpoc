import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/plans/controller/plans_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/universal_widgets/proceed_button.dart';
import 'widget/add_card_details.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({Key? key}) : super(key: key);

  final PlansController _plansController = Get.find();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (_plansController.pageIndex.value == 1) {
          _plansController.pageIndex.value = 0;
          return Future.value(false);
        } else {
          _plansController.pageIndex.value = 0;
          _plansController.clearValues();
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          elevation: 0,
          title: Obx(
            () => Text(
              _plansController.pageIndex.value == 0 ? 'Payment' : 'Cart',
              style: AppTextStyle.titleText.copyWith(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontSize: 16 * SizeConfig.textMultiplier!),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * SizeConfig.widthMultiplier!,
          ),
          child: Obx(
            () => _plansController.pageList[_plansController.pageIndex.value],
          ),
        ),
      ),
    );
  }
}
