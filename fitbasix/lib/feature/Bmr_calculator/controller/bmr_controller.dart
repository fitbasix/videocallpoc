import 'package:fitbasix/feature/Bmr_calculator/model/bmr_calculation_model.dart';
import 'package:get/get.dart';

enum Gender { male, female }

class BmrController extends GetxController{

  RxDouble bodyweight = 45.0.obs;
  RxDouble height = 180.0.obs;
  RxInt age = 1.obs;
  final gender = Gender.male.obs;
  RxBool isclicked = RxBool(false);

Rx<BmrCalculationModel> bmrresult = BmrCalculationModel().obs;

}