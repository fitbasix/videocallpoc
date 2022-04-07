import 'dart:developer';

import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/get_trained_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/get_trained/model/sortbymodel.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../plans/models/AvailableSlot.dart';
import '../../plans/models/AvailableTimeModel.dart';
import '../../plans/models/FullPlanDetailModel.dart';
import '../../plans/models/allTimeSlot.dart';
import '../model/timing_model.dart';

class TrainerController extends GetxController {
  RxBool isMyTrainerNeedToLoadData = true.obs;
  RxBool showLoaderOnMyTrainer = false.obs;

  var currentMyTrainerPage = 0.obs;

  var fromTimeForFilter = DateTime.now().obs;
  var toTimeForFilter = DateTime.now().obs;
  RxBool isSelected = RxBool(false);
  RxBool isLoading = RxBool(false);
  Rx<Trainer> atrainerDetail = Trainer().obs;
  Rx<bool> isPlanLoading = RxBool(true);
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
  RxBool isMyTrainerSearchActive = RxBool(false);

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchMyTrainerController =
      TextEditingController();
  RxString search = RxString('');
  RxString searchMyTrainer = RxString('');
  RxInt trainerType = RxInt(0);
  RxInt SelectedInterestIndex = RxInt(0);
  RxInt SelectedSortMethod = RxInt(-1);
  RxString searchedName = RxString('');
  RxString searchedMyTrainerName = RxString('');
  RxInt currentPage = RxInt(1);
  RxBool getTrainedIsLoading = RxBool(false);
  RxBool filterIsLoading = RxBool(false);
  RxBool trainerFilterIsLoading = RxBool(false);
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
  Rx<TimeModel> availableTime = TimeModel().obs;
  RxList<TimeSlot> getAllSlots = <TimeSlot>[].obs;
  RxBool isAvailableSlotDataLoading = false.obs;
  RxInt TimeSlotSelected = RxInt(-1);
  RxList<Slot> weekAvailableSlots = <Slot>[].obs;
  Rx<int> selectedTimeSlot = 0.obs;
  RxList<String> selectedDays = <String>[].obs;
  RxList<String> enrolledTrainer = <String>[].obs;
  Rx<TimingModel> timingModel = TimingModel().obs;
  RxBool isTiming = false.obs;
  RxList<int> availability = <int>[].obs;
  Map<String, int> daysInt = {
    "Sun": 0,
    "Mon": 1,
    "Tue": 2,
    "Wed": 3,
    "Thu": 4,
    "Fri": 5,
    "Sat": 6,
  };
  Map<int, String> numberToDay = {
    0: "Sun",
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
  };

  bool isVideoAvailable(String time) {
    List<String> times = time.split("_");
    // var inputFormat = DateFormat('dd/MM/yyyy');
    TimeOfDay inputDate1 =
        TimeOfDay.fromDateTime(DateTime.parse(times[0]).toLocal());
    TimeOfDay inputDate2 =
        TimeOfDay.fromDateTime(DateTime.parse(times[1]).toLocal());
    TimeOfDay now = TimeOfDay.now();
    int nowInMinutes = now.hour * 60 + now.minute;
    int time1 = inputDate1.hour * 60 + inputDate1.minute;
    int time2 = inputDate2.hour * 60 + inputDate2.minute;
    log(nowInMinutes.toString() +
        '  ' +
        time1.toString() +
        " " +
        time2.toString());
    if (time1 < nowInMinutes && time2 > nowInMinutes) {
      return true;
    }

    return false;
  }

  String GetDays(List<int>? days) {
    String day = "";
    for (int i = 0; i < days!.length; i++) {
      log(days[i].toString());
      day = day + (day == "" ? "" : " , ") + numberToDay[days[i]]!.toString();
    }
    return day;
  }

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

  String getTime(String time) {
    List<String> times = time.split("_");
    // var inputFormat = DateFormat('dd/MM/yyyy');
    String inputDate1 = DateFormat("hh:mm aaa")
        .format(DateTime.parse(times[0]).toLocal())
        .split(" ")[0];
    String inputDate2 =
        DateFormat("hh:mm aaa").format(DateTime.parse(times[1]).toLocal());
    log(inputDate1 + "  " + inputDate2);
    return inputDate1 + "-" + inputDate2;
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
