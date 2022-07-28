import '../../app_config.dart';

class ApiUrl {
  static String liveBaseURL = AppConfig.api_url;

  // static String liveBaseURL = 'https://04d8-2409-4050-2e4b-e78d-485a-d9b5-586-a883.in.ngrok.io';

  static String getOTP = liveBaseURL + '/api/auth/sendOtp';
  static String getAbuseData =
      liveBaseURL + '/api/optionData/reportReasonList/getList';
  static String sendAbuseData = liveBaseURL + '/api/report/create';
  static String uploadChatFileToDb =
      liveBaseURL + '/api/documents/createDocument';
  static String getUserWithDocuments = liveBaseURL + '/api/documents/getUsers';
  static String getUserAllDocuments =
      liveBaseURL + '/api/documents/getDocumentByTrainer';
  static String editNumberOtp = liveBaseURL + '/api/auth/generateOtp';
  static String getTermOfUseContents = liveBaseURL + '/api/auth/termsOfService';
  static String getPrivacyPolicyContents =
      liveBaseURL + '/api/auth/privacyPolicy';

  static String updateUserQuickBloxId = liveBaseURL + "/api/chat/add";

  ///register device token
  static String updateDeviceToken =
      liveBaseURL + '/api/notification/registerDeviceToken';
  static String removeDeviceId =
      liveBaseURL + '/api/notification/removeDeviceId';

  ///auth
  static String logOut = liveBaseURL + '/api/auth/logout';

  static String getHelpAndSupportContents =
      liveBaseURL + '/api/auth/helpAndSupport';
  static String bmrcalculation = liveBaseURL + '/api/nutritions/getbmr';
  static String getSortByData =
      liveBaseURL + '/api/optionData/sorting/getOptions';

  static String getAllSlots =
      liveBaseURL + '/api/optionData/timeSlots/getSlots';
  static String thirdPartyLogin = liveBaseURL + '/api/auth/thirdPartyLogin';
  static String loginAndSignup = liveBaseURL + '/api/auth/login';
  static String getMyTrainers = liveBaseURL + '/api/trainer/myTrainers';
  static String registerUser = liveBaseURL + '/api/auth/create';
  static String getCountries = liveBaseURL + '/api/country/get';
  static String updateToken = liveBaseURL + '/api/auth/generateToken';
  static String getTrainerById = liveBaseURL + '/api/trainer/getTrainerDetails';
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
  static String waterReminderData =
      liveBaseURL + '/api/nutrition/water/getOptions';
  static String doUnfollow = liveBaseURL + '/api/follow/doUnfollow';

  ///create post
  static String createPost = liveBaseURL + '/api/posts/create';
  static String getAllCategory = liveBaseURL + '/api/category/getAll';
  static String getPosts = liveBaseURL + '/api/posts/getPosts';
  static String getTrainerPosts = liveBaseURL + '/api/posts/getMypost';
  static String likePost = liveBaseURL + '/api/like/hitLike';
  static String addComment = liveBaseURL + '/api/comment/add';
  static String getComment = liveBaseURL + '/api/comment/getCommentByPost';
  static String unlike = liveBaseURL + '/api/like/disLike';
  static String explorePost = liveBaseURL + '/api/posts/explorePage';
  static String getPostById = liveBaseURL + '/api/posts/getPostById';
  static String replyComment = liveBaseURL + '/api/comment/reply';
  static String recentComment = liveBaseURL + '/api/comment/recentComment';

  ///get users
  static String getUsers = liveBaseURL + '/api/auth/getAllUsers';
  static String editProfile = liveBaseURL + '/api/auth/edit';
  static String profilePic = liveBaseURL + '/api/user/addProfilePic';
  static String coverPic = liveBaseURL + "/api/user/addCoverPic";
  static String getIndividualUser = liveBaseURL + "/api/auth?userId=";

  ///plan
  static String getActivePlans = liveBaseURL +'/api/enrollPlan/getActivePlan';
  static String planById = liveBaseURL + '/api/plan/getPlanById';
  static String getSchedules = liveBaseURL + '/api/schedule/getSchedules';
  static String getAllPlans =
      liveBaseURL + "/api/optionData/timeSlots/getSlots";
  static String bookDemo = liveBaseURL + "/api/schedule/appointment";

  /// de Active account
  static String deActiveAccount = liveBaseURL + "/api/auth/deactivateAccount";
  static String deleteAccount = liveBaseURL + "/api/auth/deleteAccount";

  /// video call Url from enablex
  static String getEnablexUrl = liveBaseURL + '/api/videoChat?trainerId=';

  /// payment APIs
  static String getPaymentLink = liveBaseURL + '/api/payment/paymentLink';

}