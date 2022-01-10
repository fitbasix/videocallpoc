import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/get_trained_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainerController extends GetxController {
  RxBool isSelected = RxBool(false);
  RxBool isLoading = RxBool(false);
  Rx<Trainer> atrainerDetail = Trainer().obs;
  Rx<PlanModel> planModel = PlanModel().obs;
  Rx<AllTrainer> allTrainer = AllTrainer().obs;
  // Rx<AllTrainer> fitnessConsultant = AllTrainer().obs;
  // Rx<AllTrainer> nutritionConsultant = AllTrainer().obs;
  // Rx<AllTrainer> trainer = AllTrainer().obs;
  Rx<GetTrainerModel> trainers = GetTrainerModel().obs;
  Rx<InterestModel> interests = InterestModel().obs;
  RxList<bool> interestSelection = <bool>[true].obs;
  RxString pageTitle = RxString('');
  RxBool isSearchActive = RxBool(false);
  final TextEditingController searchController = TextEditingController();
  RxString search = RxString('');
  RxInt trainerType = RxInt(0);
  RxInt SelectedInterestIndex = RxInt(0);
  RxString searchedName=RxString('');
  RxInt currentPage = RxInt(1);
  RxBool getTrainedIsLoading = RxBool(false);
  RxBool filterIsLoading = RxBool(false);
  RxBool showLoader = RxBool(false);
  RxInt slotsLeftLimit = RxInt(5);
  RxBool isProfileLoading = RxBool(false);

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
    getTrainedIsLoading.value = true;
    trainers.value = await TrainerServices.getTrainers();

    interests.value = await TrainerServices.getAllInterest();
    getTrainedIsLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    setUp();
  }
}
