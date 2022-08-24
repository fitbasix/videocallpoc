import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/video_player.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/report_abuse/report_abuse_controller.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/widgets/comments_tile.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/constants/image_path.dart';
import '../../../../core/universal_widgets/customized_circular_indicator.dart';

class ExplorePostTile extends StatefulWidget {
  ExplorePostTile(
      {Key? key,
      required this.name,
      required this.profilePhoto,
      required this.imageUrl,
      required this.category,
      required this.date,
      required this.place,
      required this.caption,
      required this.likes,
      required this.hitLike,
      required this.isLiked,
      required this.comments,
      required this.addComment,
      required this.postId,
      required this.onTap,
      required this.people,
      required this.isMe,
      this.userID,
      required this.isFollowing})
      : super(key: key);
  final String name;
  final String profilePhoto;
  final List<String> imageUrl;
  final String category;
  final String date;
  final String place;
  final String caption;
  final String likes;
  final VoidCallback hitLike;
  final bool isLiked;
  final String comments;
  final VoidCallback addComment;
  final String postId;
  final VoidCallback onTap;
  final List<Person> people;
  final bool isFollowing;
  final String? userID;
  final bool isMe;

  @override
  State<ExplorePostTile> createState() => _ExplorePostTileState();
}

class _ExplorePostTileState extends State<ExplorePostTile> {
  final HomeController _homeController = Get.find();
  final PostController _postController = Get.find();
  final ReportAbuseController _reportAbuseController = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  bottom: 16 * SizeConfig.heightMultiplier!,
                  // right: 16 * SizeConfig.heightMultiplier!,
                  top: 16 * SizeConfig.heightMultiplier!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20 * SizeConfig.widthMultiplier!,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.profilePhoto),
                  ),
                  SizedBox(
                    width: 12 * SizeConfig.widthMultiplier!,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.people.length == 0
                          ? Row(
                              children: [
                                Text(
                                  widget.name,
                                  style: AppTextStyle.boldBlackText.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontSize:
                                          14 * SizeConfig.textMultiplier!),
                                ),
                                SizedBox(
                                    width: 12 * SizeConfig.widthMultiplier!),
                                widget.isFollowing
                                    ? Container(
                                        height:
                                            4 * SizeConfig.heightMultiplier!,
                                        width: 4 * SizeConfig.widthMultiplier!,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle),
                                      )
                                    : Container(),
                                SizedBox(
                                    width: 12 * SizeConfig.widthMultiplier!),
                                widget.isFollowing
                                    ? Text(
                                        'follow'.tr,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                color: kgreen49,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    : Container()
                              ],
                            )
                          : widget.people.length == 1
                              ? Container(
                                  width: 248 * SizeConfig.widthMultiplier!,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        widget.name,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Container(
                                        height:
                                            1 * SizeConfig.heightMultiplier!,
                                        width: 15 * SizeConfig.widthMultiplier!,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text('with'.tr,
                                          style: AppTextStyle.normalGreenText
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.color)),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        widget.people[0].name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 248 * SizeConfig.widthMultiplier!,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        widget.name,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Container(
                                        height:
                                            1 * SizeConfig.heightMultiplier!,
                                        width: 15 * SizeConfig.widthMultiplier!,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'with'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        widget.people[0].name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'and'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      Text(
                                        'others'.trParams({
                                          "no_people":
                                              (widget.people.length - 1)
                                                  .toString()
                                        }),
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                ),
                      Row(
                        children: [
                          Text(widget.category,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.textMultiplier!,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.color)),
                          SizedBox(
                            width: 13 * SizeConfig.widthMultiplier!,
                          ),
                          Icon(Icons.access_time,
                              size: 16 * SizeConfig.textMultiplier!,
                              color:
                                  Theme.of(context).textTheme.headline3?.color),
                          SizedBox(
                            width: 5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(widget.date,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.widthMultiplier!,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.color)),
                          SizedBox(
                            width: 14 * SizeConfig.widthMultiplier!,
                          ),
                          Icon(Icons.place,
                              size: 16 * SizeConfig.widthMultiplier!,
                              color:
                                  Theme.of(context).textTheme.headline3?.color),
                          SizedBox(
                            width: 6.5 * SizeConfig.widthMultiplier!,
                          ),
                          Container(
                            // width: 30,
                            padding: EdgeInsets.only(
                                right: 10 * SizeConfig.widthMultiplier!),
                            child: Text(
                              widget.place,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.textMultiplier!,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.color),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  !widget.isMe
                      ? GestureDetector(
                          onTap: () {
                            reportAbuseDialog(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 9 * SizeConfig.widthMultiplier!,
                                  right: 16 * SizeConfig.widthMultiplier!),
                              child: SvgPicture.asset(
                                ImagePath.chatpopupmenuIcon,
                                width: 4 * SizeConfig.widthMultiplier!,
                                height: 20 * SizeConfig.heightMultiplier!,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ))
                      : Container(),
                ],
              ),
            ),
            widget.caption.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 16 * SizeConfig.widthMultiplier!,
                        bottom: 16 * SizeConfig.heightMultiplier!,
                        right: 16 * SizeConfig.widthMultiplier!),
                    child: ReadMoreText(
                      widget.caption,
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'see_more'.tr,
                      trimExpandedText: 'see_less'.tr,
                      colorClickableText: hintGrey,
                      style: AppTextStyle.NormalText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 14 * SizeConfig.textMultiplier!),
                    ),
                  )
                : SizedBox(),
            widget.imageUrl.length == 1
                ? _postController.getUrlType(widget.imageUrl[0]) == 0
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl[0],
                        placeholder: (context, url) => ShimmerEffect(),
                        errorWidget: (context, url, error) => ShimmerEffect(),
                        width: Get.width,
                        fit: BoxFit.cover,
                      )
                    : VideoPlayerContainer(videoUrl: widget.imageUrl[0])
                : AspectRatio(
                    aspectRatio: 4 / 5,
                    child: ListView.builder(
                        itemCount: widget.imageUrl.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              // _postController
                              //             .getUrlType(widget.imageUrl[index]) ==
                              //         0
                              //     ? AspectRatio(
                              //         aspectRatio: 4 / 5,
                              //         child: CachedNetworkImage(
                              //           imageUrl: widget.imageUrl[index],
                              //           // height: 360 * SizeConfig.widthMultiplier!,
                              //           // width: 360 * SizeConfig.widthMultiplier!,
                              //           fit: BoxFit.cover,
                              //         ),
                              //       )
                              //     : Container(
                              // height: 360 * SizeConfig.widthMultiplier!,
                              // width: 360 * SizeConfig.widthMultiplier!,
                              // child: VideoPlayerContainer(
                              //     videoUrl: widget.imageUrl[index]),
                              // ),
                              // ClipRect(
                              //   child: BackdropFilter(
                              //     filter: ImageFilter.blur(
                              //         sigmaX: 7.0, sigmaY: 7.0),
                              //     child: Container(
                              //       // imageUrl: widget.imageUrl[index],
                              //       height: 360 * SizeConfig.widthMultiplier!,
                              //       width: 360 * SizeConfig.widthMultiplier!,
                              //       color: Colors.black.withOpacity(0.5),
                              //     ),
                              //   ),
                              // ),
                              _postController
                                          .getUrlType(widget.imageUrl[index]) ==
                                      0
                                  ? AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.imageUrl[index],
                                        placeholder: (context, url) =>
                                            ShimmerEffect(),
                                        errorWidget: (context, url, error) =>
                                            ShimmerEffect(),
                                        // height: 360 * SizeConfig.widthMultiplier!,
                                        // width: 360 * SizeConfig.widthMultiplier!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: VideoPlayerContainer(
                                        videoUrl: widget.imageUrl[index],
                                      ),
                                    ),
                              // Positioned(
                              //   top: 0,
                              //   right: 0,
                              //   child: Container(
                              //     child: BackdropFilter(
                              //       filter: ImageFilter.blur(
                              //           sigmaX: 7.0, sigmaY: 7.0),
                              //       child: Container(
                              //         height: 360 * SizeConfig.widthMultiplier!,
                              //         width: 360 * SizeConfig.widthMultiplier!,
                              //         color: Colors.black.withOpacity(0.5),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              widget.imageUrl.length != 1
                                  ? Positioned(
                                      right: 0,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 16 *
                                                SizeConfig.heightMultiplier!,
                                            right: 16 *
                                                SizeConfig.widthMultiplier!),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2 *
                                                SizeConfig.heightMultiplier!,
                                            horizontal: 12 *
                                                SizeConfig.widthMultiplier!),
                                        decoration: BoxDecoration(
                                            color: lightBlack.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          '${index + 1}/${widget.imageUrl.length}',
                                          style: AppTextStyle.boldBlackText
                                              .copyWith(
                                                  color: kPureWhite,
                                                  fontSize: 14 *
                                                      SizeConfig
                                                          .textMultiplier!),
                                        ),
                                      ))
                                  : SizedBox()
                            ],
                          );
                        }),
                  ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  bottom: 16 * SizeConfig.heightMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                  top: 16 * SizeConfig.heightMultiplier!),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.hitLike,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: widget.hitLike,
                            child: widget.isLiked
                                ? Icon(
                                    Icons.favorite,
                                    color: Color(0xFFF66868),
                                  )
                                : Icon(
                                    Icons.favorite_outline,
                                    color: kGreyColor,
                                  ),
                          ),
                          SizedBox(
                            width: 5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(
                            'likes'.trParams({'no_likes': widget.likes}),
                            style: AppTextStyle.boldBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 12 * SizeConfig.textMultiplier!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18 * SizeConfig.widthMultiplier!,
                  ),
                  Icon(
                    Icons.mode_comment_outlined,
                    size: 16 * SizeConfig.widthMultiplier!,
                    color: kPureWhite,
                  ),
                  SizedBox(
                    width: 7 * SizeConfig.widthMultiplier!,
                  ),
                  Text(
                    'comments'.trParams({'no_comments': widget.comments}),
                    style: AppTextStyle.boldBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 12 * SizeConfig.textMultiplier!),
                  )
                ],
              ),
            ),
            // StreamBuilder<CommentModel>(
            //     stream: HomeService.fetchComment(widget.postId),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData &&
            //           snapshot.data!.response!.data!.length != 0)
            //         return ListView.builder(
            //             itemCount: 1,
            //             shrinkWrap: true,
            //             physics: NeverScrollableScrollPhysics(),
            //             itemBuilder: (_, index) {
            //               return snapshot.data!.response!.data!.length == 0
            //                   ? Container()
            //                   : CommentsTile(
            //                       name: snapshot
            //                           .data!.response!.data![index].user!.name!,
            //                       profilePhoto: snapshot.data!.response!
            //                           .data![index].user!.profilePhoto!,
            //                       comment: snapshot
            //                           .data!.response!.data![index].comment!,
            //                       time: _homeController.timeAgoSinceDate(
            //                           DateFormat.yMd().add_Hms().format(snapshot
            //                               .data!
            //                               .response!
            //                               .data![index]
            //                               .updatedAt!)),
            //                       likes: snapshot
            //                           .data!.response!.data![index].likes!,
            //                       onReply: () {},
            //                       onLikeComment: () {
            //                         HomeService.likePost(
            //                             commentId: snapshot
            //                                 .data!.response!.data![index].id!);

            //                         setState(() {});
            //                       },
            //                     );
            //             });
            //       return Container();
            //     }),
            // CommentsTile(
            //   name: 'Percy Bysshe Shelley',
            //   comment: 'Thank you for the motivational thoughts!',
            //   time: '26',
            //   likes: 214,
            //   onReply: () {},
            // ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 16 * SizeConfig.widthMultiplier!),
              height: 1 * SizeConfig.heightMultiplier!,
              decoration: BoxDecoration(
                color: kBlack,
              ),
            )
          ],
        ),
      ),
    );
  }

  void reportAbuseDialog(BuildContext context) {
    RxBool blockUser = false.obs;
    RxInt selectedProblemIndex = (-1).obs;
    if (_reportAbuseController.reportAbuseList.value.response == null) {
      _reportAbuseController.getReportAbuseData();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                insetPadding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                ),
                contentPadding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                content: Obx(() => (_reportAbuseController
                        .isReportAbuseLoading.value)
                    ? Container(
                        child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 30 * SizeConfig.heightMultiplier!),
                        child: SizedBox(
                            height: 30 * SizeConfig.widthMultiplier!,
                            width: 30 * SizeConfig.widthMultiplier!,
                            child: CustomizedCircularProgress()),
                      ))
                    : Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 32 * SizeConfig.heightMultiplier!,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Report Abuse".tr,
                                  style: AppTextStyle.black600Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: (16) * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 32 * SizeConfig.heightMultiplier!,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        36 * SizeConfig.widthMultiplier!),
                                child: Text(
                                  "Why_reporting?".tr,
                                  style: AppTextStyle.black600Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: (12) * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.02 * SizeConfig.heightMultiplier!,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        36 * SizeConfig.widthMultiplier!),
                                child: Text(
                                  "report_abuse_description".tr,
                                  style: AppTextStyle.black400Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: (11) * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20 * SizeConfig.heightMultiplier!,
                              ),
                              Container(
                                height: 300 * SizeConfig.heightMultiplier!,
                                child: Obx(
                                  () => SingleChildScrollView(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                            _reportAbuseController
                                                .reportAbuseList
                                                .value
                                                .response!
                                                .data!
                                                .length,
                                            (index) => Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        selectedProblemIndex
                                                            .value = index;
                                                      },
                                                      child: Container(
                                                        width: 328 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                        color: selectedProblemIndex
                                                                    .value ==
                                                                index
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.1)
                                                            : Colors
                                                                .transparent,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: 36 *
                                                                  SizeConfig
                                                                      .widthMultiplier!,
                                                              vertical: 10 *
                                                                  SizeConfig
                                                                      .heightMultiplier!),
                                                          child: Text(
                                                            _reportAbuseController
                                                                .reportAbuseList
                                                                .value
                                                                .response!
                                                                .data![index]
                                                                .reason!
                                                                .replaceAll(
                                                                    "-EN", ""),
                                                            style: AppTextStyle.black400Text.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    ?.color,
                                                                fontSize: (12) *
                                                                    SizeConfig
                                                                        .textMultiplier!,
                                                                fontWeight: selectedProblemIndex
                                                                            .value ==
                                                                        index
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .w500,
                                                                height: 1.3),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 32 * SizeConfig.heightMultiplier!,
                              // ),
                              SizedBox(
                                height: 24 * SizeConfig.heightMultiplier!,
                              ),
                              Obx(() => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            35 * SizeConfig.widthMultiplier!),
                                    child: GestureDetector(
                                      onTap: () {
                                        blockUser.value = !blockUser.value;
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                  padding: EdgeInsets.all(5 *
                                                      SizeConfig
                                                          .widthMultiplier!),
                                                  child: SvgPicture.asset(
                                                    blockUser.value
                                                        ? ImagePath.selectedBox
                                                        : ImagePath
                                                            .unselectedBox,
                                                    height: 18 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    width: SizeConfig
                                                        .widthMultiplier!,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!,
                                            ),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Block_person'.tr,
                                                  style: AppTextStyle.NormalText
                                                      .copyWith(
                                                          fontSize: 14 *
                                                              SizeConfig
                                                                  .textMultiplier!,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kPink),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              Obx(
                                () => Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      0 * SizeConfig.widthMultiplier!,
                                      32 * SizeConfig.heightMultiplier!,
                                      0 * SizeConfig.widthMultiplier!,
                                      48 * SizeConfig.heightMultiplier!,
                                    ),
                                    child: Container(
                                        width:
                                            256 * SizeConfig.widthMultiplier!,
                                        height:
                                            48 * SizeConfig.heightMultiplier!,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        0),
                                                backgroundColor: selectedProblemIndex
                                                            .value >=
                                                        0
                                                    ? MaterialStateProperty.all(
                                                        kgreen49)
                                                    : MaterialStateProperty.all(
                                                        hintGrey),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(8 *
                                                                SizeConfig
                                                                    .widthMultiplier!)))),
                                            onPressed: selectedProblemIndex.value >= 0
                                                ? () async {
                                                    if (!_reportAbuseController
                                                        .isReportSendAbuseLoading
                                                        .value) {
                                                      _reportAbuseController
                                                          .isReportSendAbuseLoading
                                                          .value = true;
                                                      var response = await _reportAbuseController
                                                          .sendRepostAbuseData(
                                                              userId: blockUser
                                                                      .value
                                                                  ? widget
                                                                      .userID
                                                                  : null,
                                                              postId:
                                                                  widget.postId,
                                                              reason: _reportAbuseController
                                                                  .reportAbuseList
                                                                  .value
                                                                  .response!
                                                                  .data![
                                                                      selectedProblemIndex
                                                                          .value]
                                                                  .serialId);
                                                      _reportAbuseController
                                                          .isReportSendAbuseLoading
                                                          .value = false;
                                                      if (response.isNotEmpty) {
                                                        Navigator.pop(context);
                                                        _homeController
                                                            .explorePostList
                                                            .removeAt(_homeController
                                                                .explorePostList
                                                                .indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        widget
                                                                            .postId));
                                                        final postQuery = await HomeService
                                                            .getExplorePosts(
                                                                skip: _homeController
                                                                        .explorePageCount
                                                                        .value *
                                                                    5);

                                                        _homeController
                                                            .explorePostList
                                                            .addAll(postQuery
                                                                .response!
                                                                .data!);
                                                        _homeController
                                                            .explorePageCount
                                                            .value = _homeController
                                                                .explorePageCount
                                                                .value +
                                                            1;
                                                      }
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  response)));
                                                    }
                                                  }
                                                : () {
                                                    pleaseSelectAnOptionDialog(
                                                        context);
                                                  },
                                            child: Text(
                                              "Submit".tr,
                                              style: AppTextStyle.hboldWhiteText
                                                  .copyWith(
                                                      color:
                                                          selectedProblemIndex
                                                                      .value >=
                                                                  0
                                                              ? kPureWhite
                                                              : greyBorder),
                                            ))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 7 * SizeConfig.heightMultiplier!,
                            right: 7 * SizeConfig.widthMultiplier!,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset(
                                ImagePath.closedialogIcon,
                                color: Theme.of(context).primaryColor,
                                width: 16 * SizeConfig.widthMultiplier!,
                                height: 16 * SizeConfig.heightMultiplier!,
                              ),
                            ),
                          ),
                        ],
                      ))),
          ),
        );
      },
    );
  }

  void pleaseSelectAnOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                insetPadding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                ),
                contentPadding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                content: Obx(
                    () => (_reportAbuseController.isReportAbuseLoading.value)
                        ? Container(
                            child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 30 * SizeConfig.heightMultiplier!),
                            child: SizedBox(
                                height: 30 * SizeConfig.widthMultiplier!,
                                width: 30 * SizeConfig.widthMultiplier!,
                                child: CustomizedCircularProgress()),
                          ))
                        : Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 32 * SizeConfig.heightMultiplier!,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        16 * SizeConfig.widthMultiplier!),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Please select a valid reason\n for reporting."
                                            .tr,
                                        style: AppTextStyle.black600Text
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: (14) *
                                                    SizeConfig.textMultiplier!,
                                                fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 7 * SizeConfig.heightMultiplier!,
                                right: 7 * SizeConfig.widthMultiplier!,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: SvgPicture.asset(
                                    ImagePath.closedialogIcon,
                                    color: Theme.of(context).primaryColor,
                                    width: 16 * SizeConfig.widthMultiplier!,
                                    height: 16 * SizeConfig.heightMultiplier!,
                                  ),
                                ),
                              ),
                            ],
                          ))),
          ),
        );
      },
    );
  }
}
