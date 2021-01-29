import 'package:fluro/fluro.dart';
import 'package:library_base/router/page_builder.dart';

abstract class IRouter {
  List<PageBuilder> getPageBuilders();
}