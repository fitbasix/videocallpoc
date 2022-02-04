import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AnimatedLiquidCustomProgressIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      AnimatedLiquidCustomProgressIndicatorState();
}

class AnimatedLiquidCustomProgressIndicatorState
    extends State<AnimatedLiquidCustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.find();
  @override
  void initState() {
    super.initState();
    // _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    print(homeController.waterLevel.value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            homeController.waterLevel.value = homeController.waterLevel.value -
                (1 /
                    (homeController.waterDetails.value.response!.data![0]
                            .totalWaterRequired! *
                        4));
            homeController.waterConsumedDataLoading.value = true;
            await HomeService.updateWaterDetails(
                homeController.waterLevel.value *
                    homeController.waterDetails.value.response!.data![0]
                        .totalWaterRequired!);
                        homeController.userProfileData.value = await CreatePostService.getUserProfile();
                        homeController.waterConsumedDataLoading.value=false;
          },
          child: Container(
            width: 27 * SizeConfig.heightMultiplier!,
            height: 27 * SizeConfig.heightMultiplier!,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightGrey,
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 15 * SizeConfig.heightMultiplier!),
              child: Icon(
                Icons.minimize_sharp,
                size: 20 * SizeConfig.heightMultiplier!,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20 * SizeConfig.widthMultiplier!,
        ),
        Obx(() => Center(
              child: SizedBox(
                  width: 56 * SizeConfig.widthMultiplier!,
                  height: 112 * SizeConfig.heightMultiplier!,
                  //padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: LiquidLinearProgressIndicator(
                    value: homeController.waterLevel.value, // Defaults to 0.5.
                    valueColor: const AlwaysStoppedAnimation(Colors
                        .lightBlue), // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors.grey
                        .shade200, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.blueAccent.shade100,
                    borderWidth: 0,
                    borderRadius: 30.0,
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  )),
            )),
        SizedBox(
          width: 20 * SizeConfig.widthMultiplier!,
        ),
        GestureDetector(
          onTap: () async{
            homeController.waterLevel.value = homeController.waterLevel.value +
                (1 /
                    (homeController.waterDetails.value.response!.data![0]
                            .totalWaterRequired! *
                        4));
                        homeController.waterConsumedDataLoading.value = true;
            await HomeService.updateWaterDetails(homeController.waterLevel.value *
                homeController
                    .waterDetails.value.response!.data![0].totalWaterRequired!);
                    homeController.userProfileData.value = await CreatePostService.getUserProfile();
                    homeController.waterConsumedDataLoading.value = false;
          },
          child: Container(
            width: 27 * SizeConfig.heightMultiplier!,
            height: 27 * SizeConfig.heightMultiplier!,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPureBlack,
            ),
            child: Icon(
              Icons.add,
              size: 20 * SizeConfig.heightMultiplier!,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: use_key_in_widget_constructors
class RoundIconButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  RoundIconButton({this.color, this.child, this.onPressed});
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: child,
      onPressed: () {
        onPressed;
      },
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(
          width: 27 * SizeConfig.heightMultiplier!,
          height: 27 * SizeConfig.heightMultiplier!),
      shape: const CircleBorder(),
      fillColor: color,
    );
  }
}
