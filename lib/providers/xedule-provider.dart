import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XeduleProvider extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Xedule xedule = Xedule(config: XeduleConfig());

  XeduleProvider() {
    _initXeduleProvider();
  }

  void _initXeduleProvider() async {
    final prefs = await _prefs;
    final jsonXeduleConfig = prefs.getString('xeduleConfig');
    if (jsonXeduleConfig != null) {
      final xeduleConfig = XeduleConfig.fromJson(jsonDecode(jsonXeduleConfig));

      if(xeduleConfig.authenticated) {
        setConfig(xeduleConfig);
      }
    }
  }

  void setConfig(XeduleConfig config) {
    xedule.config = config;
    notifyListeners();
  }

  void resetConfig() {
    setConfig(XeduleConfig());
  }

  void save() async {
    final prefs = await _prefs;
    prefs.setString('xeduleConfig', jsonEncode(xedule.config.toJson()));
  }
}
