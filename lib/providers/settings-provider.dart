import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ThemeMode _themeMode = ThemeMode.light;

  SettingsProvider() {
    initSettings();
  }

  void initSettings() async {
    final prefs = await _prefs;
    final themeMode =
        prefs.getBool("darkTheme") ?? false ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(themeMode);
  }

  void setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();

    final prefs = await _prefs;
    prefs.setBool("darkTheme", themeMode == ThemeMode.dark);
  }

  get themeMode => _themeMode;
}
