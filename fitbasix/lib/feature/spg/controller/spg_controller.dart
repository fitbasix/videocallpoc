import 'package:fitbasix/feature/spg/model/spg_model.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';

class SPGController extends GetxController {
  RxInt selectedGoalIndex = RxInt(0);
  RxList<bool> goalSelection = <bool>[true].obs;
  Rx<SpgModel> spgData = SpgModel().obs;
  RxBool isLoading = RxBool(false);
  RxInt selectedGenderIndex = RxInt(0);
  RxList<bool> genderSelection = <bool>[true].obs;
  final rulerPickerController = RulerPickerController(value: 0);
  RxInt currentWeight = 50.obs;
  final targetRulerPickerController = RulerPickerController(value: 0);
  RxInt targetWeight = 50.obs;

  List<bool> updatedGoalStatus(int index) {
    int length = spgData.value.response!.data!.goalType!.length;
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

  List<bool> updatedGenderStatus(int index) {
    int length = spgData.value.response!.data!.genderType!.length;
    List<bool> selecteOption = [];
    for (int i = 0; i < length; i++) {
      if (i == index) {
        selecteOption.add(true);
      } else {
        selecteOption.add(false);
      }
    }
    genderSelection.value = selecteOption;
    return genderSelection;
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
