import 'package:flutter/material.dart';
import 'package:option_result/option_result.dart';
import 'package:fusion/services/auth_service.dart';
import 'package:fusion/widgets/mobile/main_screen.dart'; // Needed for setMobileToHome
import 'package:shared_preferences/shared_preferences.dart';

class AppStateService extends ChangeNotifier {
  static final AppStateService _instance = AppStateService._internal();

  factory AppStateService() {
    return _instance;
  }

  AppStateService._internal() {
    debugPrint("Initializing AppStateService...");
    _loadSettings();
  }

  // Replace DisplayNotifier
  Widget _currentMobileWidget = const Center(child: Text('Home Page'));

  Widget get currentMobileWidget => _currentMobileWidget;

  void setMobileToHome() {
    if (_currentMobileWidget is! MainScreen) {
      updateMobileWidget(const MainScreen());
    }
  }

  void updateMobileWidget(Widget widget) {
    _currentMobileWidget = widget;
    notifyListeners();
  }

  /// Authentication State Management
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void setLoginStatus(bool status) {
    _isLoggedIn = status;
    notifyListeners();
  }

  // Updates _isLogged In & Updates listeners. Forwards result to caller
  Future<Result<void, String>> login(String username, String password) async {
    final result = await AuthService.login(username, password);
    return result;
  }

  Future<void> logout() async {
    await AuthService.logout();
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
