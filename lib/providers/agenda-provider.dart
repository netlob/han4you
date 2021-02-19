import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:time_machine/time_machine.dart';

class AgendaProvider extends ChangeNotifier {
  LocalDate date = LocalDate.today();
  List<Appointment> appointments = [];

  void setDate(LocalDate date) {
    this.date = date;
    notifyListeners();
  }

  void setAppointments(List<Appointment> appointments) {
    this.appointments = appointments;
    notifyListeners();
  }
}