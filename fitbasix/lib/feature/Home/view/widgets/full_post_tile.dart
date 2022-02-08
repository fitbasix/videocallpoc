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
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/comments_tile.dart';
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
      required this.commentsList})
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

  @override
  State<FullPostTile> createState() => _FullPostTileState();
}

class _FullPostTileState extends State<FullPostTile> {
  final HomeController _homeController = Get.find();

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
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Container(
                                        height: 1,
                                        width: 15,
                                        color: kPureBlack,
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text('with'.tr),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        widget.people[0].name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
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
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Container(
                                        height: 1,
                                        width: 15,
                                        color: kPureBlack,
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'with'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
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
                                  color: kGreyColor)),
                          SizedBox(
                            width: 13 * SizeConfig.widthMultiplier!,
                          ),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: kGreyColor,
                          ),
                          SizedBox(
                            width: 5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(widget.date,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.textMultiplier!,
                                  color: kGreyColor)),
                          SizedBox(
                            width: 14 * SizeConfig.widthMultiplier!,
                          ),
                          Icon(
                            Icons.place,
                            size: 16,
                            color: kGreyColor,
                          ),
                          SizedBox(
                            width: 6.5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(widget.place,
                              style: AppTextStyle.normalBlackText.copyWith(
                                  fontSize: 12 * SizeConfig.textMultiplier!,
                                  color: kGreyColor))
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
                              CachedNetworkImage(
                                imageUrl: widget.imageUrl[index],
                                height: 360 * SizeConfig.widthMultiplier!,
                                width: 360 * SizeConfig.widthMultiplier!,
                                fit: BoxFit.cover,
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
                              CachedNetworkImage(
                                imageUrl: widget.imageUrl[index],
                                height: 360 * SizeConfig.widthMultiplier!,
                                width: 360 * SizeConfig.widthMultiplier!,
                                fit: BoxFit.contain,
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
                            color: kRedColor,
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
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                  ),
                  SizedBox(
                    width: 18 * SizeConfig.widthMultiplier!,
                  ),
                  Text(
                    'comments'.trParams({'no_comments': widget.comments}),
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                  )
                ],
              ),
            ),
            // widget.comment == null
            //     ? Container()
            //     : CommentsTile(
            //         name: widget.comment!.user!.name.toString(),
            //         profilePhoto: widget.comment!.user!.profilePhoto.toString(),
            //         comment: widget.comment!.comment.toString(),
            //         time: _homeController.timeAgoSinceDate(DateFormat.yMd()
            //             .add_Hms()
            //             .format(widget.comment!.createdAt!)),
            //         likes: widget.comment!.likes!,
            //         onReply: () {},
            //         onLikeComment: () {
            //           if (widget.comment!.isLiked!) {
            //             widget.comment!.isLiked = false;
            //             widget.comment!.likes = widget.comment!.likes! - 1;
            //             HomeService.unlikePost(commentId: widget.comment!.id);
            //           } else {
            //             widget.comment!.isLiked = true;
            //             widget.comment!.likes = widget.comment!.likes! + 1;
            //             HomeService.likePost(commentId: widget.comment!.id);
            //           }

            //           setState(() {});
            //         },
            //       ),
            Obx(() => _homeController.commentsLoading.value
                ? Center(
                    child: CustomizedCircularProgress(),
                  )
                : Container(
                    child: ListView.builder(
                        itemCount: widget.commentsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return Obx(() => CommentsTile(
                              name: widget.commentsList[index].user!.name!,
                              comment: widget.commentsList[index].comment!,
                              time: '1999',
                              likes: widget.commentsList[index].likes!,
                              profilePhoto: widget
                                  .commentsList[index].user!.profilePhoto!,
                              onReply: () {},
                              onLikeComment: () {
                                if (widget.commentsList[index].isLiked!) {
                                  widget.commentsList[index].isLiked = false;
                                  widget.commentsList[index].likes =
                                      widget.commentsList[index].likes! - 1;

                                  HomeService.unlikePost(
                                      commentId: widget.commentsList[index].id);
                                } else {
                                  widget.commentsList[index].isLiked = true;
                                  widget.commentsList[index].likes =
                                      widget.commentsList[index].likes! + 1;

                                  HomeService.likePost(
                                      commentId: widget.commentsList[index].id);
                                }
                                setState(() {});
                              }));
                        }),
                  )),
            // FutureBuilder<CommentModel>(
            //     future: HomeService.fetchComment(widget.postId),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData &&
            //           snapshot.data!.response!.data!.length != 0)
            //         return ListView.builder(
            //             itemCount: snapshot.data!.response!.data!.length,
            //             shrinkWrap: true,
            //             physics: NeverScrollableScrollPhysics(),
            //             itemBuilder: (_, index) {
            //               return snapshot.data!.response!.data!.length == 0
            //                   ? Container()
            //                   : CommentsTile(
            //                       name: snapshot.data!.response!.data![index]
            //                               .user!.name ??
            //                           '',
            //                       profilePhoto: snapshot.data!.response!
            //                           .data![index].user!.profilePhoto!,
            //                       comment: snapshot
            //                           .data!.response!.data![index].comment!,
            //                       time: _homeController.timeAgoSinceDate(
            //                           DateFormat.yMd().add_Hms().format(snapshot
            //                               .data!
            //                               .response!
            //                               .data![index]
            //                               .createdAt!)),
            //                       likes: snapshot
            //                           .data!.response!.data![index].likes!,
            //                       onReply: () {},
            //                       onLikeComment: () {
            //                         if (snapshot.data!.response!.data![index]
            //                             .isLiked!) {
            //                           // widget.comment!.isLiked = false;
            //                           // widget.comment!.likes =
            //                           //     widget.comment!.likes! - 1;
            //                           HomeService.unlikePost(
            //                               commentId: snapshot.data!.response!
            //                                   .data![index].id!);
            //                         } else {
            //                           // widget.comment!.isLiked = true;
            //                           // widget.comment!.likes =
            //                           //     widget.comment!.likes! + 1;
            //                           HomeService.likePost(
            //                               commentId: snapshot.data!.response!
            //                                   .data![index].id!);
            //                         }
            //                         // HomeService.likePost(
            //                         //     commentId: snapshot.data!.response!
            //                         //         .data![index].id!);

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
            GestureDetector(
              onTap: () {},
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      // width: 260 * SizeConfig.widthMultiplier!,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                      ),
                      child: TextField(
                        controller: _homeController.commentController,
                        onChanged: (value) {
                          _homeController.comment.value = value;
                        },
                        decoration: InputDecoration(
                            enabled: true,
                            border: InputBorder.none,
                            hintText: 'add_comment'.tr,
                            hintStyle: AppTextStyle.smallGreyText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                color: hintGrey),
                            contentPadding: EdgeInsets.only(
                                bottom: 10,
                                left: 16 * SizeConfig.widthMultiplier!)),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: widget.addComment, icon: Icon(Icons.send))
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
