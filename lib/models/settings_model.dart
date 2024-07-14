import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  SettingsModel() {
    _loadSettings();
  }

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
    switch(modeString) {
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
