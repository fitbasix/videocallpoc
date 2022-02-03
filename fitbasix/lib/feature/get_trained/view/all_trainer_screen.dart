import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/number_format.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:shimmer/shimmer.dart';

class AllTrainerScreen extends StatefulWidget {
  AllTrainerScreen({Key? key}) : super(key: key);

  @override
  State<AllTrainerScreen> createState() => _AllTrainerScreenState();
}

class _AllTrainerScreenState extends State<AllTrainerScreen> {
  // int currentPage = 1;
  final TrainerController _trainerController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _trainerController.showLoader.value = true;
        final trainer = _trainerController.trainerType.value == 0
            ? await TrainerServices.getAllTrainer(
                currentPage: _trainerController.currentPage.value,
              )
            : _trainerController.trainerType.value == 1
                ? await TrainerServices.getAllTrainer(
                    currentPage: _trainerController.currentPage.value,
                    trainerType: 1)
                : _trainerController.trainerType.value == 2
                    ? await TrainerServices.getAllTrainer(
                        currentPage: _trainerController.currentPage.value,
                        trainerType: 2)
                    : AllTrainer();
        if (trainer.response!.data!.trainers!.length != 0) {
          if (trainer.response!.data!.trainers!.length < 5) {
            for (int i = 0; i < trainer.response!.data!.trainers!.length; i++) {
              _trainerController.allTrainer.value.response!.data!.trainers!
                  .add(trainer.response!.data!.trainers![i]);
            }
            //return;
          } else {
            for (int i = 0; i < trainer.response!.data!.trainers!.length; i++) {
              _trainerController.allTrainer.value.response!.data!.trainers!
                  .add(trainer.response!.data!.trainers![i]);
            }
          }
        }
        _trainerController.currentPage.value++;
        _trainerController.showLoader.value = false;

        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _trainerController.isSearchActive.value = false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPureWhite,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  ImagePath.backIcon,
                  width: 7 * SizeConfig.widthMultiplier!,
                  height: 12 * SizeConfig.heightMultiplier!,
                )),
            title: Obx(() => _trainerController.isSearchActive.value
                ? Transform(
                    transform: Matrix4.translationValues(
                        -20 * SizeConfig.widthMultiplier!, 0, 0),
                    child: Container(
                      height: 32 * SizeConfig.heightMultiplier!,
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _trainerController.searchController,
                          style: AppTextStyle.smallGreyText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kBlack),
                          onChanged: (value) async {
                            if (_trainerController.search.value != value) {
                              _trainerController.search.value = value;
                              if (value.length >= 3) {
                                _trainerController.filterIsLoading.value = true;
                                _trainerController.searchedName.value = value;
                                _trainerController.allTrainer.value =
                                    await TrainerServices.getAllTrainer(
                                  name: value,
                                  interests: _trainerController
                                      .SelectedInterestIndex.value,
                                  trainerType:
                                      _trainerController.trainerType.value,
                                );
                                _scrollController.jumpTo(0);
                                _trainerController.filterIsLoading.value =
                                    false;
                              }
                              if (value.length == 0) {
                                _trainerController.filterIsLoading.value = true;
                                _trainerController.searchedName.value = value;
                                _trainerController.allTrainer.value =
                                    await TrainerServices.getAllTrainer(
                                  name: value,
                                  interests: _trainerController
                                      .SelectedInterestIndex.value,
                                  trainerType:
                                      _trainerController.trainerType.value,
                                );
                                _scrollController.jumpTo(0);
                                _trainerController.filterIsLoading.value =
                                    false;
                              }
                            }
                          },
                          // onSubmitted: (value) async {
                          //   if (value.length >= 3) {
                          //     _trainerController.filterIsLoading.value = true;
                          //     _trainerController.searchedName.value = value;
                          //     _trainerController.allTrainer.value =
                          //         await TrainerServices.getAllTrainer(
                          //             name: value,
                          //             interests: _trainerController
                          //                 .SelectedInterestIndex.value,
                          //             trainerType:
                          //                 _trainerController.trainerType.value);
                          //
                          //     _scrollController.jumpTo(0);
                          //     _trainerController.filterIsLoading.value = false;
                          //   } else {
                          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //         content:
                          //             Text('Please enter atleast 3 character')));
                          //   }
                          // },
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.5 * SizeConfig.widthMultiplier!,
                                  right: 5),
                              child: Icon(
                                Icons.search,
                                color: hintGrey,
                                size: 22 * SizeConfig.heightMultiplier!,
                              ),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _trainerController
                                            .searchController.text.length ==
                                        0
                                    ? _trainerController.isSearchActive.value =
                                        false
                                    : _trainerController.searchController
                                        .clear();
                              },
                              child: Icon(
                                Icons.clear,
                                color: hintGrey,
                                size: 18 * SizeConfig.heightMultiplier!,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: 'searchHint'.tr,
                            hintStyle: AppTextStyle.smallGreyText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                color: hintGrey),
                            /*contentPadding: EdgeInsets.only(
                                top: -2,
                              )*/
                          ),
                        ),
                      ),
                    ),
                  )
                : Transform(
                    transform: Matrix4.translationValues(-20, 0, 0),
                    child: Text(
                      _trainerController.pageTitle.value,
                      style: AppTextStyle.titleText
                          .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
                    ),
                  )),
            actions: [
              Obx(() => _trainerController.isSearchActive.value
                  ? SizedBox()
                  : IconButton(
                      onPressed: () {
                        _trainerController.isSearchActive.value = true;
                      },
                      icon: Icon(
                        Icons.search,
                        color: kPureBlack,
                        size: 25 * SizeConfig.heightMultiplier!,
                      )))
            ],
          ),
          body: SafeArea(
              child: Stack(
            children: [
              SingleChildScrollView(
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
                            for (int i = 0;
                                i <
                                    _trainerController.interests.value.response!
                                        .response!.data!.length;
                                i++) {
                              _trainerController.interestSelection.add(false);
                            }
                            return Obx(() => _trainerController.isLoading.value
                                ? Shimmer.fromColors(
                                    child: ItemCategory(
                                        interest: _trainerController
                                            .interests
                                            .value
                                            .response!
                                            .response!
                                            .data![index]
                                            .name!,
                                        onTap: () {},
                                        isSelected: false),
                                    baseColor:
                                        const Color.fromRGBO(230, 230, 230, 1),
                                    highlightColor:
                                        const Color.fromRGBO(242, 245, 245, 1),
                                  )
                                : Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            left: 16 *
                                                SizeConfig.widthMultiplier!)
                                        : EdgeInsets.all(0),
                                    child: ItemCategory(
                                      onTap: () async {
                                        _trainerController
                                            .filterIsLoading.value = true;
                                        _trainerController.SelectedInterestIndex
                                            .value = index;

                                        _trainerController
                                            .UpdatedInterestStatus(
                                                _trainerController
                                                    .SelectedInterestIndex
                                                    .value);

                                        _trainerController.allTrainer.value =
                                            await TrainerServices.getAllTrainer(
                                                interests: _trainerController
                                                    .interests
                                                    .value
                                                    .response!
                                                    .response!
                                                    .data![index]
                                                    .serialId);
                                        _trainerController.currentPage.value =
                                            1;
                                        _trainerController
                                            .filterIsLoading.value = false;
                                      },
                                      isSelected: _trainerController
                                                  .SelectedInterestIndex
                                                  .value ==
                                              index
                                          ? true
                                          : false,
                                      interest: _trainerController
                                          .interests
                                          .value
                                          .response!
                                          .response!
                                          .data![index]
                                          .name!,
                                    ),
                                  ));
                          }),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    // _trainerController.filterIsLoading.value
                    //     ? Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           SizedBox(
                    //             height: 200,
                    //           ),
                    //           Center(
                    //             child: CustomizedCircularProgress(),
                    //           ),
                    //           // Spacer()
                    //         ],
                    //       )
                    Obx(() => _trainerController.filterIsLoading.value ||
                            _trainerController.isLoading.value
                        ? Container(
                            // height: Get.height,
                            child: ListView.builder(
                                itemCount: 2,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Shimmer.fromColors(
                                    child: TrainerTile(
                                      name: '',
                                      strength: '',
                                      strengthCount: 0,
                                      description: '',
                                      certifcateTitle: [],
                                      traineeCount: 0,
                                      rating: 0,
                                      numberRated: 0,
                                      profilePhoto:
                                          'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg',
                                      slotLeft: 0,
                                      onTap: () {},
                                    ),
                                    baseColor:
                                        const Color.fromRGBO(230, 230, 230, 1),
                                    highlightColor:
                                        const Color.fromRGBO(242, 245, 245, 1),
                                  );
                                }),
                          )
                        : Container(
                            // height: Get.height,
                            child: ListView.builder(
                                itemCount: _trainerController.allTrainer.value
                                            .response!.data!.trainers!.length ==
                                        0
                                    ? 0
                                    : _trainerController.allTrainer.value
                                        .response!.data!.trainers!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  print(_trainerController
                                      .allTrainer
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .certificates!
                                      .length);
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
                                        .strength![0]
                                        .name
                                        .toString(),
                                    strengthCount: _trainerController
                                            .allTrainer
                                            .value
                                            .response!
                                            .data!
                                            .trainers![index]
                                            .strength!
                                            .length -
                                        1,
                                    description: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .about!,
                                    certifcateTitle: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .certificates!,
                                    traineeCount: int.tryParse(
                                        _trainerController
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
                                    onTap: () async {
                                      _trainerController.atrainerDetail.value =
                                          _trainerController.allTrainer.value
                                              .response!.data!.trainers![index];
                                      Navigator.pushNamed(context,
                                          RouteName.trainerProfileScreen);
                                      _trainerController
                                          .isProfileLoading.value = true;
                                      // await TrainerServices.getATrainerDetail(
                                      //     _trainerController
                                      //         .allTrainer
                                      //         .value
                                      //         .response!
                                      //         .data!
                                      //         .trainers![index]
                                      //         .user!
                                      //         .id!);
                                      _trainerController.planModel.value =
                                          await TrainerServices
                                              .getPlanByTrainerId(
                                                  _trainerController
                                                      .allTrainer
                                                      .value
                                                      .response!
                                                      .data!
                                                      .trainers![index]
                                                      .user!
                                                      .id!);
                                      _trainerController.initialPostData.value =
                                          await TrainerServices.getTrainerPosts(
                                              _trainerController
                                                  .allTrainer
                                                  .value
                                                  .response!
                                                  .data!
                                                  .trainers![index]
                                                  .user!
                                                  .id!);
                                      _trainerController
                                          .isProfileLoading.value = false;
                                    },
                                  );
                                }),
                          )),
                  ],
                ),
              ),
              Obx(() => _trainerController.showLoader.value
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomizedCircularProgress(),
                      ))
                  : Container())
            ],
          )),
        ),
      ),
    );
  }
}

class TrainerTile extends StatelessWidget {
  final TrainerController _trainerController = Get.find();
  TrainerTile({
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
    required this.onTap,
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: certifcateTitle!.isEmpty
        //     ? 246 * SizeConfig.heightMultiplier!
        //     : 325 * SizeConfig.heightMultiplier!,
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
                            strengthCount != 0
                                ? StrengthTile(
                                    text: '+' + strengthCount.toString())
                                : Container()
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
                            NumberFormatter.textFormatter(
                                traineeCount.toString()),
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
                            '(' +
                                'rated_count'.trParams({
                                  "count": NumberFormatter.textFormatter(
                                      numberRated.toString())
                                }) +
                                ')',
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        slotLeft.toString(),
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 36,
                            color: slotLeft >=
                                    _trainerController.slotsLeftLimit.value
                                ? kGreenColor
                                : kRed),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'slotLeft'.tr,
                            style: AppTextStyle.titleText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            )
          ],
        ),
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
