import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/plans/controller/plans_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class AddCardDetails extends StatelessWidget {
  AddCardDetails({Key? key}) : super(key: key);

  final PlansController _plansController = Get.find<PlansController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
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
                    Text(
                      "Credit or Debit Card",
                      style: AppTextStyle.normalWhiteText
                          .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 28 * SizeConfig.heightMultiplier!,
              ),
              Text(
                "Card details",
                style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                    fontSize: 18 * SizeConfig.textMultiplier!,
                    color: Theme.of(context).textTheme.bodyText1?.color),
              ),
              SizedBox(height: 16 * SizeConfig.heightMultiplier!),
              GetBuilder<PlansController>(
                  id: 'card-name-field',
                  builder: (controller) {
                    return TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _plansController.cardNameController,
                      onChanged: (value) {
                        _plansController.validateCardName();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
                      ],
                      style: AppTextStyle.normalBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                      decoration: InputDecoration(
                        hintText: "Name on Card",
                        errorText: _plansController.cardNameErrortext,
                        hintStyle: AppTextStyle.grey400Text.copyWith(
                            fontSize: 16 * SizeConfig.heightMultiplier!),
                        contentPadding: EdgeInsets.fromLTRB(
                            12 * SizeConfig.widthMultiplier!,
                            14 * SizeConfig.heightMultiplier!,
                            0,
                            14 * SizeConfig.heightMultiplier!),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                      ),
                    );
                  }),
              SizedBox(height: 16 * SizeConfig.heightMultiplier!),
              GetBuilder<PlansController>(
                  id: 'card-number-field',
                  builder: (controller) {
                    return TextFormField(
                      controller: _plansController.cardNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _plansController.validateCardNumber();
                      },
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xxxx xxxx xxxx xxxx',
                          separator: ' ',
                        ),
                      ],
                      style: AppTextStyle.normalBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                      decoration: InputDecoration(
                        errorText: _plansController.cardNumberErrortext,
                        hintText: "Card number",
                        hintStyle: AppTextStyle.grey400Text.copyWith(
                            fontSize: 16 * SizeConfig.heightMultiplier!),
                        contentPadding: EdgeInsets.fromLTRB(
                            12 * SizeConfig.widthMultiplier!,
                            14 * SizeConfig.heightMultiplier!,
                            0,
                            14 * SizeConfig.heightMultiplier!),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                      ),
                    );
                  }),
              SizedBox(height: 16 * SizeConfig.heightMultiplier!),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GetBuilder<PlansController>(
                        id: 'card-expiry-field',
                        builder: (controller) {
                          return TextFormField(
                            keyboardType: TextInputType.number,
                            controller:
                                _plansController.cardExpiryDateController,
                            onChanged: (value) {
                              _plansController.validateCardExpiry();
                            },
                            inputFormatters: [
                              MaskedTextInputFormatter(
                                mask: 'xx/xx',
                                separator: '/',
                              )
                            ],
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color),
                            decoration: InputDecoration(
                              hintText: "YY/MM",
                              errorText:
                                  _plansController.cardExpiryDateErrortext,
                              hintStyle: AppTextStyle.grey400Text.copyWith(
                                  fontSize: 16 * SizeConfig.heightMultiplier!),
                              contentPadding: EdgeInsets.fromLTRB(
                                  12 * SizeConfig.widthMultiplier!,
                                  14 * SizeConfig.heightMultiplier!,
                                  0,
                                  14 * SizeConfig.heightMultiplier!),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(0.4),
                                    width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.0),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(width: 25 * SizeConfig.widthMultiplier!),
                  Expanded(
                    child: GetBuilder<PlansController>(
                        id: 'card-cvv-field',
                        builder: (controller) {
                          return TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _plansController.cardCvvController,
                            onChanged: (value) {
                              _plansController.validateCardCvv();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              MaskedTextInputFormatter(
                                mask: 'xxx',
                                separator: '-',
                              )
                            ],
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color),
                            decoration: InputDecoration(
                              errorText: _plansController.cardCvvErrortext,
                              hintText: "CVV",
                              hintStyle: AppTextStyle.grey400Text.copyWith(
                                  fontSize: 16 * SizeConfig.heightMultiplier!),
                              contentPadding: EdgeInsets.fromLTRB(
                                  12 * SizeConfig.widthMultiplier!,
                                  14 * SizeConfig.heightMultiplier!,
                                  0,
                                  14 * SizeConfig.heightMultiplier!),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(0.4),
                                    width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.widthMultiplier!),
                                borderSide:
                                    BorderSide(color: greyBorder, width: 1.0),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 50 * SizeConfig.heightMultiplier!,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Save credit card information for next time",
                    ),
                  ),
                  SizedBox(
                    width: 15 * SizeConfig.widthMultiplier!,
                  ),
                  Obx(
                    () => Switch(
                      value: _plansController.saveCreditCardInfo.value,
                      onChanged: (value) {
                        _plansController.saveCreditCardInfo.value = value;
                      },
                      activeColor: kGreenColor,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        ProceedButton(
          onPressed: () {
            _plansController.validateCardCvv();
            _plansController.validateCardExpiry();
            _plansController.validateCardNumber();
            _plansController.validateCardName();
            _plansController.validateCardNumberLength();
            if (_plansController.cardNameErrortext == null &&
                _plansController.cardNumberErrortext == null &&
                _plansController.cardExpiryDateErrortext == null &&
                _plansController.cardCvvErrortext == null) {
              _plansController.pageIndex.value += 1;
            }
          },
          title: 'Save Changes',
        ),
        SizedBox(
          height: 15 * SizeConfig.heightMultiplier!,
        ),
      ],
    );
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
