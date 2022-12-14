import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/model/spg_model.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:flutter_holo_date_picker/date_time_formatter.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';

class SPGController extends GetxController {
  Rx<Type> selectedGoalIndex = Type().obs;
  RxList<bool> goalSelection = <bool>[true].obs;
  Rx<SpgModel> spgData = SpgModel().obs;
  RxList<BodyType>? bodyFatData = <BodyType>[].obs;
  RxBool isLoading = RxBool(false);
  Rx<Type> selectedGenderIndex = Type().obs;
  RxList<bool> genderSelection = <bool>[true].obs;
  final rulerPickerController = RulerPickerController(value: 2);
  final poundsRulerPickerController = RulerPickerController();
  RxDouble currentWeight = 65.0.obs;
  RxInt currentHeight = 170.obs;
  final targetRulerPickerController = RulerPickerController(value: 0);
  final heightRulerPickerController = RulerPickerController(value: 0);
  RxDouble targetWeight = 65.0.obs;
  Rx<GoalData> personalGoal = GoalData().obs;
  RxString selectedDate = DateTime(1999).toString().obs;
  Rx<BodyType> selectedBodyFat = BodyType().obs;
  RxString heightType = "inch".obs;
  RxString weightType = "kg".obs;
  Rx<Type> selectedFoodIndex = Type().obs;
  RxList<bool> foodSelection = <bool>[true].obs;
  RxDouble activityNumber = RxDouble(0);

  final HomeController homeController = Get.find();
  // final DateTimeFormatter formatter =
  //     DateTimeFormatter.isDayFormat("'yyyy-MM-dd'");

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

  void UpdatedData(String) {}

  // List<bool> updateFoodType(int index) {
  //   int length = spgData.value.response!.data!.foodType!.length;
  //   List<bool> selecteOption = [];
  //   for (int i = 0; i < length; i++) {
  //     if (i == index) {
  //       selecteOption.add(true);
  //     } else {
  //       selecteOption.add(false);
  //     }
  //   }
  //   foodSelection.value = selecteOption;
  //   return foodSelection;
  // }

  Future<void> setup() async {
    isLoading.value = true;
    spgData.value = await SPGService.getSPGData();
    bodyFatData!.value = spgData.value.response!.data!.bodyTypeMale!;
    await homeController.getspgData();
    isLoading.value = false;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
