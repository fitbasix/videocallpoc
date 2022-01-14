
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:fitbasix/feature/posts/model/UserModel.dart';
import 'package:fitbasix/feature/posts/model/suggestion_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  RxList<AssetEntity> assets = RxList();
  RxList<bool> mediaSelection = <bool>[false].obs;
  RxList<AssetEntity> selectedMediaIndex = RxList<AssetEntity>([]);
  RxList<AssetPathEntity> foldersAvailable = RxList<AssetPathEntity>([]);
  RxInt selectedFolder = 0.obs;
  RxInt lastSelectedMediaIndex = RxInt(0);
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
  Rx<File> imageFile = File('').obs;
  Rx<File> videoFile = File('').obs;
  RxList<File> selectedMediaFileIndex = RxList<File>([]);
  RxList<File>? selectedMediaFiles = RxList<File>([]);
  RxString postId = "".obs;

  Future<List<AssetEntity>> fetchAssets({required int presentPage}) async {
    lastPage.value = currentPage.value;
    foldersAvailable.value = await PhotoManager.getAssetPathList();
    print(foldersAvailable[0]);
    final assetList = await foldersAvailable.value[selectedFolder.value]
        .getAssetListPaged(currentPage.value, 100);

    // final assetList = await recentAlbum.getAssetListRange(
    //   start: start,
    //   end: end,
    // );
    currentPage++;

    return assetList;
  }

  Future<void> setFolderIndex({required int index}) async {
    selectedFolder.value = index;
    currentPage.value = 0;
    print(selectedFolder.value);
    assets.value = await foldersAvailable.value[selectedFolder.value]
        .getAssetListPaged(currentPage.value, 100);
    imageCache!.clear();
    imageCache!.clearLiveImages();
    print(assets.value);
  }

  void toggleDropDownExpansion() {
    isDropDownExpanded.value = !isDropDownExpanded.value;
  }

  List<bool> getSelectedMedia(AssetEntity? index) {
    int length = 10;
    index == 100
        ? selectedMediaIndex.removeRange(0, 0)
        : selectedMediaIndex.contains(index)
            ? selectedMediaIndex.remove(index)
            : selectedMediaIndex.add(index!);
    List<bool> selectedOption = [];
    for (int i = 0; i < length; i++) {
      if (selectedMediaIndex.length == 0) {
        selectedOption.add(false);
      } else {
        if (selectedMediaIndex.contains(i)) {
          selectedOption.add(true);
        } else {
          selectedOption.add(false);
        }
      }
    }
    selectedMedia!.value = selectedOption;
    return selectedMedia!;
  }
  List<File>? getSelectedMediaFiles(File? index) {
    int length = 10;
    index == 100
        ? selectedMediaFileIndex.removeRange(0, 0)
        : selectedMediaFileIndex.contains(index)
            ? selectedMediaFileIndex.remove(index)
            : selectedMediaFileIndex.add(index!);
    List<File> selectedMediaFile = [];
    File? x;
    for (int i = 0; i < selectedMediaFileIndex.length; i++) {
      if (selectedMediaFileIndex.length == 0) {
        return null;
      } else {
        // print(index.path)

        if (selectedMediaFileIndex.contains(index)) {
          print(index!.path);
          selectedMediaFile.add(index);
        } else {
          print('After' + index!.path);
          selectedMediaFile.remove(index);
          // selectedMediaFile.add(x!);
        }
      }
    }
    selectedMediaFiles!.value = selectedMediaFile;
    return selectedMediaFile;
  }

 
  // List<bool> getSelectedPeople(int index) {
  //   int length = 10;
  //   index == 100
  //       ? selectedPeopleIndex.removeRange(0, 0)
  //       : selectedPeopleIndex.contains(index)
  //           ? selectedPeopleIndex.remove(index)
  //           : selectedPeopleIndex.add(index);
  //   List<bool> selectedOption = [];
  //   for (int i = 0; i < length; i++) {
  //     if (selectedPeopleIndex.length == 0) {
  //       selectedOption.add(false);
  //     } else {
  //       if (selectedPeopleIndex.contains(i)) {
  //         selectedOption.add(true);
  //       } else {
  //         selectedOption.add(false);
  //       }
  //     }
  //   }
  //
  //   selectedPeople!.value = selectedOption;
  //   return selectedPeople!;
  // }

  Future pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);

      imageFile.value = imageTemporary;
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

  @override
  Future<void> onInit() async {
    assets.value = await fetchAssets(presentPage: currentPage.value);
    super.onInit();
  }
}
