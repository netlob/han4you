import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/period.dart';

class PeriodProvider extends ChangeNotifier {
  List<Period> periods = [];

  void setPeriods(List<Period> periods) {
    this.periods = periods;
    notifyListeners();
  }
}