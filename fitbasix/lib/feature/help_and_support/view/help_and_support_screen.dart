import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/help_and_support/controller/help_support_controller.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

import '../../../core/constants/color_palette.dart';
import '../../Home/controller/Home_Controller.dart';
import '../model/help_support_model.dart';
import '../services/help_and_support_services.dart';
import '../widgets/enpandableWidget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatelessWidget {
  HelpAndSupportScreen({Key? key}) : super(key: key);
  HelpAndSupportConroller _helpAndSupportController =
      Get.put(HelpAndSupportConroller());
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (_helpAndSupportController.isLoading.value) {
      _helpAndSupportController.getAllHelpAndSupportContent();
    }

    return Scaffold(
        backgroundColor: kPureWhite,
        appBar: AppBarForAccount(
          title: "help_support".tr,
          onback: () {
            _homeController.selectedIndex.value = 0;
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        body: Obx(
          () => _helpAndSupportController.isLoading.value
              ? Center(child: CustomizedCircularProgress())
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    //whatsapp and call buttons
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16 * SizeConfig.widthMultiplier!,
                          vertical: 16 * SizeConfig.heightMultiplier!),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _helpAndSupportController.helpAndSupportDataModel!
                                .response!.data!.description!,
                            style: AppTextStyle.black400Text,
                          ),
                          SizedBox(
                            height: 16 * SizeConfig.heightMultiplier!,
                          ),
                          Row(
                            children: [
                              //whatsapp button
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    launch(
                                        "https://Wa.me/${_helpAndSupportController.helpAndSupportDataModel!.response!.data!.whatsAppNo}");
                                  },
                                  child: Container(
                                    height: 48 * SizeConfig.heightMultiplier!,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8 * SizeConfig.widthMultiplier!),
                                        color: kGreenColor),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        ImagePath.whatsAppIcon,
                                        height: 24 *
                                            SizeConfig.imageSizeMultiplier!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16 * SizeConfig.widthMultiplier!,
                              ),
                              //call button
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    ///launch call with help no
                                    launch(
                                        "tel://${_helpAndSupportController.helpAndSupportDataModel!.response!.data!.callingNo}");
                                  },
                                  child: Container(
                                    height: 48 * SizeConfig.heightMultiplier!,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8 * SizeConfig.widthMultiplier!),
                                        color: kGreenColor),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        ImagePath.phoneCallIcon,
                                        height: 26 *
                                            SizeConfig.imageSizeMultiplier!,
                                        width: 26 *
                                            SizeConfig.imageSizeMultiplier!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 16 * SizeConfig.heightMultiplier!,
                      color: kLightGrey,
                    ),
                    SizedBox(
                      height: 24 * SizeConfig.heightMultiplier!,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 16 * SizeConfig.widthMultiplier!,
                            bottom: 16 * SizeConfig.heightMultiplier!),
                        child: Text(
                          "FAQs".tr,
                          style: AppTextStyle.boldBlackText,
                        )),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            _helpAndSupportController
                                .helpAndSupportDataModel!
                                .response!
                                .data!
                                .questionsAndAnswers!
                                .length, (FAQIndex) {
                          return ExpandableWidget(
                            title: _helpAndSupportController
                                .helpAndSupportDataModel!
                                .response!
                                .data!
                                .questionsAndAnswers![FAQIndex]
                                .question,
                            content: _helpAndSupportController
                                .helpAndSupportDataModel!
                                .response!
                                .data!
                                .questionsAndAnswers![FAQIndex]
                                .answer,
                          );
                        }))
                  ],
                ),
        ));
  }
}
