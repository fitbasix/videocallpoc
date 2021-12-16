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
}
