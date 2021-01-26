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
  DayViewController _controller = DayViewController();

  @override
  void initState() {
    _controller.changeZoomFactor(0.5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<FlutterWeekViewEvent> events = widget.appointments.map((ap) {
      return FlutterWeekViewEvent(
        title: ap.name,
        description: ap.summary,
        start: ap.start,
        end: ap.end,
        textStyle: TextStyle(
          fontFamily: 'LexendDeca',
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 2.5,
        ),
      );
    }).toList();

    bool dayEmpty = true;
    for (FlutterWeekViewEvent event in events) {
      if (event.start.day == widget.date.day &&
          event.end.day == widget.date.day) {
        dayEmpty = false;
        break;
      }
    }

    if (dayEmpty) {
      return Center(
        child: Text('Geen afspraken vandaag'),
      );
    }

    return DayView(
      controller: _controller,
      date: widget.date,
      events: events,
      hoursColumnStyle: HoursColumnStyle(
        textStyle: TextStyle(
          color: const Color(0xFF616161),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
      ),
      style: DayViewStyle(
        backgroundColor: Theme.of(context).canvasColor,
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
