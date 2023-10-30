import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  // Define your authentication-related methods and properties here.

  // For example:
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    // Perform the login logic
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    // Perform the logout logic
    _isLoggedIn = false;
    notifyListeners();
  }
}
