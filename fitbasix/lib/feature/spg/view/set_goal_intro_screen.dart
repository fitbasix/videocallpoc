import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shimmer/shimmer.dart';

class SetGoalIntroScreen extends StatelessWidget {
  SetGoalIntroScreen({Key? key}) : super(key: key);
  final SPGController _spgController = Get.put(SPGController());

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
      ),
      body: SafeArea(
          child: Container(
        margin:
            EdgeInsets.symmetric(vertical: 16 * SizeConfig.heightMultiplier!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90 * SizeConfig.heightMultiplier!,
            ),
            Obx(() => _spgController.isLoading.value
                ? Shimmer.fromColors(
                    child: Container(
                      color: kGreyColor,
                      width: double.infinity,
                      height: 280 * SizeConfig.heightMultiplier!,
                    ),
                    baseColor: const Color.fromRGBO(230, 230, 230, 1),
                    highlightColor: const Color.fromRGBO(242, 245, 245, 1),
                  )
                : CachedNetworkImage(
                    imageUrl: _spgController
                        .spgData.value.response!.data!.setGoalIntroImage!,
                    height: 280 * SizeConfig.heightMultiplier!,
                    fit: BoxFit.fitWidth,
                  )),
            SizedBox(
              height: 26 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 32 * SizeConfig.widthMultiplier!),
              child: Text(
                'set_goal_intro_text'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyle.normalBlackText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 25 * SizeConfig.widthMultiplier!),
              child: ProceedButton(
                  title: 'proceed'.tr,
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SetGoalScreen()));
                  }),
            )
          ],
        ),
      )),
    );
  }
}
