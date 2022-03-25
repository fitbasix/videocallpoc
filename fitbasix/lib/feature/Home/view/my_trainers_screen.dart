import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/get_trained_model.dart';
import 'package:fitbasix/feature/message/view/my_trainer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/Home_Controller.dart';

class MyTrainersScreen extends StatelessWidget {
  MyTrainersScreen({Key? key}) : super(key: key);
  var userChatsHistory = [QBDialog()].obs;
  TrainerController _trainerController = Get.find();



  @override
  Widget build(BuildContext context) {
    List<MyTrainer> _myTrainers = _trainerController.trainers.value.response!.data!.myTrainers!;
    fetchAllChatOfUser();
    return Scaffold(
      body: Obx(()=>
         Center(
            child: userChatsHistory[0].id!=null||_myTrainers.length>0
                ? MyTrainerTileScreen(chatHistoryList: userChatsHistory,myTrainers: _myTrainers,)
                : NoTrainerScreen()),
      ),

    );
  }

  void fetchAllChatOfUser() async {
    QBSort sort = QBSort();
    sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
    sort.ascending = true;
    try {
      List<QBDialog?> dialogs = await QB.chat.getDialogs(sort: sort,).then((value) {
        if(value.isNotEmpty){
          userChatsHistory.value = List.from(value);
        }
        return value;
      });
    } catch (e) {
      print(e);
    }
  }

}

class NoTrainerScreen extends StatelessWidget {
  const NoTrainerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Padding(
            padding: EdgeInsets.only(left: 5*SizeConfig.widthMultiplier!),
            child: Text('my_trainer'.tr, style: AppTextStyle.hblack600Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color))),
        actions: [
          IconButton(
              onPressed: () {
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
                size: 25 * SizeConfig.heightMultiplier!,
              )),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: 25 * SizeConfig.widthMultiplier!,
              vertical: 40 * SizeConfig.heightMultiplier!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              SvgPicture.asset(ImagePath.notrainerenrollframe,
                  fit: BoxFit.contain,
                  //  width: 360 * SizeConfig.widthMultiplier!,
                  height: 200 * SizeConfig.heightMultiplier!),
              SizedBox(
                height: 26 * SizeConfig.heightMultiplier!,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 7 * SizeConfig.widthMultiplier!,
                    right: 7 * SizeConfig.widthMultiplier!),
                child: Text(
                  'notrainer_summary'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalBlackText.copyWith(color: hintGrey),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: kGreenColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity * SizeConfig.widthMultiplier!,
                height: 48 * SizeConfig.heightMultiplier!,
                child: TextButton(

                  onPressed: () {
                  //   Navigator.pushNamed(context, RouteName.trainerplanScreen);
                  //  Navigator.pushNamed(context, RouteName.planInformationScreen);
                  // Navigator.pushNamed(context, RouteName.planTimingScreen);

                  },
                  child:
                      Text('explore_trainers'.tr, style: AppTextStyle.hboldWhiteText),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnrollTrainerDialog extends StatelessWidget {
  const EnrollTrainerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        insetAnimationDuration: const Duration(milliseconds: 100),
        insetPadding: EdgeInsets.fromLTRB(
          32 * SizeConfig.widthMultiplier!,
          31 * SizeConfig.heightMultiplier!,
          32 * SizeConfig.widthMultiplier!,
          31 * SizeConfig.heightMultiplier!,
        ),
        child: Container(
            // width: 296 * SizeConfig.widthMultiplier!,
            height: 426 * SizeConfig.heightMultiplier!,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 32 * SizeConfig.widthMultiplier!,
                      right: 32 * SizeConfig.widthMultiplier!,
                      top: 32 * SizeConfig.heightMultiplier!,
                      bottom: 31 * SizeConfig.heightMultiplier!),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SvgPicture.asset(ImagePath.enrolltrainerFrame,
                        // width: 220 * SizeConfig.widthMultiplier!,
                        height: 168 * SizeConfig.heightMultiplier!),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        'uh_oh'.tr,
                        style: AppTextStyle.hblack600Text.copyWith(
                           color: Theme.of(context).textTheme.bodyText1?.color
                        ),
                      ),
                    ),
                    //enroll summary
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text('enroll_summary'.tr,
                          style: AppTextStyle.hblack400Text.copyWith(
                              color: Theme.of(context).textTheme.bodyText1?.color
                          ),
                          textAlign: TextAlign.center,
                      ),
                    ),
                    //enroll now text button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(39, 0, 39, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kgreen49,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 156 * SizeConfig.widthMultiplier!,
                        height: 48 * SizeConfig.heightMultiplier!,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteName.trainerplanScreen);
                          },
                          child: Text('enroll_now'.tr,
                              style: AppTextStyle.hboldWhiteText),
                        ),
                      ),
                    ),
                  ]),
                ),
                //
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      ImagePath.closedialogIcon,
                      color: Theme.of(context).primaryColor,
                      width: 16 * SizeConfig.widthMultiplier!,
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                  ),
                ),
              ],
            )));
  }
}
