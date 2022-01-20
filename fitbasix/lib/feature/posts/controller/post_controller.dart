import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:fitbasix/feature/posts/model/UserModel.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/model/location_model.dart';
import 'package:fitbasix/feature/posts/model/media_response_model.dart';
import 'package:fitbasix/feature/posts/model/post_model.dart';
import 'package:fitbasix/feature/posts/model/suggestion_model.dart';
import 'package:fitbasix/feature/posts/model/user_profile_model.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class PostController extends GetxController {
  RxList<AssetEntity> assets = RxList();
  RxList<bool> mediaSelection = <bool>[false].obs;
  RxList<AssetEntity> selectedMediaAsset = RxList<AssetEntity>([]);
  RxList<AssetPathEntity> foldersAvailable = RxList<AssetPathEntity>([]);
  RxInt selectedFolder = 0.obs;
  RxString lastSelectedMediaIndex = RxString("");
  RxList<bool>? selectedMedia = RxList<bool>([]);
  RxList<int> selectedMediaCount = RxList<int>([]);
  RxInt count = RxInt(0);
  RxInt currentPage = RxInt(0);
  RxInt lastPage = RxInt(0);
  RxBool isDropDownExpanded = false.obs;
  final TextEditingController locationSearchController =
      TextEditingController();
  Rx<Suggestion> searchSuggestion = Rx(Suggestion());
  RxList<UserData> users = RxList<UserData>([]);
  final sessionToken = Uuid().v4();
  RxBool searchLoading = RxBool(false);
  RxString selectedLocation = RxString('');
  RxInt lastSelectedPersonIndex = RxInt(0);
  RxList<String> selectedPeopleIndex = RxList<String>([]);
  RxList<UserData> selectedUserData = RxList<UserData>([]);
  final TextEditingController postTextController = TextEditingController();
  RxString postText = RxString('');
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  Rx<File> videoFile = File('').obs;
  RxList<File> selectedMediaFiles = RxList<File>([]);
  RxString postId = "".obs;
  Rx<UserProfileModel> userProfileData = Rx(UserProfileModel());
  Rx<LocationModel> selectedLocationData = Rx(LocationModel());
  RxList<Category> categories = RxList<Category>([]);
  Rx<Category> selectedCategory = Category().obs;
  Rx<MediaUrl> uploadedFiles = MediaUrl().obs;
  RxList<String> uploadUrls = RxList<String>([]);
  Rx<PostData> postData = PostData().obs;
  RxBool isLoading = RxBool(false);
  RxList<File> selectedFiles = RxList<File>([]);

  Future<List<AssetEntity>> fetchAssets({required int presentPage}) async {
    lastPage.value = currentPage.value;
    foldersAvailable.value = await PhotoManager.getAssetPathList(onlyAll: true);
    print("kkk" + foldersAvailable.value.toString());
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
    
    final assetList = await foldersAvailable[0]
        .getAssetListPaged(currentPage.value, 100);

    // final assetList = await recentAlbum.getAssetListRange(
    //   start: start,
    //   end: end,
    // );
    currentPage++;

    return assetList;
  }

  Future<void> getCategory() async {
    if (categories.length == 0) {
      CategoryModel categoryModel = await CreatePostService.getCategory();
      categories.value = categoryModel.response!.response!.data!;
    }
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

  Future getPostData() async {
    postData.value = await CreatePostService.createPost(postId: postId.value);
  }

  Future<void> setFolderIndex({required int index}) async {
    selectedFolder.value = index;
    currentPage.value = 0;
    print(selectedFolder.value);
    assets.value = await foldersAvailable.value[selectedFolder.value]
        .getAssetListPaged(currentPage.value, 100);
    imageCache!.clear();
    imageCache!.clearLiveImages();
    print("lll" + assets.value.toString());
  }

  void toggleDropDownExpansion() {
    isDropDownExpanded.value = !isDropDownExpanded.value;
  }

  void getSelectedMedia(AssetEntity? assetEntity) {
    if (selectedMediaAsset.indexOf(assetEntity) == -1) {
      selectedMediaAsset.add(assetEntity!);
    } else {
      print("remove");
      selectedMediaAsset.remove(assetEntity!);
    }
    print(selectedMediaAsset);
  }

  Future<List<File>> getFile(List<AssetEntity> assetEntities) async {
    selectedMediaFiles.value = [];
    for (int i = 0; i < assetEntities.length; i++) {
      File? fileName = await assetEntities[i].file;
      selectedMediaFiles.add(fileName!);
    }
    return selectedMediaFiles;
  }

  Future pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);

      imageFile = imageTemporary;
    } on PlatformException catch (e) {
      log('failed to pick a image');
    }
  }

  Future pickVideo() async {
    try {
      final video = await _picker.pickVideo(source: ImageSource.camera);
      if (video == null) return;

      final imageTemporary = File(video.path);

      videoFile.value = imageTemporary;
    } on PlatformException catch (e) {
      log('failed to pick a video');
    }
  }

  int? getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg") {
      return 0;
    }
    if (typeString == "mp4") {
      return 1;
    } else {
      return null;
    }
  }

  @override
  Future<void> onInit() async {
    assets.value = await fetchAssets(presentPage: currentPage.value);
    super.onInit();
  }
}
