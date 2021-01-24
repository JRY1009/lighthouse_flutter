
import 'package:lighthouse/net/model/account.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return null;

    } else if (T.toString() == 'String') {
      return json.toString() as T;
    } else {
      return json as T;
    }
  }
}