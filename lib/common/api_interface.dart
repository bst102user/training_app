class ApiInterface{
  static const String BASE_URL               = 'https://teamwebdevelopers.com/';
  static const String LOGIN_USER             = BASE_URL+'sportsfood/api/login';
  static const String REGISTER_USER          = BASE_URL+'sportsfood/api/registration';
  static const String FORGET_PASSWORD        = BASE_URL+'sportsfood/api/updateToken';
  static const String ADD_RACE               = BASE_URL+'sportsfood/api/add_race';
  static const String ALL_RACEES             = BASE_URL+'sportsfood/api/show_race';
  static const String UPDATE_RACE            = BASE_URL+'sportsfood/api/race_update';
  static const String DELETE_RACE            = BASE_URL+'sportsfood/api/race_delete';
  static const String GET_PROFILE            = BASE_URL+'sportsfood/api/users/';
  static const String UPDATE_PROFILE         = BASE_URL+'sportsfood/api/user_update/';
  static const String SHOW_DOCUMENT          = BASE_URL+'sportsfood/api/show_pdf';
  static const String DAILY_TRAINING         = BASE_URL+'sportsfood/api/monthlyOverViewDate/';
  static const String UPDATE_DAILY_TRAINING  = BASE_URL+'sportsfood/api/daily_rating_update/';
  static const String UPDATE_ILLNESS         = BASE_URL+'sportsfood/api/update_illness';
  static const String NOT_ATTEND             = BASE_URL+'sportsfood/api/update_null';
  static const String ALL_TRAINER            = BASE_URL+'sportsfood/api/alltrainer';
  static const String MOVE_RACE              = BASE_URL+'sportsfood/api/move_date';
  static const String NOTIFICATIONS          = BASE_URL+'sportsfood/api/notification_user/7';
  static const String NOTIF_TO_TRAINER       = BASE_URL+'sportsfood/api/get_single_trainer/';
  static const String SEND_NOTIFICATIONS     = BASE_URL+'sportsfood/api/get_single_athletics/8/';
  static const String ATHLETE_NOTIFICATIONS  = BASE_URL+'sportsfood/api/notification_trainer/';
  static const String PROFILE_IMAGE_PATH     = BASE_URL+'sportsfood/admin/../uploads/profileimg/';
  static const String UPLOAD_PROFILE_PICTURE = BASE_URL+'sportsfood/api/profile_file/';

//  =======================================  ATHLETES API'S =======================================

  static const String LIST_ATHLETES             = BASE_URL+'sportsfood/api/trainer_athletics/';
  static const String UPLOAD_XLS_FILE           = BASE_URL+'sportsfood/api/upload_file';
  static const String IMPORT_FILE               = BASE_URL+'sportsfood/api/export_file/105';
  static const String GET_LINK_XLS              = BASE_URL+'sportsfood/api/link_excel';
  static const String TRAINER_NOTIFICATIONS     = BASE_URL+'sportsfood/api/notification_trainer/8';

}