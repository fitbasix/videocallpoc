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
import 'package:flutter/cupertino.dart';

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
            HomePage(),
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
    } else {
      return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              LoginScreen());
    }
  }
}
