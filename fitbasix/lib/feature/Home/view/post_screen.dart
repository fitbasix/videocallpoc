import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
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

  @override
  void initState() {
    _homeController.skipCommentCount.value = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                _homeController.replyList.clear();
              },
              icon: SvgPicture.asset(
                ImagePath.backIcon,
                width: 7 * SizeConfig.widthMultiplier!,
                height: 12 * SizeConfig.heightMultiplier!,
                color: Theme.of(context).primaryColor,
              )),
          title: Transform(
            transform: Matrix4.translationValues(
                -20 * SizeConfig.widthMultiplier!, 0, 0),
            child: Text('post'.tr,
                style: AppTextStyle.titleText
                    .copyWith(
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                    fontSize: 16 * SizeConfig.textMultiplier!)),
          ),
        ),
        // appBar: PreferredSize(
        //     child: CustomAppBar(titleOfModule: 'post'.tr),
        //     preferredSize: const Size(double.infinity, kToolbarHeight)),
        body: Obx(
          () => _homeController.postLoading.value
              ? Center(child: CustomizedCircularProgress())
              : SingleChildScrollView(
                  reverse: true,
                  child: FullPostTile(
                    name: _homeController.post.value.userId!.name!,
                    profilePhoto:
                        _homeController.post.value.userId!.profilePhoto!,
                    imageUrl: _homeController.post.value.files!,
                    category: _homeController.post.value.postCategory![0].name!,
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

                        _homeController.likedPost
                                    .indexOf(_homeController.post.value.id!) ==
                                -1
                            ? null
                            : _homeController.likedPost
                                .remove(_homeController.post.value.id!);
                      } else {
                        _homeController.post.value.isLiked = true;
                        _homeController.post.value.likes =
                            _homeController.post.value.likes! + 1;
                        _homeController.likedPost
                            .add(_homeController.post.value.id!);
                        _homeController.likedPost.toSet().toList();

                        HomeService.likePost(
                            postId: _homeController.post.value.id);
                      }

                      setState(() {});
                    },
                    isLiked: _homeController.post.value.isLiked!,
                    comments: _homeController.post.value.comments.toString(),
                    addComment: () async {
                      HomeService.addComment(_homeController.post.value.id!,
                          _homeController.comment.value);

                      _homeController.commentController.clear();

                      var postData = await HomeService.getPostById(
                          _homeController.post.value.id!);

                      _homeController.post.value = postData.response!.data!;

                      _homeController.postComments.value =
                          await HomeService.fetchComment(
                              postId: _homeController.post.value.id!);

                      if (_homeController
                              .postComments.value.response!.data!.length !=
                          0) {
                        _homeController.commentsList.value =
                            _homeController.postComments.value.response!.data!;
                      }
                      setState(() {});
                    },
                    postId: _homeController.post.value.id!,
                    comment: null,
                    people: _homeController.post.value.people!,
                    commentsList: _homeController.commentsList,
                    onReply: () {},
                    onTap: () {},
                    onViewPreviousComments: () async {
                      if (_homeController.post.value.comments! / 5 >
                          _homeController.skipCommentCount.value) {
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
                ),
        ));
  }
}
