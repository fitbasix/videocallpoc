
import 'package:fitbasix/feature/help_and_support/model/term_of_use_model.dart';
import 'package:get/get.dart';

import '../model/help_support_model.dart';
import '../services/help_and_support_services.dart';

class HelpAndSupportConroller extends GetxController{
  var isLoading = true.obs;
  HelpAndSupportModel? helpAndSupportDataModel;
  TermOfUseModel? termOfUseModel;
  var termOfUseIsLoading = true.obs;
  var privacyPolicyIsLoading = true.obs;
  TermOfUseModel? privacyPolicyModel;



  getAllHelpAndSupportContent() async {
    helpAndSupportDataModel = await HelpAndSupportServices.getHelpDeskContents().then((value) {
      isLoading.value = false;
      return value;
    });
  }

  getTermOfUseContent() async {
    termOfUseModel = await HelpAndSupportServices.getTermOfUseContents().then((value) {
      termOfUseIsLoading.value = false;
      return value;
    });
  }

  getPrivacyPolicyContent() async {
    privacyPolicyModel = await HelpAndSupportServices.getPrivacyPolicyContents().then((value) {
      privacyPolicyIsLoading.value = false;
      return value;
    });
  }






}