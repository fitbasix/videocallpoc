import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/trainer_card.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class GetTrainedScreen extends StatelessWidget {
  const GetTrainedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CustomAppBar(titleOfModule: 'getTrainedTitle'.tr),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      backgroundColor: kGreyBackground,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: 27 * SizeConfig.heightMultiplier!,
              bottom: 69 * SizeConfig.heightMultiplier!),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12 * SizeConfig.widthMultiplier!),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImagePath.getTrainerIcon),
                    SizedBox(
                      width: 7 * SizeConfig.widthMultiplier!,
                    ),
                    GetTrainedTitle(
                      title: 'getTrainer'.tr,
                    ),
                    Spacer(),
                    SeeAllButton(
                      onTap: () {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 19 * SizeConfig.heightMultiplier!,
              ),
              Container(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(
                                left: 12 * SizeConfig.widthMultiplier!)
                            : EdgeInsets.all(0),
                        child: TrainerCard(
                          name: 'Jonathan Swift',
                          certificateCount: '3',
                          rating: 5,
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 39,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12 * SizeConfig.widthMultiplier!),
                child: Row(
                  children: [
                    SvgPicture.asset(ImagePath.getFitnessConsultationIcon),
                    SizedBox(
                      width: 7 * SizeConfig.widthMultiplier!,
                    ),
                    GetTrainedTitle(
                      title: 'getFitnessConsult'.tr,
                    ),
                    Spacer(),
                    SeeAllButton(
                      onTap: () {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 19 * SizeConfig.heightMultiplier!,
              ),
              Container(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(
                                left: 12 * SizeConfig.widthMultiplier!)
                            : EdgeInsets.all(0),
                        child: TrainerCard(
                          name: 'Jonathan Swift',
                          certificateCount: '3',
                          rating: 5,
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 39,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12 * SizeConfig.widthMultiplier!),
                child: Row(
                  children: [
                    SvgPicture.asset(ImagePath.getNutritionConsultationIcon),
                    SizedBox(
                      width: 7 * SizeConfig.widthMultiplier!,
                    ),
                    GetTrainedTitle(
                      title: 'getNutritionConsult'.tr,
                    ),
                    Spacer(),
                    SeeAllButton(
                      onTap: () {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 19 * SizeConfig.heightMultiplier!,
              ),
              Container(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(
                                left: 12 * SizeConfig.widthMultiplier!)
                            : EdgeInsets.all(0),
                        child: TrainerCard(
                          name: 'Jonathan Swift',
                          certificateCount: '3',
                          rating: 5,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class GetTrainedTitle extends StatelessWidget {
  const GetTrainedTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.titleText
          .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
    );
  }
}

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(
          'seeAll'.tr,
          style: AppTextStyle.NormalText.copyWith(
              fontSize: 14 * SizeConfig.textMultiplier!,
              decoration: TextDecoration.underline,
              color: kGreyText),
        ));
  }
}
