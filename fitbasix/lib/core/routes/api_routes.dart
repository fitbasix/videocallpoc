class ApiUrl {
  static String liveBaseURL = 'http://3.131.171.176';
  // static String liveBaseURL = 'https://8ed2-103-15-254-251.ngrok.io';
  static String getOTP = liveBaseURL + '/api/auth/sendOtp';
  static String thirdPartyLogin = liveBaseURL + '/api/auth/thirdPartyLogin';
  static String loginAndSignup = liveBaseURL + '/api/auth/login';
  static String registerUser = liveBaseURL + '/api/auth/create';
  static String getCountries = liveBaseURL + '/api/country/get';
  static String updateToken = liveBaseURL + '/api/auth/generateToken';
  static String getTrainerById = liveBaseURL + '/api/trainer/getTrainerById';
  static String getStrength = liveBaseURL + '/api/trainer/getStrenght';
  static String getAllTrainer = liveBaseURL + '/api/trainer/getAll';
}
