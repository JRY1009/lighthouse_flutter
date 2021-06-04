class Apis {

  static const String ERRNO = 'err_code';
  static const String MESSAGE = 'msg';
  static const String ERRNO_OK = "0";
  static const String ERRNO_DIO_ERROR = "DIOERROR";
  static const String ERRNO_UNKNOWN = "UNKNOWN";
  static const String ERRNO_UNKNOWN_MESSAGE = "UNKNOWN MESSAGE";
  static const String ERRNO_FORBIDDEN = "FORBIDDEN";
  static const String ERRNO_NOT_SET_PASSWORD = "30021";

  static const String KEY_VER = "lh-Ver";
  static const String KEY_DEV = "lh-Dev";
  static const String KEY_DEVICE_ID = "lh-DeviceId";
  static const String KEY_LANGUAGE = "lh-Language";
  static const String KEY_CHANNEL = "lh-Channel";
  static const String KEY_USER_TOKEN = "lh-Token";
  static const String KEY_USER_TS = "lh-Ts";
  static const String KEY_USER_U_ID = "lh-Uid";
  static const String KEY_USER_SIGN = "lh-Sign";

  //测试环境
  static const String PRIVATE_KEY = "5ffF03b858D5Fd16";
  static const String BASE_URL_TEST = 'http://81.70.145.64/api';
  static const String BASE_URL_ARITCLE_TEST = 'https://test-news.idengta.com/api';
  static const String WEB_SOCKET_URL_TEST = 'ws://81.70.145.64:8083/api/ws';

  //正式环境
  static const String BASE_URL_PROD = 'http://81.70.145.64/api';
  static const String BASE_URL_ARITCLE_PROD = 'https://news.idengta.com/api';
  static const String WEB_SOCKET_URL_PROD = 'ws://81.70.145.64:8083/api/ws';

  static const String COIN_BITCOIN = 'bitcoin';
  static const String COIN_ETHEREUM = 'ethereum';

  static const String URL_LOGIN = '/login';
  static const String URL_WECHAT_LOGIN = '/wechat/login';
  static const String URL_BIND_PHONE = '/account/bingphone';
  static const String URL_BIND_WECHAT = '/account/bingthrid';
  static const String URL_UNBIND_WECHAT = '/account/unbundling';
  static const String URL_REGISTER = '/reg';
  static const String URL_VERIFY_CODE = '/sms/send';
  static const String URL_RESET_PASSWORD = '/account/forget_password';
  static const String URL_FORGET_PASSWORD = '/account/forget_password_v2';
  static const String URL_UPDATE_PASSWORD = '/account/update_password';
  static const String URL_SET_PASSWORD = '/account/set_password';
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

  static const String URL_GET_COMMUNITY_MESSAGES = '/community/search';
  static const String URL_GET_LESSONS = '/academy/inquiry/search';

  static const String URL_GET_ARTICLE_CHANNELS = '/v1/c/channels/';
  static const String URL_GET_ARTICLE_SUB_CHANNELS = '/v1/c/channels/';
  static const String URL_GET_ARTICLES = '/v1/c/channels/';
  static const String URL_GET_ARTICLE = '/v1/c/articles/';


  static const String URL_OFFICIAL_WEBSITE = 'https://www.idengta.com';
  static const String URL_DISPLAY_WEBSITE = 'idengta.com';
  static const String URL_REGIST_AGREEMENT = 'https://www.idengta.com/agreements/user.html';
  static const String URL_PRIVATE_POLICY = 'https://www.idengta.com/agreements/privacy.html';
  static const String URL_DISCAIMER = 'https://www.idengta.com/agreements/disclaimer.html';
}