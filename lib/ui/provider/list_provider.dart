
import 'package:flutter/material.dart';

class ListProvider<T> extends ChangeNotifier {

  final List<T> _list = [];
  List<T> get list => _list;

  bool _noMore = false;

  bool get noMore => _noMore;

  void notify({bool noMore = false}) {
    _noMore = noMore;
    notifyListeners();
  }

  void add(T data) {
    _list.add(data);
  }

  void addAll(List<T> data) {
    _list.addAll(data);
  }

  void insert(int i, T data) {
    _list.insert(i, data);
  }

  void insertAll(int i, List<T> data) {
    _list.insertAll(i, data);
  }

  void remove(T data) {
    _list.remove(data);
  }

  void removeAt(int i) {
    _list.removeAt(i);
  }

  void clear() {
    _list.clear();
  }
}