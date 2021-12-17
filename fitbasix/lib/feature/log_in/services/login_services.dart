import 'package:fitbasix/core/api_service/dio_service.dart';

class LogInService {
  static var dio = DioUtil().getInstance();
  static Future<void> logInRequest(String logInType, String email) async {
    print(logInType);
    print(email);
    var response = await dio!.post(
        "https://be-fitbasix.antino.ca/api/auth/login",
        data: {"loginType": logInType, "email": email});
    print(response);
  }

  static Future<void> registerUser() async {
    print("vafd");
    var response = await dio!
        .post("https://be-fitbasix.antino.ca/api/auth/register", data: {
      "regType": "GOOGLE",
      "role": "user",
      "username": "vartika591",
      "email": "vartika123@gmail.com",
      "password": "newPassword@123"
    });
    print(response);
  }

  static Future<String> getOTP(String mobile) async {
    var response = await dio!.post(
        "http://0f60-2405-201-3-4179-30b5-7690-bd1e-84a8.ngrok.io/api/auth/otp-get",
        data: {"phoneNumber": mobile});
    print(response);

    return response.data['otp']['Details'];
  }

  static Future<void> verifyOTP(String otp, String otpVerifyDetails) async {
    var response = await dio!.post(
        "http://0f60-2405-201-3-4179-30b5-7690-bd1e-84a8.ngrok.io/api/auth/otp-verify",
        data: {"otp": otp, "otpVerifyDetais": otpVerifyDetails});
    print(response);
  }
}
