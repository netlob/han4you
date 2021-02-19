import 'package:time_machine/time_machine.dart';

class Helpers {
  static int weekNumber(LocalDate date) {
    int dayOfYear = date.dayOfYear;
    return ((dayOfYear - date.dayOfWeek.value + 10) / 7).floor();
  }
}