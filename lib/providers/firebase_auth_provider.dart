import 'package:flutter/material.dart';
import 'package:movelytics_app/services/firebase_auth_service.dart';
import 'package:movelytics_app/static/firebase_auth_status.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  String? get message => _message;
  FirebaseAuthStatus get authStatus => _authStatus;

  Future<void> loginWithGoogle() async {
    try {
      _authStatus = FirebaseAuthStatus.loggingIn;
      notifyListeners();

      await _service.loginWithGoogle();

      _authStatus = FirebaseAuthStatus.loggedIn;
      _message = "Login with Google successful";
    } catch (e) {
      _authStatus = FirebaseAuthStatus.error;
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _service.signOut();
      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = "Logged out successfully";
    } catch (e) {
      _authStatus = FirebaseAuthStatus.error;
      _message = "Logout failed: ${e.toString()}";
    }
  }
}
