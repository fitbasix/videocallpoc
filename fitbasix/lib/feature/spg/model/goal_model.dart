import 'package:fitbasix/core/constants/image_path.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class GoalModel {
  final String title;
  final String imageUrl;

  GoalModel({required this.title, required this.imageUrl});
}

final List<GoalModel> goalModel = <GoalModel>[
  GoalModel(title: 'fat_loss'.tr, imageUrl: ImagePath.fatLossIcon),
  GoalModel(
      title: 'muscle_hypertrophy'.tr,
      imageUrl: ImagePath.muscleHypertrophyIcon),
  GoalModel(
      title: 'strength_conditioning'.tr,
      imageUrl: ImagePath.strengthConditioningIcon),
  GoalModel(
      title: 'stamina_endurance'.tr, imageUrl: ImagePath.staminaEnduranceIcon),
  GoalModel(
      title: 'injury_rehabilitation'.tr,
      imageUrl: ImagePath.injuryRehabilitationIcon),
  GoalModel(
      title: 'holistic_fitness'.tr, imageUrl: ImagePath.holistickFitnessIcon)
];
