import 'package:flutter/cupertino.dart';

abstract class RouteName {
  static const home = '/';
  RouteName._();
}

// class GenerateRoute {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final route = settings.name;

//     if (route == RouteName.otpScreen) {
//         return PageRouteBuilder(
//             pageBuilder: (BuildContext context, Animation<double> animation,
//                     Animation<double> secondaryAnimation) =>
//                 OTPVerification(),
//             settings: RouteSettings(name: 'otp_Screen'));
//       } else {
//         return  PageRouteBuilder(
//             pageBuilder: (BuildContext context, Animation<double> animation,
//                     Animation<double> secondaryAnimation) =>
//                 LoginScreen());
//       }
//   }
// }
