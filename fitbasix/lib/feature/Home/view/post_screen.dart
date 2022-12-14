import 'dart:developer';

import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/RecentCommentModel.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/full_post_tile.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final HomeController _homeController = Get.find();
  bool isCommentLoading = false;

  @override
  void initState() {
    _homeController.skipCommentCount.value = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        RecentCommentModel recentComment = RecentCommentModel();
        recentComment = await HomeService.recentComment(
            postId: _homeController.post.value.id);
        _homeController.commentsMap[_homeController.post.value.id.toString()] =
            recentComment.response!.data!.comment;
        _homeController.updateCount[_homeController.post.value.id.toString()] =
            recentComment.response!.data!.data;
        _homeController.replyList.clear();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: false,
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 40*SizeConfig.widthMultiplier!,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 5*SizeConfig.widthMultiplier!),
                child: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      log("comment id" + _homeController.post.value.id.toString());
                      RecentCommentModel recentComment = RecentCommentModel();
                      recentComment = await HomeService.recentComment(
                          postId: _homeController.post.value.id);
                      _homeController.commentsMap[_homeController.post.value.id
                          .toString()] = recentComment.response!.data!.comment;
                      _homeController.updateCount[_homeController.post.value.id
                          .toString()] = recentComment.response!.data!.data;
                      _homeController.replyList.clear();
                    },
                    icon: SvgPicture.asset(
                      ImagePath.backIcon,
                      width: 7 * SizeConfig.widthMultiplier!,
                      height: 12 * SizeConfig.heightMultiplier!,
                      color: Theme.of(context).primaryColor,
                    )),
              ),
            ),
            title: Transform(
              transform: Matrix4.translationValues(
                  -20 * SizeConfig.widthMultiplier!, 0, 0),
              child: Text('post'.tr,
                  style: AppTextStyle.titleText.copyWith(
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
                      fontSize: 16 * SizeConfig.textMultiplier!)),
            ),
          ),
          // appBar: PreferredSize(
          //     child: CustomAppBar(titleOfModule: 'post'.tr),
          //     preferredSize: const Size(double.infinity, kToolbarHeight)),
          body: Obx(
            () => _homeController.postLoading.value
                ? Center(child: CustomizedCircularProgress())
                : FullPostTile(
                  name: _homeController.post.value.userId!.name!,
                  profilePhoto:
                      _homeController.post.value.userId!.profilePhoto!,
                  imageUrl: _homeController.post.value.files!,
                  category:
                      _homeController.post.value.postCategory![0].name!,
                  date: DateFormat.d()
                      .add_MMM()
                      .format(_homeController.post.value.updatedAt!),
                  place: _homeController
                              .post.value.location!.placeName!.length ==
                          0
                      ? ''
                      : _homeController.post.value.location!.placeName![1]
                          .toString(),
                  caption: _homeController.post.value.caption ?? '',
                  likes: _homeController.post.value.likes.toString(),
                  hitLike: () {

                    if (_homeController.post.value.isLiked!) {
                      _homeController.post.value.isLiked = false;
                      _homeController.post.value.likes =
                          _homeController.post.value.likes! - 1;

                      HomeService.unlikePost(
                          postId: _homeController.post.value.id);
                    } else {
                      _homeController.post.value.isLiked = true;
                      _homeController.post.value.likes =
                          _homeController.post.value.likes! + 1;

                      _homeController.likedPost.toSet().toList();

                      HomeService.likePost(
                          postId: _homeController.post.value.id);
                    }
                    _homeController.LikedPostMap[_homeController
                        .post.value.id!] = _homeController.LikedPostMap[
                                _homeController.post.value.id!] ==
                            null
                        ? (_homeController.post.value.isLiked!)
                        : !(_homeController
                            .LikedPostMap[_homeController.post.value.id!]!);
                    _homeController.likedPost.toSet();
                    _homeController.likedPost
                                .indexOf(_homeController.post.value.id!) ==
                            -1
                        ? _homeController.likedPost
                            .add(_homeController.post.value.id!)
                        : _homeController.likedPost
                            .remove(_homeController.post.value.id!);

                    setState(() {});
                  },
                  isLiked: _homeController.LikedPostMap[
                              _homeController.post.value.id] ==
                          null
                      ? _homeController.post.value.isLiked!
                      : _homeController
                          .LikedPostMap[_homeController.post.value.id]!,
                  comments: _homeController.post.value.comments.toString(),
                  addComment: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                   if(!isCommentLoading&&_homeController.commentController.text.isNotEmpty){
                     print("got here");
                     isCommentLoading = true;
                     log("reply test");
                     await HomeService.addComment(
                         _homeController.post.value.id!,
                         _homeController.comment.value);
                     // _homeController.viewReplies!.clear();
                     _homeController.commentController.clear();
                     var postData = await HomeService.getPostById(
                         _homeController.post.value.id!);

                     _homeController.post.value = postData.response!.data!;
                     log("ccc" +
                         _homeController.post.value.comments.toString());
                     _homeController.postComments.value =
                     await HomeService.fetchComment(
                         postId: _homeController.post.value.id!);
                     _homeController.viewReplies!.clear();
                     if (_homeController
                         .postComments.value.response!.data!.length !=
                         0) {
                       _homeController.commentsList.value = _homeController
                           .postComments.value.response!.data!;
                     }
                     setState(() {});
                     isCommentLoading = false;
                   }
                  },
                  postId: _homeController.post.value.id!,
                  comment: null,
                  people: _homeController.post.value.people!,
                  commentsList: _homeController.commentsList,
                  onReply: () {
                    print("reply");
                  },
                  onTap: () {},
                  onViewPreviousComments: () async {
                    if (_homeController.post.value.comments! / 5 >
                        _homeController.skipCommentCount.value) {
                      _homeController.commentController.clear();
                      var moreComments = await HomeService.fetchComment(
                          postId: _homeController.post.value.id!,
                          skip: _homeController.skipCommentCount.value);
                      _homeController.commentsList
                          .addAll(moreComments.response!.data!);

                      _homeController.skipCommentCount.value++;
                    } else {
                      return;
                    }
                  },
                  addReply: () {},
                ),
          )),
    );
  }
}
