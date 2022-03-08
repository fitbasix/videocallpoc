import 'package:fitbasix/feature/Bmr_calculator/view/bmr_resultpage.dart';
import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/Home/view/consumption_screen.dart';
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/Home/view/explore.dart';
import 'package:fitbasix/feature/get_trained/view/all_trainer_screen.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/help_and_support/view/help_and_support_screen.dart';
import 'package:fitbasix/feature/help_and_support/view/privacy_policy_and_term_of_use/legal_screen.dart';
import 'package:fitbasix/feature/help_and_support/view/privacy_policy_and_term_of_use/privacy_policy_screen.dart';
import 'package:fitbasix/feature/help_and_support/view/privacy_policy_and_term_of_use/term_of_use_screen.dart';
import 'package:fitbasix/feature/live_stream/view/live_stream_screen.dart';
import 'package:fitbasix/feature/live_stream/view/scheduled_live_information_screen.dart';
import 'package:fitbasix/feature/log_in/view/enter_details_page.dart';
import 'package:fitbasix/feature/log_in/view/enter_mobile_google.dart';
import 'package:fitbasix/feature/log_in/view/enter_otp_google.dart';
import 'package:fitbasix/feature/log_in/view/enter_password_screen.dart';
import 'package:fitbasix/feature/log_in/view/forgot_password.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';
import 'package:fitbasix/feature/log_in/view/otp_screen.dart';
import 'package:fitbasix/feature/log_in/view/reset_password.dart';
import 'package:fitbasix/feature/message/view/chat_documentscreen.dart';
import 'package:fitbasix/feature/message/view/chat_ui.dart';
import 'package:fitbasix/feature/message/view/my_trainer_tile.dart';
import 'package:fitbasix/feature/posts/view/create_post.dart';
import 'package:fitbasix/feature/posts/view/select_location_screen.dart';
import 'package:fitbasix/feature/posts/view/select_media_screen.dart';
import 'package:fitbasix/feature/posts/view/tag_people_screen.dart';
import 'package:fitbasix/feature/profile/view/edit_userprofile_info.dart';
import 'package:fitbasix/feature/profile/view/user_profile_info.dart';
import 'package:fitbasix/feature/settings/view/settings.dart';
import 'package:fitbasix/feature/profile/view/account_and_subscription_screen.dart';
import 'package:fitbasix/feature/profile/view/edit_personal_info_screen.dart';
import 'package:fitbasix/feature/spg/view/set_activity.dart';
import 'package:fitbasix/feature/spg/view/set_bodyFat.dart';
import 'package:fitbasix/feature/spg/view/set_foodType.dart';
import 'package:fitbasix/feature/spg/view/set_goal_intro_screen.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:fitbasix/feature/spg/view/set_height.dart';
import 'package:fitbasix/feature/spg/view/set_weight.dart';
import '../../feature/message/view/chat_videocallscreen.dart';
import '../../feature/plans/view/plan_info.dart';
import '../../feature/plans/view/trainers_plan.dart';
import '../../feature/plans/view/plan_timing.dart';

import '../../feature/profile/view/number_Change_otp_verify.dart';
import '../../feature/spg/view/set_dob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class RouteName {
  static const loginScreen = '/login';
  static const enterDetails = '/enter_details';
  static const homePage = '/home_page';
  static const otpScreen = '/otp-screen';
  static const enterMobileGoogle = '/enter_mobile_google';
  static const enterOTPGoogle = '/enter_otp_google';
  static const enterPasswordPage = '/enter_password';
  static const forgotPassword = '/forgot_password';
  static const resetPassword = '/reset_password';
  static const allTrainerScreen = '/all_trainer_screen';
  static const trainerProfileScreen = '/trainer_profile_Screen';
  static const selectLocationScreen = '/select_location_screen';
  static const tagPeopleScreen = '/tag_people_screen';
  static const setDob = '/set_dob';
  static const customGallery = '/custom_gallery';
  static const createPost = '/create_post';
  static const setGoalIntro = 'goal_intro';
  static const setGoal = '/set-goal';
  static const setWeight = '/set_weight';
  static const setHeight = '/set_height';
  static const setBodyFat = '/set_bodyFat';
  static const setFoodType = '/set_food_type';
  static const setActivity = '/set_activity';
  static const getTrainedScreen = '/get_trained';
  static const waterConsumed = "/water_consumed";
  static const userSetting = "/settings";
  static const myTrainer = "/my_trainer_tile.dart";
  static const postScreen = '/post_screen';
  static const exploreSearch = "/explore_search";
  static const accountAndSubscription = "/account_and_subscription_screen";
  static const editPersonalInfo = "/edit_personal_info_screen";
  static const helpAndSupport = "/help_and_support_screen";
  static const legal = "/legal_screen";
  static const privacyAndPolicy = "/privacy_policy_screen";
  static const termOfUse = "/term_of_use_screen";
  static const liveStream = "/live_stream_screen";
  static const scheduledLiveStreamInformation =
      "/scheduled_live_information_screen";
  static const trainerchatscreen = "/chat_ui";
  static const userprofileinfo = "/user_profile_info";
  static const edituserProfileScreen = "/edit_userprofile_info";
  static const bmrresultScreen = "/bmr_resultpage.dart";
  static const videocallScreen = "chat_videocallscreen.dart";
  static const trainerdocumentScreen = "/chat_documentscreen.dart";
  static const trainerplanScreen = "/trainers_plan.dart";
  static const planInformationScreen = "/plan_info.dart";
  static const planTimingScreen = "/plan_timing.dart";
  static const otpReScreen = "/otp_screen";
  RouteName._();
}

