import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '';

  String get userName => _userName;

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }
}
