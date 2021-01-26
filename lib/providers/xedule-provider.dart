import 'package:flutter/foundation.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/utils/commons.dart';

class XeduleProvider extends ChangeNotifier {
  bool authenticated = false;
  Xedule xedule = Xedule(
    endpoint: Commons.xeduleEndpoint,
    config: XeduleConfig()
  );

  void setConfig(XeduleConfig config) {
    xedule.config = config;
  }

  void setAuthenticated(bool auth) {
    authenticated = auth;
    notifyListeners();
  }
}
