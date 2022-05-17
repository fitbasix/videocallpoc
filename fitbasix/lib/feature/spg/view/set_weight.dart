import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';

class SetWeight extends StatefulWidget {

  SetWeight({Key? key}) : super(key: key);

  @override
  State<SetWeight> createState() => _SetWeightState();
}

class _SetWeightState extends State<SetWeight> {

  var userStartedEditing = false.obs;

  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  final SPGController _spgController = Get.find();

  @override
  void initState() {
    _currentWeightController.text = _spgController.currentWeight.value.toString();
    _targetWeightController.text =  _spgController.targetWeight.value.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "5", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              //height: Get.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: 2 * SizeConfig.heightMultiplier!,
                          width: Get.width,
                        ),
                  Container(
                    color: kGreenColor,
                    height: 2 * SizeConfig.heightMultiplier!,
                    width: Get.width * 0.625,
                  ),]),
                  SizedBox(
                    height: 30 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _spgController.currentWeight.value =
                                (_spgController.currentWeight.value ~/ 2).toDouble();
                            _spgController.targetWeight.value =
                                (_spgController.targetWeight.value ~/ 2).toDouble();
                            _spgController.weightType.value = "kg";
                          },
                          child: Container(
                            height: 36 * SizeConfig.heightMultiplier!,
                            width: 87 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                color: _spgController.weightType == "kg"
                                    ? kGreenColor
                                    : Theme.of(context).primaryColor,
                                border: Border.all(
                                    color: _spgController.weightType == "kg"
                                        ? Colors.transparent
                                        : lightGrey),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Center(
                                child: Text(
                              'kg'.tr,
                              style: _spgController.weightType == "kg"
                                  ? AppTextStyle.white400Text
                                  : AppTextStyle.white400Text
                                      .copyWith(color: Theme.of(context).primaryColorDark),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _spgController.currentWeight.value =
                                (_spgController.currentWeight.value * 2).toInt().toDouble();
                            _spgController.targetWeight.value = (_spgController.targetWeight.value * 2).toInt().toDouble();
                            _spgController.weightType.value = "lbs";
                          },
                          child: Container(
                            height: 36 * SizeConfig.heightMultiplier!,
                            width: 87 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                color: _spgController.weightType != "kg"
                                    ? kGreenColor
                                    : Theme.of(context).primaryColor,
                                border: Border.all(
                                    color: _spgController.weightType != "kg"
                                        ? Colors.transparent
                                        : lightGrey),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                            child: Center(
                                child: Text(
                              'lb'.tr,
                              style: _spgController.weightType != "kg"
                                  ? AppTextStyle.white400Text
                                  : AppTextStyle.white400Text
                                      .copyWith(color: lightBlack),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20 * SizeConfig.heightMultiplier!,
                  ),
                  Center(
                    child: Text(
                      'ask_weight'.tr,
                      style: AppTextStyle.boldBlackText.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: greyBorder),
                            borderRadius: BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                          ),
                          width: 135*SizeConfig.widthMultiplier!,
                          height: 72*SizeConfig.heightMultiplier!,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value){
                             if(_spgController.weightType.value == "kg"){
                               _spgController.rulerPickerController.value = (double.parse(value)).floor();
                               _spgController.currentWeight.value = double.parse(value);
                             }
                             else{
                               _spgController.rulerPickerController.value = (double.parse(value)).floor();
                               _spgController.currentWeight.value = double.parse(value);
                             }
                            },
                            controller: _currentWeightController,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            decoration: getFieldDecoration(_spgController.currentWeight.value.toString(),context),
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontSize: 48 * SizeConfig.textMultiplier!, height: 1),
                          ),
                        ),
                        // Text(
                        //   _spgController.currentWeight.value.toString(),
                        //   style: AppTextStyle.normalBlackText.copyWith(
                        //     color: Theme.of(context).textTheme.bodyText1!.color,
                        //       fontSize: 48 * SizeConfig.textMultiplier!, height: 0),
                        //   textAlign: TextAlign.center,
                        // ),
                        SizedBox(width: 3 * SizeConfig.widthMultiplier!),
                        Text(
                            _spgController.weightType.value == "kg" ? 'kg'.tr : 'lb'.tr,
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalBlackText
                                .copyWith(fontSize: 14 * SizeConfig.textMultiplier!,color: Theme.of(context).textTheme.bodyText1!.color))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => Center(
                      child: _spgController.weightType.value != "kg"
                          ? RulerPicker(
                              controller: _spgController.rulerPickerController,
                              beginValue: 30,
                              endValue: 200,
                              initValue: 60,
                              scaleLineStyleList: const [
                                ScaleLineStyle(
                                    color: kGreenColor,
                                    width: 1.5,
                                    height: 30,
                                    scale: 0),
                                ScaleLineStyle(
                                    color: kGreenColor, width: 1, height: 15, scale: -1)
                              ],
                        marker: Container(
                            width: 1.5 * SizeConfig.widthMultiplier!,
                            height: 50 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5))),
                              onBuildRulerScalueText: (index, scaleValue) {
                                return (scaleValue * 2).toInt().toString() + "lbs";
                              },
                              onValueChange: (value) {
                                userStartedEditing.value = true;
                                _spgController.currentWeight.value = value * 2;
                                _currentWeightController.text = (value*2).toString();
                              },
                              width: MediaQuery.of(context).size.width -
                                  48 * SizeConfig.widthMultiplier!,
                              height: 100 * SizeConfig.heightMultiplier!,
                              rulerScaleTextStyle: AppTextStyle.normalGreenText,
                              rulerBackgroundColor: LightGreen,
                              rulerMarginTop: 15,
                            )
                          : RulerPicker(
                              controller: _spgController.rulerPickerController,
                              beginValue: 30,
                              endValue: 200,
                              initValue: _spgController.currentWeight.value.round(),
                        marker: Container(
                            width: 1.5 * SizeConfig.widthMultiplier!,
                            height: 50 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5))),
                              scaleLineStyleList: const [
                                ScaleLineStyle(
                                    color: kGreenColor,
                                    width: 1.5,
                                    height: 30,
                                    scale: 0),
                                ScaleLineStyle(
                                    color: kGreenColor, width: 1, height: 15, scale: -1)
                              ],
                              onBuildRulerScalueText: (index, scaleValue) {
                                return (scaleValue).toInt().toString() + "kg";
                              },
                              onValueChange: (value) {
                                userStartedEditing.value = true;
                                _spgController.currentWeight.value = value.toDouble();
                                _currentWeightController.text = value.toString();
                              },
                              width: MediaQuery.of(context).size.width -
                                  48 * SizeConfig.widthMultiplier!,
                              height: 100 * SizeConfig.heightMultiplier!,
                              rulerScaleTextStyle: AppTextStyle.normalGreenText,
                              rulerBackgroundColor: LightGreen,
                              rulerMarginTop: 15,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 30 * SizeConfig.heightMultiplier!,
                  ),
                  Center(
                    child: Text(
                      'ask_target_weight'.tr,
                      style: AppTextStyle.boldBlackText.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: greyBorder),
                            borderRadius: BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                          ),
                          width: 135*SizeConfig.widthMultiplier!,
                          height: 72*SizeConfig.heightMultiplier!,
                          child: TextFormField(
                            onChanged: (value){
                              if(_spgController.weightType.value == "kg"){
                                _spgController.targetRulerPickerController.value = (double.parse(value)).floor();
                                _spgController.targetWeight.value = (double.parse(value));
                              }
                              else{
                                _spgController.targetRulerPickerController.value = (double.parse(value*2)).floor();
                                _spgController.targetWeight.value = ((double.parse(value)*2));
                              }
                            },
                            controller: _targetWeightController,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            decoration: getFieldDecoration(_spgController.currentWeight.value.toString(),context),
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontSize: 48 * SizeConfig.textMultiplier!, height: 1),
                          ),
                        ),
                        // Text(
                        //   _spgController.targetWeight.value.toString(),
                        //   style: AppTextStyle.normalBlackText.copyWith(
                        //     color: Theme.of(context).textTheme.bodyText1!.color,
                        //       fontSize: 48 * SizeConfig.textMultiplier!, height: 0),
                        // ),
                        SizedBox(width: 3 * SizeConfig.widthMultiplier!),
                        Text(
                            _spgController.weightType.value == "kg" ? 'kg'.tr : 'lb'.tr,
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalBlackText
                                .copyWith(fontSize: 14 * SizeConfig.textMultiplier!,color: Theme.of(context).textTheme.bodyText1!.color))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => Center(
                      child: _spgController.weightType.value != "kg"
                          ? RulerPicker(
                              controller: _spgController.targetRulerPickerController,
                              beginValue: 30,
                              endValue: 200,
                              initValue: _spgController.targetWeight.value.round(),
                              scaleLineStyleList: const [
                                ScaleLineStyle(
                                    color: kGreenColor,
                                    width: 1.5,
                                    height: 30,
                                    scale: 0),
                                ScaleLineStyle(
                                    color: kGreenColor, width: 1, height: 15, scale: -1)
                              ],
                              onBuildRulerScalueText: (index, scaleValue) {
                                return (scaleValue * 2).toInt().toString() + "lbs";
                              },
                              onValueChange: (value) {
                                userStartedEditing.value = true;
                                _spgController.targetWeight.value = value * 2;
                                _targetWeightController.text = (value*2).toString();
                              },
                            marker: Container(
                            width: 1.5 * SizeConfig.widthMultiplier!,
                            height: 50 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5))),
                              width: MediaQuery.of(context).size.width -
                                  48 * SizeConfig.widthMultiplier!,
                              height: 100 * SizeConfig.heightMultiplier!,
                              rulerScaleTextStyle: AppTextStyle.normalGreenText,
                              rulerBackgroundColor: LightGreen,
                              rulerMarginTop: 15,
                            )
                          : RulerPicker(
                              controller: _spgController.targetRulerPickerController,
                              beginValue: 30,
                              endValue: 200,
                              initValue: _spgController.targetWeight.value.round(),
                              onBuildRulerScalueText: (index, scaleValue) {
                                return (scaleValue).toInt().toString() + "kg";
                              },
                            marker: Container(
                            width: 1.5 * SizeConfig.widthMultiplier!,
                            height: 50 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5))),
                              scaleLineStyleList: const [
                                ScaleLineStyle(
                                    color: kGreenColor,
                                    width: 1.5,
                                    height: 30,
                                    scale: 0),
                                ScaleLineStyle(
                                    color: kGreenColor, width: 1, height: 15, scale: -1)
                              ],
                              onValueChange: (value) {
                                userStartedEditing.value = true;
                                _spgController.targetWeight.value = value.toDouble();
                                _targetWeightController.text = (value*2).toString();
                              },
                              width: MediaQuery.of(context).size.width -
                                  48 * SizeConfig.widthMultiplier!,
                              height: 100 * SizeConfig.heightMultiplier!,
                              rulerScaleTextStyle: AppTextStyle.normalGreenText,
                              rulerBackgroundColor: LightGreen,
                              rulerMarginTop: 15,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 40 * SizeConfig.heightMultiplier!,
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 16 * SizeConfig.widthMultiplier!,right: 16 * SizeConfig.widthMultiplier!,top: 16 * SizeConfig.widthMultiplier!),
              child:  Obx(
                    ()=> GestureDetector(
                  onTap:userStartedEditing.value?() {
                    if (_spgController.weightType.value == "kg") {
                      print(_spgController.targetWeight.value);
                      print(_spgController.currentWeight.value);
                    } else {
                      print((_spgController.targetWeight.value / 2.205).toInt());
                      print((_spgController.currentWeight.value / 2.205).toInt());
                    }
                    if (_spgController.selectedGenderIndex.value.serialId == 1) {
                      _spgController.bodyFatData!.value = _spgController
                          .spgData.value.response!.data!.bodyTypeMale!;
                    } else {
                      _spgController.bodyFatData!.value = _spgController
                          .spgData.value.response!.data!.bodyTypeFemale!;
                    }
                    Navigator.pushNamed(context, RouteName.setBodyFat);

                  }:null,
                  child: Container(
                    width: Get.width,
                    height: 48 * SizeConfig.heightMultiplier!,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
                      color: userStartedEditing.value?kgreen49:hintGrey,
                    ),
                    child: Center(
                      child: Text(
                        'proceed'.tr,
                        style: AppTextStyle.normalWhiteText.copyWith(
                            color: userStartedEditing.value?kPureWhite:greyBorder
                        ),
                      ),
                    ),
                  ),
                ),
              )


            // ProceedButton(
            //     title: 'proceed'.tr,
            //     onPressed: () {
            //       if (_spgController.weightType.value == "kg") {
            //         print(_spgController.targetWeight.value);
            //         print(_spgController.currentWeight.value);
            //       } else {
            //         print((_spgController.targetWeight.value / 2.205).toInt());
            //         print((_spgController.currentWeight.value / 2.205).toInt());
            //       }
            //       if (_spgController.selectedGenderIndex.value.serialId == 1) {
            //         _spgController.bodyFatData!.value = _spgController
            //             .spgData.value.response!.data!.bodyTypeMale!;
            //       } else {
            //         _spgController.bodyFatData!.value = _spgController
            //             .spgData.value.response!.data!.bodyTypeFemale!;
            //       }
            //       Navigator.pushNamed(context, RouteName.setBodyFat);
            //     }),
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }

  InputDecoration getFieldDecoration(String hint,BuildContext context){
    return InputDecoration(
        isDense: true,
        counter: Container(
          height: 0,
        ),
        contentPadding: EdgeInsets.only(top: 15*SizeConfig.heightMultiplier!),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: InputBorder.none,
        //hintText: hint,
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(
        //       Radius.circular(8 * SizeConfig.heightMultiplier!)),
        //   borderSide: BorderSide(
        //       color:
        //           isTextFieldActive == null ? kGreenColor : kGreyLightShade,
        //       width: 1.0),
        // ),
        hintStyle: AppTextStyle.normalBlackText.copyWith(
    color: Theme.of(context).textTheme.bodyText1!.color,
    fontSize: 48 * SizeConfig.textMultiplier!, height: 1),);
  }
}


