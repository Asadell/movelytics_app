import 'package:flutter/material.dart';
import 'package:movelytics_app/services/shared_preference_service.dart';

class SharedPreferenceProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferenceProvider(this._service);

  bool _isLogin = false;
  bool get isLogin => _service.isLogin ?? _isLogin;

  Future login() async {
    await _service.login();
    _isLogin = true;
    notifyListeners();
  }

  Future logout() async {
    await _service.logout();
    _isLogin = false;
    notifyListeners();
  }
}
