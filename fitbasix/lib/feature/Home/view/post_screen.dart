import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/widgets/full_post_tile.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: CustomAppBar(titleOfModule: 'post'.tr),
            preferredSize: const Size(double.infinity, kToolbarHeight)),
        body: Obx(
          () => SingleChildScrollView(
            child: FullPostTile(
              name: _homeController.post.value.userId!.name!,
              profilePhoto: _homeController.post.value.userId!.profilePhoto!,
              imageUrl: _homeController.post.value.files!,
              category: _homeController.post.value.postCategory![0].name!,
              date: DateFormat.d()
                  .add_MMM()
                  .format(_homeController.post.value.updatedAt!),
              place: _homeController.post.value.location!.placeName!.length == 0
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

                  HomeService.unlikePost(postId: _homeController.post.value.id);
                } else {
                  _homeController.post.value.isLiked = true;
                  _homeController.post.value.likes =
                      _homeController.post.value.likes! + 1;

                  HomeService.likePost(postId: _homeController.post.value.id);
                }

                setState(() {});
              },
              isLiked: _homeController.post.value.isLiked!,
              comments: _homeController.post.value.comments.toString(),
              addComment: () {
                HomeService.addComment(_homeController.post.value.id!,
                    _homeController.comment.value);

                setState(() {});

                _homeController.commentController.clear();
              },
              postId: _homeController.post.value.id!,
              onTap: () {},
              comment: null,
              people: _homeController.post.value.people!,
              commentsList: _homeController.commentsList,
            ),
          ),
        ));
  }
}
