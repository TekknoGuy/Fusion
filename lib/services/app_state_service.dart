import 'package:flutter/material.dart';
import 'package:fusion/models/auth_result.dart';
import 'package:fusion/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateService extends ChangeNotifier {
  AppStateService() {
    _loadSettings();
    _checkLoginStatus();
  }

  // Authentication State
  bool _isLoggIn = false;

  bool get isLoggedIn => _isLoggIn;

  Future<void> _checkLoginStatus() async {
    _isLoggIn = await AuthService.hasValidRefreshToken();
    notifyListeners();
  }

  Future<AuthResult> login(String username, String password) async {
    final result = await AuthService.login(username, password);

    if(result.success) {
      _isLoggIn = true;
    } else {
      _isLoggIn = false;
    }
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggIn = false;
    notifyListeners();
  }

  Future<void> refreshLoginStatus() async {
    _isLoggIn = await AuthService.hasValidRefreshToken();
    notifyListeners();
  }

  // Settings
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? themeModeString = prefs.getString('themeMode');
    _themeMode = _stringToThemeMode(themeModeString) ?? ThemeMode.system;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeModeToString(mode));
    notifyListeners();
  }

  // Convert ThemeMode to a String
  String _themeModeToString(ThemeMode mode) {
    return mode.toString().split('.').last;
  }

  // Convert a String to a ThemeMode
  // toDo: this could probably be stored in an enum or something simpler
  ThemeMode? _stringToThemeMode(String? modeString) {
    if (modeString == null) return null;
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}
