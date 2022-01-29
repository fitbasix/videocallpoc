import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/get_trained/view/all_trainer_screen.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/log_in/view/enter_details_page.dart';
import 'package:fitbasix/feature/log_in/view/enter_mobile_google.dart';
import 'package:fitbasix/feature/log_in/view/enter_otp_google.dart';
import 'package:fitbasix/feature/log_in/view/enter_password_screen.dart';
import 'package:fitbasix/feature/log_in/view/forgot_password.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';
import 'package:fitbasix/feature/log_in/view/otp_screen.dart';
import 'package:fitbasix/feature/log_in/view/reset_password.dart';
import 'package:fitbasix/feature/posts/view/create_post.dart';
import 'package:fitbasix/feature/posts/view/select_location_screen.dart';
import 'package:fitbasix/feature/posts/view/select_media_screen.dart';
import 'package:fitbasix/feature/posts/view/tag_people_screen.dart';
import 'package:fitbasix/feature/spg/view/set_activity.dart';
import 'package:fitbasix/feature/spg/view/set_bodyFat.dart';
import 'package:fitbasix/feature/spg/view/set_foodType.dart';
import 'package:fitbasix/feature/spg/view/set_goal_intro_screen.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:fitbasix/feature/spg/view/set_height.dart';
import 'package:fitbasix/feature/spg/view/set_weight.dart';
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
  RouteName._();
}

class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final route = settings.name;

    if (route == RouteName.loginScreen) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            LoginScreen(),
      );
    }
    if (route == RouteName.otpScreen) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            OtpScreen(),
      );
    }
    if (route == RouteName.enterDetails) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            EnterDetailsPage(),
      );
    }
    if (route == RouteName.homePage) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            HomeAndTrainerPage(),
      );
    }
    if (route == RouteName.enterMobileGoogle) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            EnterMobileDetailsGoogle(),
      );
    }
    if (route == RouteName.enterOTPGoogle) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            EnterOTPGoogle(),
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
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            EnterPassword(),
      );
    }
    if (route == RouteName.forgotPassword) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            ForgotPassword(),
      );
    }
    if (route == RouteName.resetPassword) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            ResetPassword(),
      );
    }
    if (route == RouteName.allTrainerScreen) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            AllTrainerScreen(),
      );
    }
    if (route == RouteName.trainerProfileScreen) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            TrainerProfileScreen(),
      );
    }
    if (route == RouteName.selectLocationScreen) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            SelectLocationScreen(),
      );
    }
    if (route == RouteName.tagPeopleScreen) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            TagPeopleScreen(),
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
    if (route == RouteName.customGallery) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            SelectMediaScreen(),
      );
    }
    if (route == RouteName.setFoodType) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            SetFoodType(),
      );
    }

    if (route == RouteName.setActivity) {
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            SetActivity(),
      );
    } else {
      return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              LoginScreen());
    }
  }
}
