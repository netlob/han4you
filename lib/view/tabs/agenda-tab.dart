import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/unauthenticated-exception.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/period-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/helpers.dart';
import 'package:han4you/view/appointments.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:han4you/view/header.dart';
import 'package:han4you/view/pages/auth-page.dart';
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
    if (Helpers.weekNumber(_date) != _weekNum) {
      _retrieveAppointments(context);
    }
  }

  void _retrieveAppointments(BuildContext context) {
    PeriodProvider calendarProvider = context.read<PeriodProvider>();
    GroupProvider groupProvider = context.read<GroupProvider>();
    XeduleProvider xeduleProvider = context.read<XeduleProvider>();

    _weekNum = Helpers.weekNumber(_date);
    _appointmentsFuture = xeduleProvider.xedule.fetchAppointments(
      groupProvider.selectedGroups,
      calendarProvider.periods,
      _date,
    );

    _appointmentsFuture.catchError((exception) {
      if (exception is UnauthenticatedException) {
        context.read<XeduleProvider>().setAuthenticated(false);
      }
    });
  }

  @override
  void initState() {
    bool authenticated = context.read<XeduleProvider>().authenticated;

    if (authenticated) {
      _checkWeekRetrieval(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool authenticated = context.watch<XeduleProvider>().authenticated;

    if (!authenticated) {
      return Column(
        children: [
          Header(title: 'Agenda', subtitle: 'log in om door te gaan'),
          FractionallySizedBox(
            widthFactor: 0.75,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
              icon: Icon(Icons.login),
              label: Text('Log in met HAN'),
            ),
          )
        ],
      );
    }

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
            builder: (appointments) {
              return Appointments(
                appointments: appointments,
                date: _date,
              );
            },
          ),
        ),
      ],
    );
  }
}
