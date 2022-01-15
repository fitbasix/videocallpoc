class ApiUrl {
  static String liveBaseURL = 'http://3.131.171.176';
  // static String liveBaseURL =
  // 'http://335f-2405-201-3-4179-91a2-97a1-c334-959b.ngrok.io';
  // static String liveBaseURL = 'https://8ed2-103-15-254-251.ngrok.io';
  static String getOTP = liveBaseURL + '/api/auth/sendOtp';
  static String thirdPartyLogin = liveBaseURL + '/api/auth/thirdPartyLogin';
  static String loginAndSignup = liveBaseURL + '/api/auth/login';
  static String registerUser = liveBaseURL + '/api/auth/create';
  static String getCountries = liveBaseURL + '/api/country/get';
  static String updateToken = liveBaseURL + '/api/auth/generateToken';
  static String getTrainerById = liveBaseURL + '/api/trainer/getTrainerById';
  static String getStrength = liveBaseURL + '/api/trainer/getStrenght';
  static String getPlanByTrainerId = liveBaseURL + '/api/plan/getAllPlansById';
  static String getAllTrainer = liveBaseURL + '/api/trainer/getAll';
  static String getAllInterest = liveBaseURL + '/api/interests/getAll';
  static String getTrainers = liveBaseURL + '/api/trainer/getInit';
  static String uploadMedia = liveBaseURL + '/api/posts/uploadMedia';
  static String getUserByName = liveBaseURL + '/api/auth/getAllUsers';
  static String getUserProfile = liveBaseURL + '/api/auth';

  ///create post
  static String createPost = liveBaseURL + '/api/posts/create';

  ///get users
  static String getUsers = liveBaseURL + '/api/auth/getAllUsers';
}
