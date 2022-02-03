class ApiUrl {
  static String liveBaseURL = 'http://3.131.171.176';
  // static String liveBaseURL = 'https://a1c9-103-15-254-206.ngrok.io';
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
  static String deletePost = liveBaseURL + '/api/posts/delete';
  static String doFollow = liveBaseURL + '/api/follow/doFollow';
  static String getSPGData = liveBaseURL + '/api/goal/getAll';
  static String updateGoal = liveBaseURL + '/api/goal/updateGoalDetails';
  static String getWater = liveBaseURL + '/api/nutrition/water/get';
  static String updateWater = liveBaseURL + '/api/nutrition/water/update';

  ///create post
  static String createPost = liveBaseURL + '/api/posts/create';
  static String getAllCategory = liveBaseURL + '/api/category/getAll';
  static String getPosts = liveBaseURL + '/api/posts/getPosts';
  static String getTrainerPosts = liveBaseURL + '/api/posts/getMypost';
  static String likePost = liveBaseURL + '/api/like/hitLike';
  static String addComment = liveBaseURL + '/api/comment/add';
  static String getComment = liveBaseURL + '/api/comment/getCommentByPost';
  static String unlike = liveBaseURL + '/api/like/disLike';

  ///get users
  static String getUsers = liveBaseURL + '/api/auth/getAllUsers';
}
