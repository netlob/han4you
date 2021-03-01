import 'package:flutter/foundation.dart';
import 'package:time_machine/time_machine.dart';

class DateProvider extends ChangeNotifier {
  LocalDate date = LocalDate.today();

  void setDate(LocalDate date) {
    this.date = date;
    notifyListeners();
  }
}