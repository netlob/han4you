import 'package:time_machine/time_machine.dart';

class Helpers {
  static int weekNumber(LocalDate date) {
    int dayOfYear = date.dayOfYear;
    return ((dayOfYear - date.dayOfWeek.value + 10) / 7).floor();
  }

  static LocalDate localDate(DateTime date) {
    return LocalDate(date.year, date.month, date.day);
  }

  static LocalDateTime localDateTime(DateTime date) {
    return LocalDateTime(date.year, date.month, date.day, date.hour, date.minute, date.second);
  }
}