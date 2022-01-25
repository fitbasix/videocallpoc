import 'package:fitbasix/feature/spg/model/goal_model.dart';
import 'package:fitbasix/feature/spg/model/spg_model.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:get/get.dart';

class SPGController extends GetxController {
  RxInt selectedGoalIndex = RxInt(0);

  RxList<bool> goalSelection = <bool>[true].obs;

  Rx<SpgModel> spgData = SpgModel().obs;
  RxBool isLoading = RxBool(false);

  List<bool> updatedGoalStatus(int index) {
    int length = goalModel.length;
    List<bool> selecteOption = [];
    for (int i = 0; i < length; i++) {
      if (i == index) {
        selecteOption.add(true);
      } else {
        selecteOption.add(false);
      }
    }
    goalSelection.value = selecteOption;
    return goalSelection;
  }

  Future<void> setup() async {
    isLoading.value = true;
    spgData.value = await SPGService.getSPGData();
    isLoading.value = false;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
