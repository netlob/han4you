import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:han4you/providers/xedule/appointment-provider.dart';
import 'package:provider/provider.dart';

class AppointmentList extends StatefulWidget {
  final List<Appointment> appointments;

  const AppointmentList({this.appointments});

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<DateProvider>().date;
    final appointments = context.watch<AppointmentProvider>().appointments;

    List<FlutterWeekViewEvent> events = appointments
        .map(
          (a) => FlutterWeekViewEvent(
            title: a.name,
            description: a.summary,
            start: a.start,
            end: a.end,
            textStyle: TextStyle(
              fontFamily: 'LexendDeca',
            ),
            backgroundColor: Theme.of(context).accentColor
          ),
        )
        .toList();

    return DayView(
      date: selectedDate,
      events: events,
      hoursColumnStyle: HoursColumnStyle(
        color: Theme.of(context).canvasColor,
        textStyle: TextStyle(
          color: const Color(0xFF616161),
        )
      ),
      style: DayViewStyle(
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundRulesColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
        currentTimeRuleColor: Theme.of(context).primaryColor,
        currentTimeCircleColor: Theme.of(context).primaryColor,
        headerSize: 0,
      ),
      userZoomable: false,
    );
  }
}
