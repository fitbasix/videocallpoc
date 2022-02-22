import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/help_and_support/controller/help_support_controller.dart';
import 'package:fitbasix/feature/help_and_support/widgets/enpandableWidget.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);
  HelpAndSupportConroller _privacyPolicyController =
      Get.put(HelpAndSupportConroller());

  @override
  Widget build(BuildContext context) {
    if (_privacyPolicyController.privacyPolicyIsLoading.value) {
      _privacyPolicyController.getPrivacyPolicyContent();
    }
    return Scaffold(
        backgroundColor: kPureWhite,
        appBar: AppBarForAccount(
          title: "privacy_policy".tr,
          onback: () {
            Navigator.pop(context);
          },
        ),
        body: Obx(
          () => (_privacyPolicyController.privacyPolicyIsLoading.value)
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
                              DateFormat(" dd MMM yy").format(
                                  _privacyPolicyController.privacyPolicyModel!
                                      .response!.data!.updatedAt!),
                          style: AppTextStyle.grey400Text,
                        )),

                    SizedBox(
                      height: 25 * SizeConfig.heightMultiplier!,
                    ),
                    //all privacy policy
                    ExpandableWidget(
                        title: _privacyPolicyController
                            .privacyPolicyModel!.response!.data!.introduction,
                        content: _privacyPolicyController
                            .privacyPolicyModel!.response!.data!.description!),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          _privacyPolicyController.privacyPolicyModel!.response!
                              .data!.sections!.length, (index) {
                        return ExpandableWidget(
                            title: _privacyPolicyController.privacyPolicyModel!
                                .response!.data!.sections![index].title,
                            content: _privacyPolicyController
                                .privacyPolicyModel!
                                .response!
                                .data!
                                .sections![index]
                                .description);
                      }),
                    ),
                    SizedBox(
                      height: 50 * SizeConfig.heightMultiplier!,
                    ),
                  ],
                ),
        ));
  }
}
