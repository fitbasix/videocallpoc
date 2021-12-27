class ApiUrl {
  static String liveBaseURL = 'https://hidden-garden-94551.herokuapp.com';
  static String getOTP = liveBaseURL + '/api/auth/sendOtp';
  static String thirdPartyLogin = liveBaseURL + '/api/auth/thirdPartyLogin';
  static String loginAndSignup = liveBaseURL + '/api/auth/login';
  static String registerUser = liveBaseURL + '/api/auth/create';
  static String getCountries = liveBaseURL + '/api/country/get';
}
