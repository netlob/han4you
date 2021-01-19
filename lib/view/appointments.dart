import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:han4you/models/xedule/appointment.dart';

class Appointments extends StatefulWidget {
  final List<Appointment> appointments;
  final DateTime date;

  const Appointments({@required this.appointments, @required this.date});

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  @override
  Widget build(BuildContext context) {
    List<FlutterWeekViewEvent> events = widget.appointments
        .map(
          (a) => FlutterWeekViewEvent(
            title: a.name,
            description: a.summary,
            start: a.start,
            end: a.end,
            textStyle: TextStyle(
              fontFamily: 'LexendDeca',
            ),
            backgroundColor: Theme.of(context).accentColor,
          ),
        )
        .toList();

    return DayView(
      date: widget.date,
      events: events,
      hoursColumnStyle: HoursColumnStyle(
        color: Theme.of(context).canvasColor,
        textStyle: TextStyle(
          color: const Color(0xFF616161),
        ),
      ),
      style: DayViewStyle(
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundRulesColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
        currentTimeRuleColor: Theme.of(context).primaryColor,
        currentTimeCircleColor: Theme.of(context).primaryColor,
        headerSize: 0,
      ),
      userZoomable: false,
    );
  }
}
