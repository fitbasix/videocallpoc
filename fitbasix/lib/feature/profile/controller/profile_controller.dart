import 'dart:developer';
import 'dart:io';

import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Home/model/post_feed_model.dart';
import '../../get_trained/model/interest_model.dart';
import '../../get_trained/services/trainer_services.dart';
import '../../log_in/controller/login_controller.dart';

class ProfileController extends GetxController {
  var val = 0.obs;
  LoginController? loginController;
  final HomeController homeController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxString selectedDate = DateTime.now().toString().obs;
  RxBool directFromHome = true.obs;

  RxString otp = "".obs;
  RxBool dataNeedToLoad = true.obs;
  RxInt lastPage = RxInt(0);
// height controller for dialog box
  RxString heightType = "inch".obs;
  RxInt currentHeight = 170.obs;
  final heightRulerPickerController = RulerPickerController(value: 0);
// weight controller for dialog box
  RxInt currentWeight = 65.obs;
  RxString weightType = "kg".obs;
  final rulerPickerController = RulerPickerController(value: 2);
  RxList<Post> userPostList = RxList<Post>([]);
  Rx<PostsModel> initialPostData = Rx(PostsModel());
  RxInt currentPage = RxInt(0);
  RxInt gender = RxInt(0);
  RxBool isLoading = false.obs;
  File? imageFile;
  RxBool showLoading = RxBool(false);
  Rx<InterestModel> interests = InterestModel().obs;
  RxList<int> interestList = <int>[].obs;
  RxString profilePhoto = "".obs;
  RxList<AssetEntity> assets = RxList();
  RxList<AssetEntity> selectedMediaAsset = RxList<AssetEntity>([]);
  RxList<AssetPathEntity> foldersAvailable = RxList<AssetPathEntity>([]);
  RxBool isCoverPhoto = false.obs;
  RxString coverPhoto = "".obs;

  void editUserPersonalInfo() {
    //todo import API for user data updating
    //user email
    emailController.text;
    //user dob
    DOBController.text;
    //mobile no
    loginController?.mobile.value;
    //country code
    loginController?.selectedCountry.value;
  }

  Future<File> genThumbnailFile(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight:
          100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    File file = File(fileName!);
    return file;
  }

  // Future<File> getFile(AssetEntity assetEntities) async {
  //   selectedMediaFiles.value = [];
  //   for (int i = 0; i < assetEntities.length; i++) {
  //     File? fileName = await assetEntities.file;
  //     selectedMediaFiles.add(fileName!);
  //   }
  //   return selectedMediaFiles;
  // }

  Future<List<AssetEntity>> fetchAssets({required int presentPage}) async {
    lastPage.value = currentPage.value;
    foldersAvailable.value = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    print("kkk" + foldersAvailable.toString());
//     try{
// selectedFolder.value = foldersAvailable.indexOf(
//         foldersAvailable.singleWhere(
//             (element) => element.name.toLowerCase().contains("recent")));
//     }
//     catch(e){
//       selectedFolder.value = foldersAvailable.indexOf(
//         foldersAvailable.singleWhere(
//             (element) => element.name.toLowerCase().contains("all photos")));
//     }
    var assetList = <AssetEntity>[];
    assetList = await foldersAvailable[0].getAssetListPaged(
      page: currentPage.value,
      size: 100,
    );

    print("AssetList " + currentPage.value.toString());
    currentPage++;
    print("AssetList " + assetList.toString());
    return assetList;
  }

  Future<void> setEditProfileData() async {
    log("dfgdsg");
    loginController!.mobileController.text = homeController
        .userProfileData.value.response!.data!.profile!.mobileNumber
        .toString();
    log("dfgdsg");
    interestList.value = homeController
        .userProfileData.value.response!.data!.profile!.selectedInterest!;
    loginController!.mobile.value = homeController
        .userProfileData.value.response!.data!.profile!.mobileNumber
        .toString();
    nameController.text = homeController
        .userProfileData.value.response!.data!.profile!.name
        .toString();
    coverPhoto.value = homeController
        .userProfileData.value.response!.data!.profile!.coverPhoto
        .toString();
    bioController.text =
        homeController.userProfileData.value.response!.data!.profile!.bio ==
                null
            ? ""
            : homeController.userProfileData.value.response!.data!.profile!.bio
                .toString();
    log("dfgdsg");
    currentWeight.value = homeController
                .userProfileData.value.response!.data!.profile!.weight ==
            null
        ? 65
        : homeController.userProfileData.value.response!.data!.profile!.weight!
            .toInt();
    currentHeight.value = homeController
                .userProfileData.value.response!.data!.profile!.height ==
            null
        ? 120
        : homeController.userProfileData.value.response!.data!.profile!.height!
            .toInt();
    profilePhoto.value = homeController
        .userProfileData.value.response!.data!.profile!.profilePhoto!;
    gender.value = homeController
                .userProfileData.value.response!.data!.profile!.gender ==
            null
        ? 0
        : homeController.userProfileData.value.response!.data!.profile!.gender!;
    print(loginController!.mobile.value);
    emailController.text = homeController
        .userProfileData.value.response!.data!.profile!.email
        .toString();
    selectedDate.value = homeController
                .userProfileData.value.response!.data!.profile!.dob ==
            null
        ? DateTime.now().toString()
        : DateFormat("dd/LL/yyyy").format(
            homeController.userProfileData.value.response!.data!.profile!.dob!);
    print(selectedDate.value + " kkk");
    DOBController.text = homeController
                .userProfileData.value.response!.data!.profile!.dob ==
            null
        ? ""
        : DateFormat("dd/LL/yyyy").format(
            homeController.userProfileData.value.response!.data!.profile!.dob!);
    log("dfgdsg");
    await loginController!.getCountries();
    loginController!.selectedCountry.value = loginController!.countryList
        .singleWhere((element) =>
            element.code ==
            homeController
                .userProfileData.value.response!.data!.profile!.countryCode);
  }

  setAssetDataForGallery() async {
    assets.value = await fetchAssets(presentPage: currentPage.value);
  }

  @override
  Future<void> onInit() async {
    isLoading.value = true;

    print("asset list " + assets.toString());
    loginController = Get.put(LoginController());
    await setEditProfileData();
    interests.value = await TrainerServices.getAllInterest();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> getProfilePosts() async{
    final postQuery = await ProfileServices.getUserPosts(
        skip: 0);
    userPostList.clear();
    userPostList.addAll(postQuery.response!.data!);
  }
}
