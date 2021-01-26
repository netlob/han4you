import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/unauthenticated-exception.dart';
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

  void _checkWeekRetrieval(BuildContext context) {
    print(Helpers.weekNumber(_date));
    print(_weekNum);
    if (Helpers.weekNumber(_date) != _weekNum) {
      _retrieveAppointments(context);
    }
  }

  void _retrieveAppointments(BuildContext context) {
    Xedule xedule = context.read<XeduleProvider>().xedule;
    
    _weekNum = Helpers.weekNumber(_date);
    _appointmentsFuture = xedule.fetchAppointments(_date);
    _appointmentsFuture.catchError((exception) {
      if (exception is UnauthenticatedException) {
        context.read<XeduleProvider>().setAuthenticated(false);
      }
    });
  }

  @override
  void initState() {
    _checkWeekRetrieval(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool authenticated = context.watch<XeduleProvider>().authenticated;

    if (authenticated) {
      return Column(
        children: [
          Calendar(
            onDaySelected: (date) {
              setState(() {
                _date = date;
              });

              _checkWeekRetrieval(context);
            },
          ),
          Expanded(
            child: GenericFutureBuilder<List<Appointment>>(
              future: _appointmentsFuture,
              builder: (appointments) => Appointments(
                appointments: appointments,
                date: _date,
              ),
            ),
          ),
        ],
      );
    }

    return XeduleAuth(onAuthenticated: () {
      setState(() {
        _retrieveAppointments(context);
      });
    });
  }
}
