class ApiUrl {
  static String liveBaseURL =
      'https://6fac-2405-201-3-4179-61d3-3ddc-c916-4e87.ngrok.io';
  static String getOTP = liveBaseURL + '/api/auth/otp-get';
  static String verifyOTP = liveBaseURL + '/api/auth/otp-verify';
  static String loginRegisterRequest =
      liveBaseURL + '/api/auth/loginAndRegister';
  static String registerRequest = liveBaseURL + '/api/auth/register';
  static String updateDetails = liveBaseURL + '/api/auth/update-details';
}
