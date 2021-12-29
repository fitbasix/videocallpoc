import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 243 * SizeConfig.heightMultiplier!,
                  ),
                  Text(
                    'Jonathan Swift',
                    style: AppTextStyle.titleText
                        .copyWith(fontSize: 18 * SizeConfig.textMultiplier!),
                  ),
                  SizedBox(
                    height: 12 * SizeConfig.heightMultiplier!,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        title: 'follow'.tr,
                        onPress: () {},
                      ),
                      SizedBox(
                        width: 12 * SizeConfig.widthMultiplier!,
                      ),
                      CustomButton(title: 'message'.tr, onPress: () {})
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 177 * SizeConfig.heightMultiplier!,
              child: Image.asset(
                ImagePath.trainerCoverImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 127 * SizeConfig.heightMultiplier!,
              left: Get.width / 2 - 50,
              child: Container(
                height: 100,
                child: CircleAvatar(
                  radius: 50 * SizeConfig.heightMultiplier!,
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg'),
                ),
              ),
            ),

            //To be docked at bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person_add,
                          color: kGreenColor,
                        ),
                        label: Text(
                          'follow'.tr,
                          style: AppTextStyle.titleText.copyWith(
                              fontSize: 18 * SizeConfig.textMultiplier!,
                              color: kGreenColor),
                        )),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Enroll Now',
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 18 * SizeConfig.textMultiplier!,
                            color: kPureWhite),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: kGreenColor,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 28 * SizeConfig.heightMultiplier!,
        width: 102 * SizeConfig.widthMultiplier!,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(title),
          style: ElevatedButton.styleFrom(primary: kGreenColor),
        ));
  }
}
