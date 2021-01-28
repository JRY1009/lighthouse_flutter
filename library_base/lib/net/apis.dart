class Apis {

  static const String ERRNO = 'errno';
  static const String MESSAGE = 'msg';
  static const String ERRNO_OK = "10000";
  static const String ERRNO_DIO_ERROR = "DIOERROR";
  static const String ERRNO_UNKNOWN = "UNKNOWN";
  static const String ERRNO_UNKNOWN_MESSAGE = "UNKNOWN MESSAGE";
  static const String ERRNO_FORBIDDEN = "FORBIDDEN";

  static const String KEY_VER = "lh-Ver";
  static const String KEY_DEV = "lh-Dev";
  static const String KEY_DEVICE_ID = "lh-DeviceId";
  static const String KEY_LANGUAGE = "lh-Language";
  static const String KEY_CHANNEL = "lh-Channel";
  static const String KEY_USER_TOKEN = "lh-Token";
  static const String KEY_USER_TS = "lh-Ts";
  static const String KEY_USER_U_ID = "lh-Uid";
  static const String KEY_USER_SIGN = "lh-Sign";

  static const String PRIVATE_KEY = "5ffF03b858D5Fd16";       //测试环境
  static const String BASE_URL_YAPI = 'http://81.70.145.64:8083/api';  //测试环境
  static const String WEB_SOCKET_URL = 'ws://81.70.145.64:8083/api/ws';

  static bool get isTestEnvironment => (BASE_URL_YAPI == 'http://81.70.145.64:8083/api');

  static const String URL_LOGIN = '/login';
  static const String URL_REGISTER = '/reg';
  static const String URL_VERIFY_CODE = '/sms/send';
  static const String URL_RESET_PASSWORD = '/account/forget_password';
  static const String URL_GET_ACCOUNT_INFO = '/account/account_info';
  static const String URL_UPDATE_NICK_NAME = '/account/update_nick_name';
  static const String URL_UPLOAD_HEAD_ICON = '/account/upload_head_ico';

  static const String URL_GET_HOME = '/home';
  static const String URL_GET_MILESTONES = '/milestone';
  static const String URL_GET_GLOBAL_QUOTE = '/global_quote';
  static const String URL_GET_TREEMAP = '/thermodynamic_diagram';
  static const String URL_GET_COIN_QUOTE = '/coin_quote';
  static const String URL_GET_CHAIN_DETAIL = '/chain/detail';
  static const String URL_GET_CHAIN_QUOTE = '/chain/quote';
  static const String URL_GET_CHAIN_DATA = '/chain/data';
  static const String URL_GET_QUOTE = '/quote';

  static const String URL_GET_NEWS = '/user/selectAccounts';


  static const String URL_OFFICIAL_WEBSITE = 'https://www.baidu.com';
}