import 'package:flutter/foundation.dart';

class DateProvider extends ChangeNotifier {
  DateTime date;

  void setDate(DateTime date) {
    this.date = date;
    notifyListeners();
  }
}