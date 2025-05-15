import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = 'Admin Dishub';
  String _profileImageUrl = 'https://ui-avatars.com/api/?name=Admin+Dishub&background=1E3A8A&color=fff&size=256';
  bool _notificationsEnabled = true;

  String get username => _username;
  String get profileImageUrl => _profileImageUrl;
  bool get notificationsEnabled => _notificationsEnabled;

  void updateUsername(String newUsername) {
    _username = newUsername;
    _updateProfileImage(newUsername);
    notifyListeners();
  }

  void updateProfileImage(String newImageUrl) {
    _profileImageUrl = newImageUrl;
    notifyListeners();
  }

  void _updateProfileImage(String name) {
    // Generate a new avatar based on the name
    _profileImageUrl = 'https://ui-avatars.com/api/?name=${name.replaceAll(' ', '+')}&background=1E3A8A&color=fff&size=256';
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}
