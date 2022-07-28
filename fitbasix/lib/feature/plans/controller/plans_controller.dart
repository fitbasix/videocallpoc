import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/plans/view/widget/add_card_details.dart';
import 'package:fitbasix/feature/plans/view/widget/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlansController extends GetxController {
  RxBool saveCreditCardInfo = true.obs;
  RxInt pageIndex = 0.obs;

  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryDateController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  String? cardNameErrortext;
  String? cardNumberErrortext;
  String? cardExpiryDateErrortext;
  String? cardCvvErrortext;

  TrainerController trainerController = Get.find<TrainerController>();

  Plan? selectedPlan;

  String selectedTime = '';

  var pageList = <Widget>[];

  setListValue() {
    pageList = [
      AddCardDetails(),
      CheckoutPage(),
    ];
  }

  void validateCardExpiryDate(){
    var dayYear = cardExpiryDateController.text.split('/');

    if(int.parse(dayYear[0]) < int.parse(DateFormat("dd-MM-yy").format(DateTime.now()).split('-')[2])){
      cardExpiryDateErrortext = "Invalid Expiry Date";
    }
    else if(int.parse(dayYear[1])>12 || int.parse(dayYear[1])<1){
      cardExpiryDateErrortext = "Invalid Expiry Date";
    }
    else{
      cardExpiryDateErrortext = null;
    }
  }

  void validateCardName() {
    if (cardNameController.text.isEmpty) {
      cardNameErrortext = "Field Required";
    } else {
      cardNameErrortext = null;
    }
    update(['card-name-field']);
  }

  void validateCardNumber() {
    if (cardNumberController.text.isEmpty) {
      cardNumberErrortext = "Field Required";
    } else {
      cardNumberErrortext = null;
    }
    update(['card-number-field']);
  }

  void validateCardNumberLength() {
    if (cardNumberController.text.length < 19) {
      cardNumberErrortext = "Invalid Card Number";
    } else {
      cardNumberErrortext = null;
    }
    update(['card-number-field']);
  }

  void validateCardExpiry() {
    if (cardExpiryDateController.text.isEmpty) {
      cardExpiryDateErrortext = "Field Required";
    } else {
      cardExpiryDateErrortext = null;
    }
    update(['card-expiry-field']);
  }

  void validateCardCvv() {
    if (cardCvvController.text.isEmpty) {
      cardCvvErrortext = "Field Required";
    } else {
      cardCvvErrortext = null;
    }
    update(['card-cvv-field']);
  }

  void clearValues() {
    cardCvvController.clear();
    cardCvvErrortext = null;
    cardExpiryDateController.clear();
    cardExpiryDateErrortext = null;
    cardNumberController.clear();
    cardNumberErrortext = null;
    cardNameController.clear();
    cardNameErrortext = null;
    pageIndex.value = 0;
  }
  @override
  void onInit() {
    getSelectedTime();
    super.onInit();
  }

  void getSelectedTime() async{

    var output =
        await TrainerServices.getAllTimeSlot();

    selectedTime = trainerController.getTime(
        output.response!.data![trainerController
            .availableTime
            .value
            .response!
            .data![0]
            .time![Get.find<TrainerController>().selectedTimeSlot.value]]
            .name!);
    update();
  }

  String getSelectedDays(){
    var daysIndex = [];
    var days = '';

    for (var selected in Get.find<TrainerController>().selectedDays.value) {
      for (var available in Get.find<TrainerController>().weekAvailableSlots) {
        if (selected == available.id) {
          daysIndex.add(available.day);
        }
      }
    }
    daysIndex.sort();
    for(var day in daysIndex){
      days += "${trainerController.numberToDay[day]!} ";
    }
    return days;
  }


  @override
  void dispose() {
    pageIndex.value = 0;
    super.dispose();
  }
}
