import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
// import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/comments_tile.dart';
import 'package:fitbasix/feature/Home/view/widgets/video_player.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class FullPostTile extends StatefulWidget {
  FullPostTile(
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
      required this.comment,
      required this.people,
      required this.commentsList,
      required this.onReply,
      required this.onViewPreviousComments,
      required this.addReply})
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
  final Comment? comment;
  final List<Person> people;
  final List<Comments> commentsList;
  final VoidCallback onReply;
  final VoidCallback onViewPreviousComments;
  final VoidCallback addReply;

  @override
  State<FullPostTile> createState() => _FullPostTileState();
}

class _FullPostTileState extends State<FullPostTile> {
  final HomeController _homeController = Get.find();
  final PostController _postController = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  bottom: 16 * SizeConfig.heightMultiplier!,
                  top: 16 * SizeConfig.heightMultiplier!),
              child: Row(
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
                          ? Text(
                              widget.name,
                              style: AppTextStyle.boldBlackText.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
                                  fontSize: 14 * SizeConfig.textMultiplier!),
                            )
                          : widget.people.length == 1
                              ? Container(
                                  width: 276 * SizeConfig.widthMultiplier!,
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
                                        height: 1,
                                        width: 15,
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
                                        style: AppTextStyle.normalGreenText
                                            .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                        ),
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
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 276 * SizeConfig.widthMultiplier!,
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
                                        height: 1,
                                        width: 15,
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
                              size: 16,
                              color:
                                  Theme.of(context).textTheme.headline3?.color),
                          SizedBox(
                            width: 5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(widget.date,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.textMultiplier!,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.color)),
                          SizedBox(
                            width: 14 * SizeConfig.widthMultiplier!,
                          ),
                          Icon(Icons.place,
                              size: 16,
                              color:
                                  Theme.of(context).textTheme.headline3?.color),
                          SizedBox(
                            width: 6.5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(widget.place,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.textMultiplier!,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.color))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
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
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: 14 * SizeConfig.textMultiplier!),
              ),
            ),
            widget.imageUrl.length != 0
                ? Container(
                    height: 360 * SizeConfig.widthMultiplier!,
                    child: ListView.builder(
                        itemCount: widget.imageUrl.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              _postController
                                          .getUrlType(widget.imageUrl[index]) ==
                                      0
                                  ? CachedNetworkImage(
                                      imageUrl: widget.imageUrl[index],
                                      height: 360 * SizeConfig.widthMultiplier!,
                                      width: 360 * SizeConfig.widthMultiplier!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 360 * SizeConfig.widthMultiplier!,
                                      width: 360 * SizeConfig.widthMultiplier!,
                                      // child: VideoPlayerContainer(
                                      //     videoUrl: widget.imageUrl[index]),
                                    ),
                              ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 7.0, sigmaY: 7.0),
                                  child: Container(
                                    // imageUrl: widget.imageUrl[index],
                                    height: 360 * SizeConfig.widthMultiplier!,
                                    width: 360 * SizeConfig.widthMultiplier!,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              _postController
                                          .getUrlType(widget.imageUrl[index]) ==
                                      0
                                  ? CachedNetworkImage(
                                      imageUrl: widget.imageUrl[index],
                                      height: 360 * SizeConfig.widthMultiplier!,
                                      width: 360 * SizeConfig.widthMultiplier!,
                                      fit: BoxFit.contain,
                                    )
                                  : Container(
                                      height: 360 * SizeConfig.widthMultiplier!,
                                      width: 360 * SizeConfig.widthMultiplier!,
                                      child: VideoPlayerContainer(
                                          videoUrl: widget.imageUrl[index]),
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
                  )
                : SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  bottom: 16 * SizeConfig.heightMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                  top: 16 * SizeConfig.heightMultiplier!),
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
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 12 * SizeConfig.textMultiplier!),
                  ),
                  SizedBox(
                    width: 18 * SizeConfig.widthMultiplier!,
                  ),
                  Icon(
                    Icons.mode_comment_outlined,
                    size: 16*SizeConfig.widthMultiplier!,
                    color: kPureWhite,
                  ),
                  SizedBox(
                    width: 6.5 * SizeConfig.widthMultiplier!,
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
            int.tryParse(widget.comments)! > 5
                ? Obx(() => (_homeController.post.value.comments! / 5 >
                        _homeController.skipCommentCount.value)
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: 16 * SizeConfig.widthMultiplier!,
                            bottom: 16 * SizeConfig.heightMultiplier!,
                            right: 16 * SizeConfig.widthMultiplier!,
                            top: 4 * SizeConfig.heightMultiplier!),
                        child: InkWell(
                            onTap: widget.onViewPreviousComments,
                            child: Text('view_previous_comments'.tr,
                                style: AppTextStyle.boldBlackText.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.color,
                                    fontSize:
                                        14 * SizeConfig.textMultiplier!))),
                      )
                    : Container())
                : Container(),
            Obx(() => _homeController.commentsLoading.value
                ? Center(
                    child: CustomizedCircularProgress(),
                  )
                : Container(
                    child: ListView.builder(
                        itemCount: widget.commentsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        reverse: true,
                        itemBuilder: (_, index) {
                          for (var item in widget.commentsList) {
                            _homeController.viewReplies!.add(false);
                            _homeController.skipReplyList.add(0);
                          }
                          return Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommentsTile(
                                    name:
                                        widget.commentsList[index].user!.name ??
                                            '',
                                    comment:
                                        widget.commentsList[index].comment!,
                                    time: _homeController.timeAgoSinceDate(
                                        DateFormat.yMd().add_Hms().format(
                                              widget.commentsList[index]
                                                  .createdAt!
                                                  .toLocal(),
                                            )),
                                    likes: widget.commentsList[index].likes!,
                                    profilePhoto: widget.commentsList[index]
                                        .user!.profilePhoto!,
                                    onReply: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Container(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                child: Row(
                                                  // mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        // height: 40,
                                                        // width: 260 * SizeConfig.widthMultiplier!,
                                                        margin: EdgeInsets.only(
                                                            left: 16 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                            right: 16 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                            top: 16 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                            bottom: 16 *
                                                                SizeConfig
                                                                    .heightMultiplier!),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(8 *
                                                                  SizeConfig
                                                                      .widthMultiplier!),
                                                        ),
                                                        child: TextField(
                                                          controller:
                                                              _homeController
                                                                  .replyController,
                                                          onChanged: (value) {
                                                            _homeController
                                                                .reply
                                                                .value = value;
                                                          },
                                                          style: AppTextStyle
                                                              .lightMediumBlackText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1
                                                                      ?.color),
                                                          autofocus: true,
                                                          maxLines: null,
                                                          decoration:
                                                              InputDecoration(
                                                            enabled: true,
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'add_comment'
                                                                    .tr,
                                                            hintStyle: AppTextStyle
                                                                .smallGreyText
                                                                .copyWith(
                                                                    fontSize: 12 *
                                                                        SizeConfig
                                                                            .textMultiplier!,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline1
                                                                        ?.color),
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                              bottom: 12 *
                                                                  SizeConfig
                                                                      .heightMultiplier!,
                                                              top: 12 *
                                                                  SizeConfig
                                                                      .heightMultiplier!,
                                                              left: 16 *
                                                                  SizeConfig
                                                                      .widthMultiplier!,
                                                              right: 16 *
                                                                  SizeConfig
                                                                      .widthMultiplier!,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          await HomeService.replyComment(
                                                              commentId: widget
                                                                  .commentsList[
                                                                      index]
                                                                  .id!,
                                                              comment:
                                                                  _homeController
                                                                      .reply
                                                                      .value);

                                                          _homeController
                                                                  .postComments
                                                                  .value =
                                                              await HomeService
                                                                  .fetchComment(
                                                                      postId: _homeController
                                                                          .post
                                                                          .value
                                                                          .id!);

                                                          if (_homeController
                                                                  .postComments
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .length !=
                                                              0) {
                                                            _homeController
                                                                    .commentsList
                                                                    .value =
                                                                _homeController
                                                                    .postComments
                                                                    .value
                                                                    .response!
                                                                    .data!;
                                                          }
                                                          _homeController
                                                              .replyList
                                                              .clear();

                                                          setState(() {
                                                            _homeController
                                                                    .future =
                                                                _homeController.fetchReplyComment(
                                                                    commentId: widget
                                                                        .commentsList[
                                                                            index]
                                                                        .id!,
                                                                    skip: 0,
                                                                    limit: 1);
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.send,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    onLikeComment: () {
                                      if (widget.commentsList[index].isLiked!) {
                                        widget.commentsList[index].isLiked =
                                            false;
                                        widget.commentsList[index].likes =
                                            widget.commentsList[index].likes! -
                                                1;

                                        HomeService.unlikePost(
                                            commentId:
                                                widget.commentsList[index].id);
                                      } else {
                                        widget.commentsList[index].isLiked =
                                            true;
                                        widget.commentsList[index].likes =
                                            widget.commentsList[index].likes! +
                                                1;

                                        HomeService.likePost(
                                            commentId:
                                                widget.commentsList[index].id);
                                      }
                                      setState(() {});
                                    },
                                    replyCount:
                                        widget.commentsList[index].reply,
                                    minWidth: Get.width -
                                        80 * SizeConfig.widthMultiplier!,
                                    taggedPersonName: '',
                                    maxWidth: Get.width*SizeConfig.widthMultiplier!,
                                  ),
                                  Obx(() => _homeController
                                                  .commentsList[index].reply! >
                                              0 &&
                                          _homeController.viewReplies![index] ==
                                              false
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 64 * SizeConfig.widthMultiplier!,
                                              top: 4 * SizeConfig.heightMultiplier!,
                                              bottom: 12 * SizeConfig.heightMultiplier!),
                                          child: InkWell(
                                              onTap: () {
                                                _homeController.viewReplies!
                                                    .replaceRange(
                                                        0,
                                                        _homeController
                                                            .viewReplies!
                                                            .length,
                                                        List.generate(
                                                            _homeController
                                                                .viewReplies!
                                                                .length,
                                                            (index) => false));
                                                _homeController
                                                    .viewReplies![index] = true;
                                                _homeController.replyList
                                                    .clear();
                                                _homeController
                                                    .skipReplyList[index] = 0;
                                                setState(() {
                                                  _homeController.future =
                                                      _homeController.fetchReplyComment(
                                                          commentId:
                                                              _homeController
                                                                  .commentsList[
                                                                      index]
                                                                  .id!,
                                                          skip: _homeController
                                                                  .skipReplyList[
                                                              index]);
                                                });
                                              },
                                              child: Text('view_replies'.tr,
                                                  style: AppTextStyle
                                                      .boldBlackText
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6
                                                                  ?.color,
                                                          fontSize: 14 *
                                                              SizeConfig
                                                                  .textMultiplier!))),
                                        )
                                      : Container()),
                                  Obx(
                                      () =>
                                          _homeController.viewReplies![index] ==
                                                  true
                                              ? Container(
                                                  child:
                                                      FutureBuilder<
                                                              List<Comments>>(
                                                          initialData: [],
                                                          future:
                                                              _homeController
                                                                  .future,
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData)
                                                              return ListView
                                                                  .builder(
                                                                      itemCount: snapshot
                                                                          .data!
                                                                          .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              index2) {
                                                                        return Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 48 * SizeConfig.widthMultiplier!),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              CommentsTile(
                                                                                name: snapshot.data![index2].user!.name!,
                                                                                comment: snapshot.data![index2].comment!,
                                                                                taggedPersonName: snapshot.data![index2].taggedPerson == null ? '' : snapshot.data![index2].taggedPerson!.name!,
                                                                                time: _homeController.timeAgoSinceDate(DateFormat.yMd().add_Hms().format(snapshot.data![index2].createdAt!.toLocal())),
                                                                                likes: snapshot.data![index2].likes!,
                                                                                profilePhoto: snapshot.data![index2].user!.profilePhoto!,
                                                                                onReply: () {
                                                                                  showModalBottomSheet(
                                                                                      context: context,
                                                                                      isScrollControlled: true,
                                                                                      builder: (context) {
                                                                                        return Padding(
                                                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                          child: Container(
                                                                                            color: Theme.of(context).scaffoldBackgroundColor,
                                                                                            child: Row(
                                                                                              // mainAxisSize: MainAxisSize.min,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Container(
                                                                                                    // height: 40,
                                                                                                    // width: 260 * SizeConfig.widthMultiplier!,
                                                                                                    margin: EdgeInsets.only(
                                                                                                        left: 16*SizeConfig.widthMultiplier!,
                                                                                                        right: 16*SizeConfig.widthMultiplier!,
                                                                                                        top: 16*SizeConfig.heightMultiplier!,
                                                                                                        bottom: 16*SizeConfig.heightMultiplier!
                                                                                                    ),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Theme.of(context).cardColor,
                                                                                                      borderRadius: BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                                                                                                    ),
                                                                                                    child: TextField(
                                                                                                      controller: _homeController.replyController,
                                                                                                      onChanged: (value) {
                                                                                                        _homeController.reply.value = value;
                                                                                                      },
                                                                                                      autofocus: true,
                                                                                                      maxLines: null,
                                                                                                      style: AppTextStyle.lightMediumBlackText.copyWith(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          color: Theme.of(context).textTheme.bodyText1?.color),
                                                                                                      decoration: InputDecoration(
                                                                                                          enabled: true,
                                                                                                          border: InputBorder.none,
                                                                                                          hintText: 'add_comment'.tr,
                                                                                                          hintStyle: AppTextStyle.smallGreyText.copyWith(
                                                                                                              fontSize: 12 * SizeConfig.textMultiplier!,
                                                                                                              color: Theme.of(context).textTheme.headline1?.color
                                                                                                          ),
                                                                                                          contentPadding: EdgeInsets.only(
                                                                                                            bottom: 12 * SizeConfig.heightMultiplier!,
                                                                                                            top: 12 * SizeConfig.heightMultiplier!,
                                                                                                            left: 16 * SizeConfig.widthMultiplier!,
                                                                                                            right: 16 * SizeConfig.widthMultiplier!,
                                                                                                          )
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                IconButton(
                                                                                                    onPressed: () async {
                                                                                                      Navigator.pop(context);
                                                                                                      FocusScope.of(context).unfocus();
                                                                                                      await HomeService.replyComment(commentId: widget.commentsList[index].id!, taggedPerson: snapshot.data![index2].user!.id, comment: _homeController.reply.value);

                                                                                                      _homeController.postComments.value = await HomeService.fetchComment(postId: _homeController.post.value.id!);

                                                                                                      if (_homeController.postComments.value.response!.data!.length != 0) {
                                                                                                        _homeController.commentsList.value = _homeController.postComments.value.response!.data!;
                                                                                                      }
                                                                                                      _homeController.replyList.clear();

                                                                                                      setState(() {
                                                                                                        _homeController.future = _homeController.fetchReplyComment(commentId: widget.commentsList[index].id!, skip: 0, limit: 1);
                                                                                                      });
                                                                                                    },
                                                                                                    icon: Icon(
                                                                                                      Icons.send,
                                                                                                      color: Theme.of(context).primaryColor,
                                                                                                    ))
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      });
                                                                                },
                                                                                onLikeComment: () {
                                                                                  if (snapshot.data![index2].isLiked!) {
                                                                                    snapshot.data![index2].isLiked = false;
                                                                                    snapshot.data![index2].likes = snapshot.data![index2].likes! - 1;

                                                                                    HomeService.unlikePost(commentId: snapshot.data![index2].id);
                                                                                  } else {
                                                                                    snapshot.data![index2].isLiked = true;
                                                                                    snapshot.data![index2].likes = snapshot.data![index2].likes! + 1;

                                                                                    HomeService.likePost(commentId: snapshot.data![index2].id);
                                                                                  }
                                                                                  setState(() {});
                                                                                },
                                                                                minWidth: Get.width - 128 * SizeConfig.widthMultiplier!,
                                                                                maxWidth: 236 * SizeConfig.widthMultiplier!,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      });
                                                            return Container();
                                                          }),
                                                )
                                              : Container()),
                                  Obx(() => _homeController
                                                  .commentsList[index].reply! >
                                              _homeController
                                                      .skipReplyList[index] *
                                                  3 &&
                                          _homeController.viewReplies![index] ==
                                              true
                                      ? TextButton(
                                          onPressed: () {
                                            _homeController
                                                    .skipReplyList[index] =
                                                _homeController
                                                        .skipReplyList[index] +
                                                    1;
                                            setState(() {
                                              _homeController.future =
                                                  _homeController
                                                      .fetchReplyComment(
                                                          commentId:
                                                              _homeController
                                                                  .commentsList[
                                                                      index]
                                                                  .id!,
                                                          skip: _homeController
                                                                  .skipReplyList[
                                                              index]);
                                            });

                                            // setState(() {});
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 56 *
                                                    SizeConfig
                                                        .widthMultiplier!),
                                            child: Text('view_more_replies'.tr,
                                                style: AppTextStyle
                                                    .boldBlackText
                                                    .copyWith(
                                                  color: Theme.of(context).textTheme.headline6?.color,
                                                        fontSize: 14 *
                                                            SizeConfig
                                                                .textMultiplier!)),
                                          ))
                                      : Container())
                                ],
                              ));
                        }),
                  )),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      // height: 40,
                      // width: 260 * SizeConfig.widthMultiplier!,
                      margin: EdgeInsets.only(
                          left: 16*SizeConfig.widthMultiplier!,
                          right: 16*SizeConfig.widthMultiplier!),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                      ),
                      child: TextField(
                        controller: _homeController.commentController,
                        onChanged: (value) {
                          _homeController.comment.value = value;
                        },
                        maxLines: null,
                        style: AppTextStyle.lightMediumBlackText.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyText1?.color),
                        decoration: InputDecoration(
                            enabled: true,
                            border: InputBorder.none,
                            hintText: 'add_comment'.tr,
                            hintStyle: AppTextStyle.smallGreyText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: Theme.of(context).textTheme.headline1?.color
                            ),
                            contentPadding: EdgeInsets.only(
                              bottom: 12 * SizeConfig.heightMultiplier!,
                              top: 12 * SizeConfig.heightMultiplier!,
                              left: 16 * SizeConfig.widthMultiplier!,
                              right: 16 * SizeConfig.widthMultiplier!,
                            )),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: widget.addComment,
                      icon: Icon(
                      Icons.send,
                    color: Theme.of(context).primaryColor,
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      ),
    );
  }
}
