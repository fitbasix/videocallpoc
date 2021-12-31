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
  Rx<InterestModel> interests = InterestModel().obs;

  Future<void> setUp() async {
    isLoading.value = true;
    // atrainerDetail.value =
    //     await TrainerServices.getATrainerDetail("61cc5480a5b7783739835ba2");
    // planModel.value =
    //     await TrainerServices.getPlanByTrainerId("61cc5480a5b7783739835ba2");
    allTrainer.value = await TrainerServices.getAllTrainer();

    // print(allTrainer.value.response!.data!.trainers![0].followers);
    // print(allTrainer.value.response!.data!.trainers![2]);

    interests.value = await TrainerServices.getAllInterest();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    setUp();
  }
}
