import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}
