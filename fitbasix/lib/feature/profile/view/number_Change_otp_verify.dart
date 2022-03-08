import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class NumberChangeOtpVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              color: Theme.of(context).primaryColor,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Transform(
          transform: Matrix4.translationValues(-20, 0, 0),
          child: Text(
            'enter_otp_header'.tr,
            style: AppTextStyle.titleText.copyWith(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                fontSize: 16 * SizeConfig.textMultiplier!),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16 * SizeConfig.widthMultiplier!,
              vertical: 8 * SizeConfig.heightMultiplier!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'enter_Otp'.tr,
                style: AppTextStyle.NormalText.copyWith(
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                    fontSize: 14 * SizeConfig.textMultiplier!),
              ),
              SizedBox(
                height: 16 * SizeConfig.textMultiplier!,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  // _loginController.otp.value = value;
                },
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 48 * SizeConfig.widthMultiplier!,
                  fieldWidth: 48 * SizeConfig.widthMultiplier!,
                  selectedColor: Colors.transparent,
                  activeFillColor: kLightGrey,
                  inactiveColor: Colors.transparent,
                  activeColor: Colors.transparent,
                  inactiveFillColor: kLightGrey,
                  selectedFillColor: kLightGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
