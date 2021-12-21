class ApiUrl {
  static String liveBaseURL = 'http://21d4-59-95-159-112.ngrok.io';
  static String getOTP = liveBaseURL + '/api/auth/otp-get';
  static String verifyOTP = liveBaseURL + '/api/auth/otp-verify';
  static String loginRegisterRequest =
      liveBaseURL + '/api/auth/loginAndRegister';
  static String registerRequest = liveBaseURL + '/api/auth/register';
  static String updateDetails = liveBaseURL + '/api/auth/update-details';
  static String getCountries = liveBaseURL + '/api/auth/get-countries';
}
