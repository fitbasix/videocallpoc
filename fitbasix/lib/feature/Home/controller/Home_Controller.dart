import 'dart:developer';

import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = RxBool(false);
  Rx<UserProfileModel> userProfileData = Rx(UserProfileModel());
  Rx<PostsModel> posts = Rx(PostsModel());

  Future<void> setup() async {
    isLoading.value = true;
    userProfileData.value = await CreatePostService.getUserProfile();
    posts.value = await HomeService.getPosts();

    log(posts.value.response!.data!.length.toString());
    isLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    setup();
    super.onInit();
  }
}
