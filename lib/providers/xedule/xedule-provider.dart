import 'package:flutter/foundation.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/utils/commons.dart';

class XeduleProvider extends ChangeNotifier {
  Xedule xedule = Xedule(config: XeduleConfig());

  XeduleProvider() {
    print(xedule.config);
  }

  void setConfig(XeduleConfig config) {
    this.xedule = Xedule(config: config, endpoint: Commons.xeduleEndpoint);
    notifyListeners();
  }
}
