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
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
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
        color: Theme.of(context).canvasColor,
        textStyle: TextStyle(
          color: const Color(0xFF616161),
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
