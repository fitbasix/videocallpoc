import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class PostController extends GetxController {
  RxList<AssetEntity> assets = RxList();
  RxList<bool> mediaSelection = <bool>[false].obs;
  RxList<int> selectedMediaIndex = RxList<int>([]);
  RxInt lastSelectedMediaIndex = RxInt(0);
  RxList<bool>? selectedMedia = RxList<bool>([]);
  RxList<int> selectedMediaCount = RxList<int>([]);
  RxInt count = RxInt(0);
  RxInt currentPage = RxInt(0);
  RxInt lastPage = RxInt(0);

  Future<List<AssetEntity>> fetchAssets({required int presentPage}) async {
    lastPage.value = currentPage.value;
    final albums = await PhotoManager.getAssetPathList();
    print(albums);
    final recentAlbum = albums.first;

    final assetList =
        await recentAlbum.getAssetListPaged(currentPage.value, 100);

    // final assetList = await recentAlbum.getAssetListRange(
    //   start: start,
    //   end: end,
    // );
    currentPage++;

    return assetList;
  }

  List<bool> getSelectedMedia(int index) {
    int length = 10;
    index == 100
        ? selectedMediaIndex.removeRange(0, 0)
        : selectedMediaIndex.contains(index)
            ? selectedMediaIndex.remove(index)
            : selectedMediaIndex.add(index);
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
