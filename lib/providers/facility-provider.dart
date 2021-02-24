import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/facility.dart';

class FacilityProvider extends ChangeNotifier {
  List<Facility> facilities = [];

  void setFacilities(List<Facility> facilities) {
    this.facilities = facilities;
    notifyListeners();
  }
}