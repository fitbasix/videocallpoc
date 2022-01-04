import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';

class AllTrainerScreen extends StatefulWidget {
  AllTrainerScreen({Key? key}) : super(key: key);

  @override
  State<AllTrainerScreen> createState() => _AllTrainerScreenState();
}

class _AllTrainerScreenState extends State<AllTrainerScreen> {
  int currentPage = 1;
  final TrainerController _trainerController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final trainer =
            await TrainerServices.getAllTrainer(currentPage: currentPage);
        if (trainer.response!.data!.trainers!.length < 5) {
          for (int i = 0; i < trainer.response!.data!.trainers!.length; i++) {
            _trainerController.allTrainer.value.response!.data!.trainers!
                .add(trainer.response!.data!.trainers![i]);
          }
          return;
        } else {
          for (int i = 0; i < trainer.response!.data!.trainers!.length; i++) {
            _trainerController.allTrainer.value.response!.data!.trainers!
                .add(trainer.response!.data!.trainers![i]);
          }
        }

        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(ImagePath.backIcon)),
        title: Transform(
          transform: Matrix4.translationValues(
              -20 * SizeConfig.widthMultiplier!, 0, 0),
          child: Text(
            _trainerController.pageTitle.value,
            style: AppTextStyle.titleText
                .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
          ),
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
        child: Obx(() => _trainerController.isLoading.value
            ? Center(
                child: CustomizedCircularProgress(),
              )
            : SingleChildScrollView(
                // physics: ScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24 * SizeConfig.heightMultiplier!,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24 * SizeConfig.widthMultiplier!),
                      child: Text(
                        'interests'.tr,
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color: kBlack),
                      ),
                    ),
                    SizedBox(
                      height: 12 * SizeConfig.heightMultiplier!,
                    ),
                    Container(
                      height: 28 * SizeConfig.heightMultiplier!,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _trainerController
                              .interests.value.response!.response!.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            for (int i = 0; i < 5; i++) {
                              _trainerController.interestSelection.add(false);
                            }
                            return Obx(() => Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              16 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: ItemCategory(
                                    onTap: () {
                                      _trainerController
                                          .SelectedInterestIndex.value = index;

                                      _trainerController.UpdatedInterestStatus(
                                          index);
                                    },
                                    isSelected: _trainerController
                                        .interestSelection[index],
                                    interest: _trainerController.interests.value
                                        .response!.response!.data![index].name!,
                                  ),
                                ));
                          }),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Container(
                      // height: Get.height,
                      child: ListView.builder(
                          itemCount: _trainerController.allTrainer.value
                              .response!.data!.trainers!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return TrainerTile(
                              name: _trainerController
                                          .allTrainer
                                          .value
                                          .response!
                                          .data!
                                          .trainers![index]
                                          .user !=
                                      null
                                  ? _trainerController
                                          .allTrainer
                                          .value
                                          .response!
                                          .data!
                                          .trainers![index]
                                          .user!
                                          .name ??
                                      ''
                                  : '',
                              strength: _trainerController
                                  .allTrainer
                                  .value
                                  .response!
                                  .data!
                                  .trainers![index]
                                  .strength![0],
                              strengthCount: _trainerController
                                      .allTrainer
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .strength!
                                      .length -
                                  1,
                              description: _trainerController.allTrainer.value
                                  .response!.data!.trainers![index].about!,
                              certifcateTitle: _trainerController
                                  .allTrainer
                                  .value
                                  .response!
                                  .data!
                                  .trainers![index]
                                  .certificates!,
                              traineeCount: int.tryParse(_trainerController
                                  .allTrainer
                                  .value
                                  .response!
                                  .data!
                                  .trainers![index]
                                  .trainees!)!,
                              rating: double.tryParse(_trainerController
                                  .allTrainer
                                  .value
                                  .response!
                                  .data!
                                  .trainers![index]
                                  .rating!)!,
                              numberRated: int.tryParse(_trainerController
                                  .allTrainer
                                  .value
                                  .response!
                                  .data!
                                  .trainers![index]
                                  .totalRating!)!,
                              profilePhoto: _trainerController
                                          .allTrainer
                                          .value
                                          .response!
                                          .data!
                                          .trainers![index]
                                          .user !=
                                      null
                                  ? _trainerController
                                          .allTrainer
                                          .value
                                          .response!
                                          .data!
                                          .trainers![index]
                                          .user!
                                          .profilePhoto ??
                                      ''
                                  : 'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg',
                              slotLeft: int.tryParse(_trainerController
                                  .allTrainer
                                  .value
                                  .response!
                                  .data!
                                  .trainers![index]
                                  .slotsFeft!)!,
                            );
                          }),
                    ),
                  ],
                ),
              )),
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
    required this.profilePhoto,
    required this.rating,
    required this.numberRated,
    required this.slotLeft,
  }) : super(key: key);

  final String name;
  final String strength;
  final int strengthCount;
  final String description;
  final List<Certificate>? certifcateTitle;
  final int traineeCount;
  final String profilePhoto;
  final double rating;
  final int numberRated;
  final int slotLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: certifcateTitle!.isEmpty
          ? 246 * SizeConfig.heightMultiplier!
          : 325 * SizeConfig.heightMultiplier!,
      margin: EdgeInsets.only(
          left: 12 * SizeConfig.widthMultiplier!,
          right: 12 * SizeConfig.widthMultiplier!,
          bottom: 16 * SizeConfig.heightMultiplier!),
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
                      profilePhoto,
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
          certifcateTitle!.isEmpty
              ? Container()
              : Container(
                  height: 79 * SizeConfig.heightMultiplier!,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: certifcateTitle!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: 8.0 * SizeConfig.widthMultiplier!),
                          child: AchivementCertificateTile(
                            certificateDescription:
                                certifcateTitle![index].certificateName!,
                            certificateIcon: certifcateTitle![index].url!,
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
                Padding(
                  padding:
                      EdgeInsets.only(right: 16 * SizeConfig.widthMultiplier!),
                  child: Text(
                    slotLeft.toString(),
                    style: AppTextStyle.titleText
                        .copyWith(fontSize: 36, color: kGreenColor),
                  ),
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
    required this.interest,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);
  final String interest;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier!),
      child: GestureDetector(
        onTap: onTap,
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
                interest,
                style: AppTextStyle.lightMediumBlackText
                    .copyWith(color: isSelected ? offWhite : kBlack),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
