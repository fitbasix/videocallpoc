import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomizedBottomAppBar extends StatefulWidget {
  @override
  final HomeController homeController = Get.put(HomeController());
  State<CustomizedBottomAppBar> createState() => _CustomizedBottomAppBarState();
}

class _CustomizedBottomAppBarState extends State<CustomizedBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomAppBar(
        elevation: 12,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 24 * SizeConfig.widthMultiplier!),
          child: Container(
            height: 64 * SizeConfig.heightMultiplier!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.homeController.selectedIndex.value = 0;
                    });
                  },
                  child: Container(
                    height: 48 * SizeConfig.heightMultiplier!,
                    width: 156 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: widget.homeController.selectedIndex.value == 0
                            ? kGreenColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                      child: Text(
                        'home'.tr,
                        style: widget.homeController.selectedIndex.value == 0
                            ? AppTextStyle.greenSemiBoldText.copyWith(
                                fontSize: 18 * SizeConfig.textMultiplier!,
                                color: kPureWhite)
                            : AppTextStyle.greenSemiBoldText.copyWith(
                                fontSize: 18 * SizeConfig.textMultiplier!),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.homeController.selectedIndex.value = 1;
                    });
                  },
                  child: Container(
                    height: 48 * SizeConfig.heightMultiplier!,
                    width: 156 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: widget.homeController.selectedIndex.value == 1
                            ? kGreenColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                      child: Text('get_a_trained'.tr,
                          style: widget.homeController.selectedIndex.value == 1
                              ? AppTextStyle.greenSemiBoldText.copyWith(
                                  fontSize: 18 * SizeConfig.textMultiplier!,
                                  color: kPureWhite)
                              : AppTextStyle.greenSemiBoldText.copyWith(
                                  fontSize: 18 * SizeConfig.textMultiplier!)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
