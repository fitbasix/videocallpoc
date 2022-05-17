
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:get/get.dart';

class IndividualUserController extends GetxController{
  RxBool dataNeedToLoad = true.obs;
  RxBool showLoading = false.obs;
  RxInt currentPage  = 0.obs;
  RxList<Post> userPostList = RxList<Post>([]);
  RxString userId = ''.obs;
  RxBool isLoading = true.obs;

  // @override
  // Future<void> onInit() async {
  //   isLoading.value = true;
  //
  //   loginController = Get.put(LoginController());
  //   await setEditProfileData();
  //   interests.value = await TrainerServices.getAllInterest();
  //   isLoading.value = false;
  //   super.onInit();
  // }

}