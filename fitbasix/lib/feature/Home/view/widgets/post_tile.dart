import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/comments_tile.dart';
import 'package:intl/intl.dart';

class PostTile extends StatefulWidget {
  PostTile({
    Key? key,
    required this.name,
    required this.profilePhoto,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.place,
    required this.caption,
    required this.likes,
    required this.hitLike,
    required this.comments,
    required this.addComment,
    required this.postId,
  }) : super(key: key);
  final String name;
  final String profilePhoto;
  final String imageUrl;
  final String category;
  final String date;
  final String place;
  final String caption;
  final String likes;
  final VoidCallback hitLike;
  final String comments;
  final VoidCallback addComment;
  final String postId;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
                    Text(
                      widget.name,
                      style: AppTextStyle.boldBlackText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
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
            child: Text(
              widget.caption,
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!),
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            height: 360 * SizeConfig.widthMultiplier!,
            width: 360 * SizeConfig.widthMultiplier!,
            fit: BoxFit.cover,
          ),
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
                  child: Icon(
                    Icons.favorite,
                    color: kRedColor,
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
          StreamBuilder<CommentModel>(
              stream: HomeService.fetchComment(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return CommentsTile(
                          name:
                              snapshot.data!.response!.data![index].user!.name!,
                          profilePhoto: snapshot
                              .data!.response!.data![index].user!.profilePhoto!,
                          comment:
                              snapshot.data!.response!.data![index].comment!,
                          time: _homeController.timeAgoSinceDate(
                              DateFormat.yMd().add_Hms().format(snapshot
                                  .data!.response!.data![index].updatedAt!)),
                          likes: snapshot.data!.response!.data![index].likes!,
                          onReply: () {},
                          onLikeComment: () {
                            HomeService.likePost(
                                commentId:
                                    snapshot.data!.response!.data![index].id!);

                            setState(() {});
                          },
                        );
                      });
                return Container();
              }),
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
          Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  // width: 260 * SizeConfig.widthMultiplier!,
                  margin: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  ),
                  child: TextField(
                    controller: _homeController.commentController,
                    onChanged: (value) {
                      _homeController.comment.value = value;
                    },
                    decoration: InputDecoration(
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
              IconButton(onPressed: widget.addComment, icon: Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
