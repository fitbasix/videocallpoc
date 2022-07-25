import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/plans/controller/plans_controller.dart';
import 'package:fitbasix/feature/plans/view/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({Key? key}) : super(key: key);

  PlansController _plansController = Get.find<PlansController>();
  TrainerController _trainerController = Get.find<TrainerController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                height: 25 * SizeConfig.heightMultiplier!,
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      height: 50 * SizeConfig.heightMultiplier!,
                      width: 50 * SizeConfig.widthMultiplier!,
                      imageUrl: Get.find<TrainerController>()
                          .atrainerDetail
                          .value
                          .user!
                          .profilePhoto!,
                      fit: BoxFit.cover,
                      errorWidget: (context, _, __) => CircleAvatar(
                        radius: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15 * SizeConfig.widthMultiplier!,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.find<TrainerController>()
                              .atrainerDetail
                              .value
                              .user!
                              .name!.capitalizeFirst!,
                          style: AppTextStyle.boldWhiteText.copyWith(
                              fontSize: 15 * SizeConfig.textMultiplier!),
                        ),
                        Text(
                          _plansController.selectedPlan!.planName!,
                          style: AppTextStyle.grey400Text.copyWith(
                              fontSize: 13 * SizeConfig.textMultiplier!),
                        ),
                        Text(
                          "${(_plansController.selectedPlan!.planDuration! / 7).toStringAsFixed(0)} week plan",
                          style: AppTextStyle.grey400Text.copyWith(
                              fontSize: 13 * SizeConfig.textMultiplier!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * SizeConfig.widthMultiplier!,
                  ),
                  Container(
                    height: 40 * SizeConfig.heightMultiplier!,
                    width: 70 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                      color: kGreenColor,
                      borderRadius: BorderRadius.circular(
                          8 * SizeConfig.heightMultiplier!),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'AED ${_plansController.selectedPlan!.price}',
                      style: AppTextStyle.boldWhiteText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20 * SizeConfig.heightMultiplier!,
              ),
              // Text(
              //   "Selected Slots",
              //   style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
              //       fontSize: 18 * SizeConfig.textMultiplier!,
              //       color: Theme.of(context).textTheme.bodyText1?.color),
              // ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Text(
                _plansController.selectedTime.replaceFirst('-', ' - '),
                style: AppTextStyle.white400Text.copyWith(
                  fontSize: 16 * SizeConfig.textMultiplier!,
                ),
              ),
              Text(
                _plansController.getSelectedDays(),
                style: AppTextStyle.white400Text.copyWith(
                  fontSize: 16 * SizeConfig.textMultiplier!,
                  color: kGreenColor
                ),
              ),
              SizedBox(height: 16 * SizeConfig.heightMultiplier!),
              const Divider(
                color: greyBorder,
              ),

              Text(
                "Payment Method",
                style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                    fontSize: 18 * SizeConfig.textMultiplier!,
                    color: Theme.of(context).textTheme.bodyText1?.color),
              ),

              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Container(
                padding: EdgeInsets.all(
                  16 * SizeConfig.widthMultiplier!,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  border: Border.all(color: greyBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 16 * SizeConfig.widthMultiplier!,
                    ),
                    Expanded(
                      child: Text(
                        _plansController.cardNumberController.text,
                        style: AppTextStyle.normalWhiteText.copyWith(
                            fontSize: 16 * SizeConfig.textMultiplier!),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _plansController.pageIndex.value = 0;
                      },
                      child: Container(
                        height: 30 * SizeConfig.heightMultiplier!,
                        width: 70 * SizeConfig.widthMultiplier!,
                        decoration: BoxDecoration(
                          border: Border.all(color: greyBorder),
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.heightMultiplier!),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Change',
                          style: AppTextStyle.boldWhiteText.copyWith(
                            color: greyBorder,
                            fontSize: 16 * SizeConfig.textMultiplier!,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 28 * SizeConfig.heightMultiplier!,
              ),
              Text(
                "Promo Code",
                style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                    fontSize: 18 * SizeConfig.textMultiplier!,
                    color: Theme.of(context).textTheme.bodyText1?.color),
              ),
              SizedBox(height: 16 * SizeConfig.heightMultiplier!),
              TextFormField(
                onChanged: (value) {
                  //storing user input in email controller
                },
                style: AppTextStyle.normalBlackText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color),
                decoration: InputDecoration(
                  suffixIconConstraints: BoxConstraints(
                      minWidth: 80 * SizeConfig.widthMultiplier!),
                  suffixIcon: IconButton(
                    onPressed: () {

                    },
                    icon: Text(
                      'Apply',
                      style: AppTextStyle.boldWhiteText.copyWith(
                        color: greyBorder,
                        fontSize: 16 * SizeConfig.textMultiplier!,
                      ),
                    ),
                  ),
                  hintText: "Enter promo code",
                  hintStyle: AppTextStyle.grey400Text
                      .copyWith(fontSize: 16 * SizeConfig.heightMultiplier!),
                  contentPadding: EdgeInsets.fromLTRB(
                      12 * SizeConfig.widthMultiplier!,
                      14 * SizeConfig.heightMultiplier!,
                      0,
                      14 * SizeConfig.heightMultiplier!),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                    borderSide: BorderSide(color: greyBorder, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                    borderSide: BorderSide(color: greyBorder, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                    borderSide: BorderSide(
                        color: Colors.red.withOpacity(0.4), width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                    borderSide: BorderSide(color: greyBorder, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                    borderSide: BorderSide(color: greyBorder, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 28 * SizeConfig.heightMultiplier!,
              ),
              Text(
                "Bill Details",
                style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                    fontSize: 18 * SizeConfig.textMultiplier!,
                    color: Theme.of(context).textTheme.bodyText1?.color),
              ),
              const Divider(
                color: greyBorder,
              ),
              SizedBox(height: 16 * SizeConfig.heightMultiplier!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: AppTextStyle.white400Text.copyWith(
                      fontSize: 17 * SizeConfig.textMultiplier!,
                    ),
                  ),
                  Text(
                    "${_plansController.selectedPlan!.price}",
                    style: AppTextStyle.white400Text.copyWith(
                      fontSize: 17 * SizeConfig.textMultiplier!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Taxes and Charges",
                    style: AppTextStyle.white400Text.copyWith(
                      fontSize: 17 * SizeConfig.textMultiplier!,
                    ),
                  ),
                  Text(
                    "\$0",
                    style: AppTextStyle.white400Text.copyWith(
                      fontSize: 17 * SizeConfig.textMultiplier!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Coupon Discount",
                    style: AppTextStyle.white400Text.copyWith(
                      fontSize: 17 * SizeConfig.textMultiplier!,
                    ),
                  ),
                  Text(
                    "-\$0",
                    style: AppTextStyle.white400Text.copyWith(
                        fontSize: 17 * SizeConfig.textMultiplier!,
                        color: kGreenColor),
                  ),
                ],
              ),
              SizedBox(height: 30 * SizeConfig.heightMultiplier!),
              const Divider(
                color: greyBorder,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: AppTextStyle.normalPureBlackTextWithWeight600
                        .copyWith(
                            fontSize: 18 * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.bodyText1?.color),
                  ),
                  Text(
                    "${_plansController.selectedPlan!.price}",
                    style: AppTextStyle.normalPureBlackTextWithWeight600
                        .copyWith(
                            fontSize: 18 * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.bodyText1?.color),
                  ),
                ],
              ),
              SizedBox(height: 30 * SizeConfig.heightMultiplier!),
            ],
          ),
        ),
        ProceedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentWebview(
                    amount: _plansController.selectedPlan!.price.toString(),
                    cardNumber: _plansController.cardNumberController.text,
                    cardSecurityCode: _plansController.cardCvvController.text,
                    expiryDate: _plansController.cardExpiryDateController.text,
                    userName: _plansController.cardNameController.text,
                    planId: _plansController.selectedPlan!.id,
                    trainerId: _trainerController.atrainerDetail.value.user!.id,
                    planDuration: _plansController.selectedPlan!.planDuration,
                  ),
                )).then((value) {
              var response = jsonDecode(jsonEncode(value).toString())
                  as Map<String, dynamic>;
              printInfo(info: response.toString());
              if (response["response_code"] == 201) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWebview(
                        initialUrl: response["payment_link"],
                        selectedPlan: _plansController.selectedPlan,
                        planId: _plansController.selectedPlan!.id,
                        trainerId:
                            _trainerController.atrainerDetail.value.user!.id,
                      ),
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response["response_message"]),
                ));
              }
            });
          },
          title: 'Proceed to Payment',
        ),
        SizedBox(
          height: 15 * SizeConfig.heightMultiplier!,
        ),
      ],
    );
  }
}