class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final route = settings.name;

    if (route == RouteName.loginScreen) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            LoginScreen(),
      );
    }
    if (route == RouteName.otpReScreen) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            NumberChangeOtpVerify(),
      );
    }
    if (route == RouteName.legal) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            LegalScreen(),
      );
    }
    if (route == RouteName.scheduledLiveStreamInformation) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            ScheduledLiveInformationScreen(),
      );
    }
    if (route == RouteName.liveStream) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            LiveStreamScreen(),
      );
    }
    if (route == RouteName.termOfUse) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            TermOfUseScreen(),
      );
    }
    if (route == RouteName.privacyAndPolicy) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            PrivacyPolicyScreen(),
      );
    }
    if (route == RouteName.helpAndSupport) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            HelpAndSupportScreen(),
      );
    }
    if (route == RouteName.otpScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => OtpScreen(),
      );
    }
    if (route == RouteName.enterDetails) {
      return MaterialPageRoute(
        builder: (BuildContext context) => EnterDetailsPage(),
      );
    }
    if (route == RouteName.homePage) {
      return MaterialPageRoute(
        builder: (BuildContext context) => HomeAndTrainerPage(),
      );
    }
    if (route == RouteName.enterMobileGoogle) {
      return MaterialPageRoute(
        builder: (BuildContext context) => EnterMobileDetailsGoogle(),
      );
    }
    if (route == RouteName.enterOTPGoogle) {
      return MaterialPageRoute(
        builder: (BuildContext context) => EnterOTPGoogle(),
      );
    }
    if (route == RouteName.customGallery) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SelectMediaScreen(),
      );
    }
    if (route == RouteName.createPost) {
      return MaterialPageRoute(
        builder: (BuildContext context) => CreatePostScreen(),
      );
    }
    if (route == RouteName.enterPasswordPage) {
      return MaterialPageRoute(
        builder: (BuildContext context) => EnterPassword(),
      );
    }
    if (route == RouteName.forgotPassword) {
      return MaterialPageRoute(
        builder: (BuildContext context) => ForgotPassword(),
      );
    }
    if (route == RouteName.resetPassword) {
      return MaterialPageRoute(
        builder: (
          BuildContext context,
        ) =>
            ResetPassword(),
      );
    }
    if (route == RouteName.allTrainerScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => AllTrainerScreen(),
      );
    }
    if (route == RouteName.trainerProfileScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => TrainerProfileScreen(),
      );
    }

    if (route == RouteName.waterConsumed) {
      return MaterialPageRoute(
        builder: (BuildContext context) => ConsumptionScreen(),
      );
    }
    if (route == RouteName.selectLocationScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SelectLocationScreen(),
      );
    }
    if (route == RouteName.tagPeopleScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => TagPeopleScreen(),
      );
    }
    if (route == RouteName.setGoalIntro) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetGoalIntroScreen(),
      );
    }
    if (route == RouteName.setGoal) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetGoalScreen(),
      );
    }
    if (route == RouteName.setDob) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetDob(),
      );
    }
    if (route == RouteName.setHeight) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetHeight(),
      );
    }
    if (route == RouteName.setWeight) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetWeight(),
      );
    }
    if (route == RouteName.setBodyFat) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetBodyFat(),
      );
    }
    if (route == RouteName.exploreSearch) {
      return MaterialPageRoute(
        builder: (BuildContext context) => ExploreFeed(),
      );
    }
    if (route == RouteName.customGallery) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SelectMediaScreen(),
      );
    }
    if (route == RouteName.setFoodType) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetFoodType(),
      );
    }

    if (route == RouteName.setActivity) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SetActivity(),
      );
    }

    if (route == RouteName.postScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => PostScreen(),
      );
    }

    if (route == RouteName.userSetting) {
      return MaterialPageRoute(
        builder: (BuildContext context) => SettingScreen(),
      );
    }

    if (route == RouteName.myTrainer) {
      return MaterialPageRoute(
        builder: (BuildContext context) => MyTrainerTileScreen(),
      );
    }
    if (route == RouteName.getTrainedScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => GetTrainedScreen(),
      );
    }
    if (route == RouteName.accountAndSubscription) {
      return MaterialPageRoute(
        builder: (BuildContext context) => AccountAndSubscriptionScreen(),
      );
    }
    if (route == RouteName.trainerchatscreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => ChatScreen(),
      );
    }
    if (route == RouteName.videocallScreen) {
      return MaterialPageRoute(
          builder: (BuildContext context) => VideoCallScreen());
    }
    if (route == RouteName.userprofileinfo) {
      return MaterialPageRoute(
        builder: (BuildContext context) => UserProfileScreen(),
      );
    }
    if (route == RouteName.edituserProfileScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => EditProfileScreen(),
      );
    }
    if (route == RouteName.bmrresultScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => BMRResultScreen(),
      );
    }
    if (route == RouteName.trainerdocumentScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => TrainerDocumentScreen(),
      );
    }
    if (route == RouteName.trainerplanScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => TrainerPlansScreen(),
      );
    }
    if (route == RouteName.planInformationScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => PlanInformationUI(),
      );
    }
    if (route == RouteName.planTimingScreen) {
      return MaterialPageRoute(
        builder: (BuildContext context) => PlanTimingUI(),
      );
    }
    if (route == RouteName.editPersonalInfo) {
      return MaterialPageRoute(
        builder: (BuildContext context) => EditPersonalInfoScreen(),
      );
    } else {
      return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              LoginScreen());
    }
  }
}
