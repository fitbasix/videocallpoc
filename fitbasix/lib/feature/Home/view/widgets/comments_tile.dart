import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/controller/individual_user_controller.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:readmore/readmore.dart';

class CommentsTile extends StatefulWidget {
  CommentsTile({
    Key? key,
    required this.name,
    required this.comment,
    required this.time,
    required this.likes,
    required this.profilePhoto,
    required this.onReply,
    required this.onLikeComment,
    this.replyCount,
    required this.minWidth,
    required this.taggedPersonName,
    required this.maxWidth,
    required this.userId,
  }) : super(key: key);

  final String name;
  final String comment;
  final String taggedPersonName;
  final String time;
  int likes;
  final String profilePhoto;
  final VoidCallback onReply;
  final VoidCallback onLikeComment;
  final int? replyCount;
  final double minWidth;
  final double maxWidth;
  final String userId;

  @override
  State<CommentsTile> createState() => _CommentsTileState();
}

class _CommentsTileState extends State<CommentsTile> {
  bool showAll = false;
  final int length = 50;
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16 * SizeConfig.widthMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () async {
                final result = await HomeService.getIndividualUserProfileData(
                    userId: widget.userId);
                if (result.response!.data!.profile!.role == "user") {
                  print("HI");
                  gotoIndividualUserPage(result, widget.userId);
                } else {
                  print("Nope");
                  gotoIndividualPage(null, widget.userId);
                }
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    CachedNetworkImageProvider(widget.profilePhoto),
              )),
          SizedBox(
            width: 8 * SizeConfig.widthMultiplier!,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: 84 * SizeConfig.heightMultiplier!,
                  width: double.infinity,
                  // constraints: BoxConstraints(
                  //     minWidth: widget.minWidth, maxWidth: widget.maxWidth),
                  padding: EdgeInsets.only(
                      top: 12 * SizeConfig.heightMultiplier!,
                      left: 12 * SizeConfig.widthMultiplier!,
                      right: 12 * SizeConfig.widthMultiplier!,
                      bottom: 16 * SizeConfig.heightMultiplier!),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name.capitalize!,
                        style: AppTextStyle.boldBlackText.copyWith(
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize: 12 * SizeConfig.textMultiplier!),
                      ),
                      SizedBox(
                        height: 8 * SizeConfig.heightMultiplier!,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: widget.taggedPersonName,
                            style: AppTextStyle.boldBlackText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                color: kGreenColor)),
                        TextSpan(text: ' '),
                        TextSpan(
                            text: widget.comment.length > length && !showAll
                                ? widget.comment.substring(0, length) + '...'
                                : widget.comment,
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 14 * SizeConfig.textMultiplier!)),
                        widget.comment.length > length
                            ? WidgetSpan(
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAll = !showAll;
                                  });
                                },
                                child: Text(
                                    showAll
                                        ? ' ' + 'see_less'.tr
                                        : ' ' + 'see_more'.tr,
                                    style: AppTextStyle.normalBlackText
                                        .copyWith(
                                            fontSize:
                                                12 * SizeConfig.textMultiplier!,
                                            color: hintGrey)),
                              ))
                            : TextSpan()
                      ])),
                      // ReadMoreText(
                      //   widget.comment,
                      //   trimLines: 2,
                      //   trimMode: TrimMode.Line,
                      //   trimCollapsedText: 'see_more'.tr,
                      //   trimExpandedText: 'see_less'.tr,
                      //   colorClickableText: hintGrey,
                      //   style: AppTextStyle.normalBlackText
                      //       .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                      // )
                      // Text(
                      //   comment,
                      //   style: AppTextStyle.normalBlackText
                      //       .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8 * SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier!),
                  child: Row(
                    children: [
                      Text(widget.time,
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!,
                              color: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.color)),
                      SizedBox(
                        width: 13 * SizeConfig.widthMultiplier!,
                      ),
                      InkWell(
                        onTap: widget.onLikeComment,
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                              right: 5 * SizeConfig.widthMultiplier!),
                          child: Icon(
                            Icons.favorite,
                            color: Theme.of(context).textTheme.headline6?.color,
                            size: 14 * SizeConfig.heightMultiplier!,
                          ),
                        ),
                      ),
                      Text(
                          'likes'
                              .trParams({'no_likes': widget.likes.toString()}),
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!,
                              color: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.color)),
                      SizedBox(
                        width: 13 * SizeConfig.widthMultiplier!,
                      ),
                      Icon(
                        Icons.reply,
                        color: Theme.of(context).textTheme.headline6?.color,
                        size: 18 * SizeConfig.heightMultiplier!,
                      ),
                      SizedBox(
                        width: 4 * SizeConfig.widthMultiplier!,
                      ),
                      GestureDetector(
                        onTap: widget.onReply,
                        child: Text('reply'.tr,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.color)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void gotoIndividualUserPage(final index, String userId) async {
    final IndividualUserController _individualUserController =
        Get.put(IndividualUserController());
    _homeController.individualUserProfileData.value = UserProfileModel();
    _homeController.isIndividualUserProfileLoading.value = true;
    Navigator.pushNamed(context, RouteName.individualUserProfileScreen);
    var result = index;
    if (result.response != null) {
      _homeController.individualUserProfileData.value = result;
    }
    _homeController.isIndividualUserProfileLoading.value = false;
    _homeController.isLoading.value = true;
    var response = await HomeService.getIndividualUserPosts(userId, 0);
    _individualUserController.userPostList.value = response.response!.data!;
    if (response.response!.data!.isNotEmpty) {
      _individualUserController.userPostList.value = response.response!.data!;
    } else {
      _individualUserController.userPostList.clear();
    }
    _homeController.isLoading.value = false;
  }

  void gotoIndividualPage(int? index, String trainerId) async {
    TrainerController _trainerController = Get.find();
    if (true) {
      _trainerController.atrainerDetail.value = Trainer();

      _trainerController.isProfileLoading.value = true;
      _trainerController.isMyTrainerProfileLoading.value = true;
      Navigator.pushNamed(context, RouteName.trainerProfileScreen);

      var result = await TrainerServices.getATrainerDetail(trainerId);
      if (result.response!.data != null) {
        _trainerController.atrainerDetail.value = result.response!.data!;
      }

      _trainerController.planModel.value =
          await TrainerServices.getPlanByTrainerId(
              trainerId, _trainerController.currentPlanType);

      _trainerController.initialPostData.value =
          await TrainerServices.getTrainerPosts(trainerId, 0);
      _trainerController.isMyTrainerProfileLoading.value = false;
      _trainerController.loadingIndicator.value = false;
      if (_trainerController.initialPostData.value.response!.data!.isNotEmpty) {
        _trainerController.trainerPostList.value =
            _trainerController.initialPostData.value.response!.data!;
      } else {
        _trainerController.trainerPostList.clear();
      }
      _trainerController.isProfileLoading.value = false;
      _trainerController.isMyTrainerProfileLoading.value = false;
    }
  }
}
