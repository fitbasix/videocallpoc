import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = RxBool(false);
  Rx<UserProfileModel> userProfileData = Rx(UserProfileModel());

  Future<void> setup() async {
    isLoading.value = true;
    userProfileData.value = await CreatePostService.getUserProfile();
    isLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    setup();
    super.onInit();
  }
}
