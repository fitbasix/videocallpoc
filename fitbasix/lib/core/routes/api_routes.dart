class ApiUrl {
  static String liveBaseURL = 'https://11e9-103-15-254-237.ngrok.io';
  static String getOTP = liveBaseURL + '/api/auth/sendOtp';
  static String thirdPartyLogin = liveBaseURL + '/api/auth/thirdPartyLogin';
  static String loginAndSignup = liveBaseURL + '/api/auth/login';
  static String registerUser = liveBaseURL + '/api/auth/create';
  static String getCountries = liveBaseURL + '/api/country/get';
  static String updateToken = liveBaseURL + '/api/auth/generateToken';
}
