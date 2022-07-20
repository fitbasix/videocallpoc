import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/plans/view/widget/add_card_details.dart';
import 'package:fitbasix/feature/plans/view/widget/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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



  Plan? selectedPlan;

  var pageList = <Widget>[];

  setListValue() {
    pageList = [
      AddCardDetails(),
      CheckoutPage(),
    ];
  }

  String? validateCardName() {
    if (cardNameController.text.isEmpty) {
      cardNameErrortext = "Field Required";
    } else {
      cardNameErrortext = null;
    }
    update(['card-name-field']);
  }

  String? validateCardNumber() {
    if (cardNumberController.text.isEmpty) {
      cardNumberErrortext = "Field Required";
    }
    // else if (cardNumberController.text.length <16) {
    //   cardNumberErrortext = "Invalid Card Number";
    // }
    else{
      cardNumberErrortext = null;
    }
    update(['card-number-field']);
  }
  String? validateCardExpiry() {
    if (cardExpiryDateController.text.isEmpty) {
      cardExpiryDateErrortext = "Field Required";
    } else {
      cardExpiryDateErrortext = null;
    }
    update(['card-expiry-field']);
  }
  String? validateCardCvv() {
    if (cardCvvController.text.isEmpty) {
      cardCvvErrortext = "Field Required";
    } else {
      cardCvvErrortext = null;
    }
    update(['card-cvv-field']);
  }

  void clearValues(){
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
  void dispose() {
    pageIndex.value = 0;
    super.dispose();
  }
}
