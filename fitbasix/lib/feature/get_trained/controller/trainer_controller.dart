import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';
import 'package:get/get.dart';

class TrainerController extends GetxController {
  RxBool isSelected = RxBool(false);
  RxBool isLoading = RxBool(false);
  Rx<TrainerModel> atrainerDetail = TrainerModel().obs;
  Rx<PlanModel> planModel = PlanModel().obs;
  Rx<AllTrainer> allTrainer = AllTrainer().obs;
  Rx<AllTrainer> fitnessConsultant = AllTrainer().obs;
  Rx<AllTrainer> nutritionConsultant = AllTrainer().obs;
  Rx<InterestModel> interests = InterestModel().obs;
  RxList<bool> interestSelection = <bool>[true].obs;
  RxInt SelectedInterestIndex = RxInt(0);
  RxString pageTitle = RxString('');

  List<bool> UpdatedInterestStatus(int index) {
    int length = interests.value.response!.response!.data!.length;
    List<bool> selecteOption = [];
    for (int i = 0; i < length; i++) {
      if (i == index) {
        selecteOption.add(true);
      } else {
        selecteOption.add(false);
      }
    }
    interestSelection.value = selecteOption;
    return interestSelection;
  }

  Future<void> setUp() async {
    isLoading.value = true;
    atrainerDetail.value =
        await TrainerServices.getATrainerDetail("61d2d1422f5935456683ff4f");
    planModel.value =
        await TrainerServices.getPlanByTrainerId("61d2d1422f5935456683ff4f");
    allTrainer.value = await TrainerServices.getAllTrainer();
    fitnessConsultant.value = await TrainerServices.getFitnessConsultant();
    nutritionConsultant.value = await TrainerServices.getNutritionConsultant();

    interests.value = await TrainerServices.getAllInterest();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    setUp();
  }
}
