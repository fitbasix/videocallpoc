import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/call_back_form/controller/call_back_controller.dart';
import 'package:fitbasix/feature/call_back_form/services/callBackServices.dart';
import 'package:fitbasix/feature/call_back_form/widget/callBackTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CallBackPage extends StatelessWidget {
  CallBackPage({Key? key}) : super(key: key);

  final _controller = Get.put(CallBackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureBlack,
      appBar: AppBar(
        backgroundColor: kPureBlack,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(
            left: 15.0 * SizeConfig.widthMultiplier!,
            // top: 20.0 * SizeConfig.widthMultiplier!,
            right: 15.0 * SizeConfig.widthMultiplier!,
          ),
          child: SvgPicture.asset(
            ImagePath.logo,
            width: 80 * SizeConfig.widthMultiplier!,
          ),
        ),
      ),
      body: Form(
        key: _controller.key,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 16 * SizeConfig.widthMultiplier!,
                    vertical: 12 * SizeConfig.heightMultiplier!),
                child: Text(
                  'GET A CALL BACK!'.tr,
                  style: AppTextStyle.boldBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 24 * SizeConfig.textMultiplier!),
                ),
              ),
              CallBackField(
                  hintText: "Enter Name".tr,
                  controller: _controller.name,
                  validator: (value) {
                    return value!.trim().isEmpty
                        ? 'Please enter your name'
                        : null;
                  },
                  inputType: TextInputType.name,
                  minLines: 1),
              CallBackField(
                  hintText: "Enter Email ID".tr,
                  controller: _controller.email,
                  validator: (value) {
                    return !GetUtils.isEmail(value!)
                        ? 'Please enter valid email address'
                        : null;
                  },
                  inputType: TextInputType.emailAddress,
                  minLines: 1),
              CallBackField(
                  hintText: "Contact Number".tr,
                  controller: _controller.number,
                  validator: (value) {
                    return !GetUtils.isPhoneNumber(value!)
                        ? 'Please enter valid number'
                        : null;
                  },
                  inputType: TextInputType.phone,
                  minLines: 1),
              CallBackField(
                  hintText: "Ask Your Query".tr,
                  controller: _controller.query,
                  validator: (value) {
                    return value!.trim().isEmpty
                        ? 'Please enter your query'
                        : null;
                  },
                  inputType: TextInputType.multiline,
                  minLines: 4),
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 16 * SizeConfig.widthMultiplier!,
                      vertical: 12 * SizeConfig.heightMultiplier!),
                  child: ProceedButton(
                      title: "Submit",
                      onPressed: _controller.isclicked.value
                          ? () {}
                          : () async {
                              if (_controller.key.currentState!.validate()) {
                                _controller.isclicked.value = true;
                                _controller.callBackResult.value =  
                                    await CallBackServices.sendRequest(
                                        name: _controller.name.text,  
                                        email: _controller.email.text,
                                        number: _controller.number.text,
                                        query: _controller.query.text);
                                _controller.isclicked.value = false;
                                if (_controller.callBackResult.value.code ==
                                    200) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    Get.showSnackbar(const GetSnackBar(
                                      title: "Your Query has been sent.",
                                      backgroundColor: kGreenColor,
                                    ));
                                    Get.back();
                                  });
                                }
                              }
                            }))
            ],
          ),
        ),
      ),
    );
  }
}
