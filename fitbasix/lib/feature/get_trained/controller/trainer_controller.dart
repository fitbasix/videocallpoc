import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/get_trained_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/get_trained/model/sortbymodel.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../plans/models/AvailableSlot.dart';
import '../../plans/models/FullPlanDetailModel.dart';
import '../../plans/models/allTimeSlot.dart';

class TrainerController extends GetxController {
  var fromTimeForFilter = DateTime.now().obs;
  var toTimeForFilter = DateTime.now().obs;
  RxBool isSelected = RxBool(false);
  RxBool isLoading = RxBool(false);
  Rx<Trainer> atrainerDetail = Trainer().obs;
  Rx<bool> isPlanLoading = RxBool(false);
  Rx<bool> isMyTrainerProfileLoading = RxBool(false);
  Rx<PlanModel> planModel = PlanModel().obs;
  Rx<AllTrainer> allTrainer = AllTrainer().obs;
  Rx<Plan> selectedPlan = Plan().obs;
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
  RxInt SelectedSortMethod = RxInt(-1);
  RxString searchedName = RxString('');
  RxInt currentPage = RxInt(1);
  RxBool getTrainedIsLoading = RxBool(false);
  RxBool filterIsLoading = RxBool(false);
  RxBool showLoader = RxBool(false);
  RxInt slotsLeftLimit = RxInt(5);
  RxBool isProfileLoading = RxBool(false);
  RxInt currentPostPage = RxInt(1);
  RxList<Post> trainerPostList = RxList<Post>([]);
  Rx<PostsModel> initialPostData = Rx(PostsModel());
  RxBool loadingIndicator = RxBool(false);
  Rx<PlanFullDetails> fullPlanDetails = PlanFullDetails().obs;
  RxBool fullPlanInfoLoading = true.obs;
  RxString selectedPlanId = "".obs;
  Rx<AvailableSlot> availableSlots = AvailableSlot().obs;
  RxList<TimeSlot> getAllSlots = <TimeSlot>[].obs;
  RxBool isAvailableSlotDataLoading = false.obs;
  RxInt TimeSlotSelected = RxInt(-1);
  RxList<Slot> weekAvailableSlots = <Slot>[].obs;
  Rx<int> selectedTimeSlot = 0.obs;
  RxList<String> selectedDays = <String>[].obs;
  RxList<String> enrolledTrainer = <String>[].obs;

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

  Rx<SortByModel> filterOptions = SortByModel().obs;



  @override
  void onInit() {
    super.onInit();
    setUp();
  }
}
