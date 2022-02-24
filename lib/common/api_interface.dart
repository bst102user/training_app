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
  static const String DAILY_TRAINING         = BASE_URL+'sportsfood/api/monthlyOverViewDate';
  static const String UPDATE_DAILY_TRAINING  = BASE_URL+'sportsfood/api/daily_lrating_update/';
  static const String UPDATE_ILLNESS         = BASE_URL+'sportsfood/api/update_illness';
  static const String NOT_ATTEND             = BASE_URL+'sportsfood/api/update_null';
}