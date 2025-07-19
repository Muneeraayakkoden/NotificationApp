import 'package:flutter/foundation.dart';

class OnesignalProvider extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  void setUserId(String? id) {
    _userId = id;
    notifyListeners();
  }
}
