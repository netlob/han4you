import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/period.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:provider/provider.dart';

class PeriodProvider extends ChangeNotifier {
  List<Period> periods = [];

  Future<void> fetchPeriods(BuildContext context) async {
    final xeduleProvider = context.read<XeduleProvider>();
    final periods = await xeduleProvider.xedule.fetchPeriods();
    setPeriods(periods);
  }

  void setPeriods(List<Period> periods) {
    this.periods = periods;
    notifyListeners();
  }
}