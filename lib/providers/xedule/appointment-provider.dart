import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/helpers.dart';
import 'package:provider/provider.dart';

List<Appointment> decodeListFromBody(String body) {
  final appointments = jsonDecode(body)[0]['apps'];
  print(body);
  return appointments.map<Appointment>((json) => Appointment.fromJson(json)).toList();
}

class AppointmentProvider extends ChangeNotifier {
  bool loading = false;
  List<Appointment> appointments;
  Appointment appointment;

  void fetchAppointments(BuildContext context, DateTime date) async {
    loading = true;

    Xedule xedule = context.read<XeduleProvider>().xedule;
    int weekNum = Helpers.weekNumber(date);

    String body = await xedule.get('schedule/?ids[0]=17_2020_${weekNum}_22735');
    appointments = await compute(decodeListFromBody, body);
    appointment = appointments[date.weekday];

    loading = false;
    notifyListeners();
  }
}
