import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/helpers.dart';
import 'package:han4you/view/appointments.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:han4you/view/xedule-auth.dart';
import 'package:han4you/view/calendar.dart';
import 'package:provider/provider.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  Future<List<Appointment>> _appointmentsFuture;
  DateTime _date = DateTime.now();
  int _weekNum = 0;

  @override
  void initState() {
    Xedule xedule = context.read<XeduleProvider>().xedule;
    _appointmentsFuture = xedule.fetchAppointments(_date);
    _weekNum = Helpers.weekNumber(_date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Xedule xedule = context.watch<XeduleProvider>().xedule;

    if (xedule.config.authenticated) {
      return Column(
        children: [
          Calendar(
            onDaySelected: (date) {
              _date = date;
              int newWeekNum = Helpers.weekNumber(_date);

              if (newWeekNum != _weekNum) {
                _weekNum = newWeekNum;
                _appointmentsFuture = xedule.fetchAppointments(_date);
              }

              setState(() {});
            },
          ),
          Expanded(
            child: GenericFutureBuilder<List<Appointment>>(
              future: _appointmentsFuture,
              builder: (appointments) =>
                  Appointments(appointments: appointments, date: _date),
            ),
          ),
        ],
      );
    }

    return XeduleAuth();
  }
}
