import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

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

  Future<List<AssetEntity>> fetchAssets({required int presentPage}) async {
    lastPage.value = currentPage.value;
    print("vartika");
    foldersAvailable.value = await PhotoManager.getAssetPathList();
    print(foldersAvailable[0]);
    print("vartika");
    final assetList = await foldersAvailable.value[selectedFolder.value]
        .getAssetListPaged(currentPage.value, 100);
    print("yyy" + assetList.toString());

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

  @override
  Future<void> onInit() async {
    assets.value = await fetchAssets(presentPage: currentPage.value);
    super.onInit();
  }
}
