import 'package:flutter/foundation.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/api/xedule/xedule.dart';

class XeduleProvider extends ChangeNotifier {
  Xedule xedule = Xedule(
    config: XeduleConfigEmpty()
  );

  void setConfig(XeduleConfig config) {
    xedule.config = config;
    notifyListeners();
  }

  bool get authenticated => !(xedule.config is XeduleConfigEmpty);
}
