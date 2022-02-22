import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/help_and_support/controller/help_support_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../profile/view/appbar_for_account.dart';
import 'package:get/get.dart';

import '../../widgets/enpandableWidget.dart';

class TermOfUseScreen extends StatelessWidget {
  TermOfUseScreen({Key? key}) : super(key: key);
  HelpAndSupportConroller _termOfUseController =
      Get.put(HelpAndSupportConroller());

  @override
  Widget build(BuildContext context) {
    if (_termOfUseController.termOfUseIsLoading.value) {
      _termOfUseController.getTermOfUseContent();
    }
    return Scaffold(
        backgroundColor: kPureWhite,
        appBar: AppBarForAccount(
            title: "term_of_use".tr,
            onback: () {
              Navigator.pop(context);
            }),
        body: Obx(() => (_termOfUseController.termOfUseIsLoading.value)
            ? Center(
                child: CustomizedCircularProgress(),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  //Last updated text
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16 * SizeConfig.widthMultiplier!,
                          vertical: 14 * SizeConfig.heightMultiplier!),
                      child: Text(
                        "last_updated".tr +
                            DateFormat(" dd MMM yy").format(_termOfUseController
                                .termOfUseModel!.response!.data!.updatedAt!),
                        style: AppTextStyle.grey400Text,
                      )),

                  SizedBox(
                    height: 25 * SizeConfig.heightMultiplier!,
                  ),
                  //all privacy policy
                  ExpandableWidget(
                      title: _termOfUseController
                          .termOfUseModel!.response!.data!.introduction,
                      content: _termOfUseController
                          .termOfUseModel!.response!.data!.description!),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        _termOfUseController.termOfUseModel!.response!.data!
                            .sections!.length, (index) {
                      return ExpandableWidget(
                          title: _termOfUseController.termOfUseModel!.response!
                              .data!.sections![index].title,
                          content: _termOfUseController.termOfUseModel!
                              .response!.data!.sections![index].description);
                    }),
                  ),
                  SizedBox(
                    height: 50 * SizeConfig.heightMultiplier!,
                  ),
                ],
              )));
  }
}
