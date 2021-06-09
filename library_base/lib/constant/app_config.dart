
import 'package:library_base/net/apis.dart';

class AppConfig {
  static EnvModel env = EnvModel(
    envMode: EnvEmum.test,
    apiUrl: Apis.BASE_URL_TEST,
    articleApiUrl: Apis.BASE_URL_ARITCLE_TEST,
    wsUrl: Apis.WEB_SOCKET_URL_TEST
  );    // 环境变量配置, 默认配置

  static bool get isTestEnvironment => (env.envMode == EnvEmum.test);
}

enum EnvEmum {
  test,
  prod,
}

class EnvModel {

  EnvEmum envMode;
  String apiUrl;
  String articleApiUrl;
  String wsUrl;

  EnvModel({
    required this.envMode,
    required this.apiUrl,
    required this.articleApiUrl,
    required this.wsUrl,
  });
}
