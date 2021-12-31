import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';
import 'package:get/get.dart';

class TrainerController extends GetxController {
  RxBool isSelected = RxBool(false);
  RxBool isLoading = RxBool(false);
  Rx<TrainerModel> atrainerDetail = TrainerModel().obs;
  Rx<PlanModel> planModel = PlanModel().obs;
  Future<void> setUp() async {
    isLoading.value = true;
    atrainerDetail.value =
        await TrainerServices.getATrainerDetail("61cc5480a5b7783739835ba2");
    planModel.value=await TrainerServices.getPlanByTrainerId("61cc5480a5b7783739835ba2");
    isLoading.value = false;
  }

  @override
  void onInit() {
    // TrainerServices.getTrainerById();
    super.onInit();
    setUp();
  }
}
