import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool darkTheme = false;

  SettingsProvider() {
    _initSettingsProvider();
  }

  void _initSettingsProvider() async {
    SharedPreferences prefs = await _prefs;
    setDarkTheme(prefs.getBool('darkTheme') ?? false);
  }

  void setDarkTheme(bool darkTheme) {
    this.darkTheme = darkTheme;
    notifyListeners();
  }

  void save() async {
    final prefs = await _prefs;
    prefs.setBool('darkTheme', darkTheme);
  }
}
