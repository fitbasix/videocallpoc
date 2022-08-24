import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../get_trained/model/all_trainer_model.dart';

class MySubscriptions extends StatelessWidget {
  MySubscriptions({Key? key}) : super(key: key);

  final _homeController = Get.find<HomeController>();
  final _trainerController = Get.find<TrainerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarForAccount(
        title: "Subscription Details",
        onback: () {
          Navigator.pop(context);
        },
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => MyTrainersTile(
          isSubscriptionPage: true,
          planDetail: _homeController.activePlans[index],
          name: _homeController.activePlans[index].trainer!.name.toString(),
          imageUrl: _homeController.activePlans[index].trainer!.profilePhoto
              .toString(),
          isCurrentlyEnrolled: true,
          onMyTrainerTileTapped: () async {
            String trainerId = _trainerController
                .trainers.value.response!.data!.myTrainers![index].user!;
            _trainerController.atrainerDetail.value = Trainer();
            _trainerController.isMyTrainerProfileLoading.value = true;
            _trainerController.isProfileLoading.value = true;
            Navigator.pushNamed(context, RouteName.trainerProfileScreen);
            var result = await TrainerServices.getATrainerDetail(trainerId);
            _trainerController.atrainerDetail.value = result.response!.data!;
            _trainerController.isMyTrainerProfileLoading.value = false;

            _trainerController.isPlanLoading.value = true;
            _trainerController.planModel.value =
                await TrainerServices.getPlanByTrainerId(
                    trainerId, _trainerController.currentPlanType);
            _trainerController.isPlanLoading.value = false;
            _trainerController.initialPostData.value =
                await TrainerServices.getTrainerPosts(trainerId, 0);
            _trainerController.isProfileLoading.value = false;

            if (_trainerController
                    .initialPostData.value.response!.data!.length !=
                0) {
              _trainerController.trainerPostList.value =
                  _trainerController.initialPostData.value.response!.data!;
            } else {
              _trainerController.trainerPostList.clear();
            }
          },
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemCount: _homeController.activePlans.length,
      ),
    );
  }
}
