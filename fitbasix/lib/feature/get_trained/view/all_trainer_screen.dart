import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';

class AllTrainerScreen extends StatelessWidget {
  AllTrainerScreen({Key? key}) : super(key: key);

  final TrainerController _trainerController = Get.put(TrainerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {}, icon: SvgPicture.asset(ImagePath.backIcon)),
        title: Text(
          'trainers'.tr,
          style: AppTextStyle.titleText
              .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: kPureBlack,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.only(left: 24 * SizeConfig.widthMultiplier!),
              child: Text(
                'interests'.tr,
                style: AppTextStyle.titleText.copyWith(
                    fontSize: 14 * SizeConfig.textMultiplier!, color: kBlack),
              ),
            ),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            Container(
              height: 28 * SizeConfig.heightMultiplier!,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() => Padding(
                          padding: index == 0
                              ? EdgeInsets.only(
                                  left: 16 * SizeConfig.widthMultiplier!)
                              : EdgeInsets.all(0),
                          child: ItemCategory(
                            onTap: () {
                              _trainerController.isSelected.value =
                                  !_trainerController.isSelected.value;
                            },
                            isSelected: _trainerController.isSelected.value,
                          ),
                        ));
                  }),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            TrainerTile(
              name: 'Benjamin House',
              strength: 'Sports Nutrition',
              strengthCount: 5,
              description:
                  'Hi, This is Jonathan. I am certified by Institute Viverra cras facilisis massa amet hendrerit nun Tristiqu...',
              certifcateTitle: [
                // 'Specialist in Sports Nutrition from ISSA...',
                // 'Specialist in Sports Nutrition from ISSA...'
              ],
              traineeCount: 1235,
              rating: 5,
              numberRated: 234,
            ),
          ],
        ),
      ),
    );
  }
}

class TrainerTile extends StatelessWidget {
  const TrainerTile({
    Key? key,
    required this.name,
    required this.strength,
    required this.strengthCount,
    required this.description,
    required this.certifcateTitle,
    required this.traineeCount,
    required this.rating,
    required this.numberRated,
  }) : super(key: key);

  final String name;
  final String strength;
  final int strengthCount;
  final String description;
  final List<Certificate> certifcateTitle;
  final int traineeCount;
  final double rating;
  final int numberRated;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325 * SizeConfig.heightMultiplier!,
      margin:
          EdgeInsets.symmetric(horizontal: 12 * SizeConfig.widthMultiplier!),
      padding: EdgeInsets.only(top: 16 * SizeConfig.heightMultiplier!),
      decoration: BoxDecoration(
          color: kPureWhite, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12 * SizeConfig.widthMultiplier!),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80 * SizeConfig.heightMultiplier!,
                  height: 80 * SizeConfig.heightMultiplier!,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kPureBlack),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 8 * SizeConfig.heightMultiplier!),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 16 * SizeConfig.textMultiplier!),
                      ),
                      SizedBox(
                        height: 8 * SizeConfig.heightMultiplier!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StrengthTile(text: strength),
                          SizedBox(
                            width: 8 * SizeConfig.widthMultiplier!,
                          ),
                          StrengthTile(text: '+' + strengthCount.toString())
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 12 * SizeConfig.widthMultiplier!,
                right: 12 * SizeConfig.widthMultiplier!),
            child: Text(
              description,
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 12 * SizeConfig.textMultiplier!),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          Container(
            height: 79 * SizeConfig.heightMultiplier!,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: certifcateTitle.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        right: 8.0 * SizeConfig.widthMultiplier!),
                    child: AchivementCertificateTile(
                      certificateDescription: certifcateTitle[index].certificateName!,
                      certificateIcon: certifcateTitle[index].url!,
                      color: index % 2 == 0 ? oceanBlue : lightOrange,
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 12 * SizeConfig.widthMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'trainee'.tr,
                          style: AppTextStyle.titleText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!),
                        ),
                        SizedBox(
                          width: 8 * SizeConfig.widthMultiplier!,
                        ),
                        Text(
                          traineeCount.toString(),
                          style: AppTextStyle.NormalText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ratings'.tr,
                            style: AppTextStyle.titleText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!)),
                        SizedBox(
                          width: 8 * SizeConfig.widthMultiplier!,
                        ),
                        StarRating(
                          rating: rating,
                        ),
                        SizedBox(
                          width: 8 * SizeConfig.widthMultiplier!,
                        ),
                        Text(
                          '($numberRated Rated)',
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  '4',
                  style: AppTextStyle.titleText
                      .copyWith(fontSize: 36, color: kGreenColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12 * SizeConfig.widthMultiplier!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'slotLeft'.tr,
                  style: AppTextStyle.titleText
                      .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }
}

class StrengthTile extends StatelessWidget {
  const StrengthTile({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28 * SizeConfig.heightMultiplier!,
      decoration: BoxDecoration(
          color: offWhite,
          borderRadius:
              BorderRadius.circular(14 * SizeConfig.heightMultiplier!)),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 12 * SizeConfig.widthMultiplier!),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.lightMediumBlackText,
          ),
        ),
      ),
    );
  }
}

class ItemCategory extends StatelessWidget {
  const ItemCategory({
    Key? key,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier!),
      child: Container(
        height: 28 * SizeConfig.heightMultiplier!,
        decoration: BoxDecoration(
            color: isSelected ? kBlack : offWhite,
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
            border: Border.all(
              color: kBlack,
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12 * SizeConfig.widthMultiplier!),
          child: Center(
            child: Text(
              'Fitness Consultant',
              style: AppTextStyle.lightMediumBlackText,
            ),
          ),
        ),
      ),
    );
  }
}
