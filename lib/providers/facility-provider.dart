import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/facility.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:provider/provider.dart';

class FacilityProvider extends ChangeNotifier {
  List<Facility> facilities = [];

  void fetchFacilities(BuildContext context)async {
    final xeduleProvider = context.read<XeduleProvider>();
    final facilities = await xeduleProvider.xedule.fetchFacilities();
    setFacilities(facilities);
  }

  void setFacilities(List<Facility> facilities) {
    this.facilities = facilities;
    notifyListeners();
  }
}