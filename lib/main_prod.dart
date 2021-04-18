
import 'package:library_base/constant/app_config.dart';
import 'package:library_base/net/apis.dart';

import 'init/app_init.dart';

void main() {
  AppConfig.env = EnvModel(
      envMode: EnvEmum.prod,
      apiUrl: Apis.BASE_URL_PROD,
      articleApiUrl: Apis.BASE_URL_ARITCLE_PROD,
      wsUrl: Apis.WEB_SOCKET_URL_PROD
  );

  AppInit.run();
}