import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/router/parameters.dart';

typedef Widget PageBuilderFunc(Parameters? parameters);

class PageBuilder {
  final String path;
  final PageBuilderFunc builderFunc;
  Parameters? parameters;

  Handler? _handler;

  PageBuilder(this.path, this.builderFunc, {this.parameters}) {
    _handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<Object>> params) {
          return builderFunc(parameters);
        });
  }

  Handler? get handler => _handler;
}