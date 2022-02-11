
import 'package:get/get.dart';

import '../model/help_support_model.dart';
import '../services/help_and_support_services.dart';

class HelpAndSupportConroller extends GetxController{
  var isLoading = true.obs;
  HelpAndSupportModel? helpAndSupportDataModel;



  getAllHelpAndSupportContent() async {
    helpAndSupportDataModel = await HelpAndSupportServices.getHelpDeskContents().then((value) {
      isLoading.value = false;
      return value;
    });
  }



}