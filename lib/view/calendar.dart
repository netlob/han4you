import 'package:flutter/material.dart';
import 'package:han4you/providers/appointment-provider.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/src/content/timetable_content.dart';
import 'package:timetable/timetable.dart' as timetable;

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateProvider _dateProvider;
  AppointmentProvider _appointmentProvider;
  timetable.EventProvider<timetable.BasicEvent> _basicEventProvider;
  timetable.TimetableController _timetableController;

  bool _animating = false;

  void _setCurrentDate() {
    if (_animating) return;
    _dateProvider.setDate(_timetableController.dateListenable.value);
  }

  void _animateToDate() async {
    _appointmentProvider.fetchAppointments(context);

    _animating = true;
    await _timetableController.animateTo(_dateProvider.date);
    _animating = false;
  }

  @override
  void initState() {
    _dateProvider = context.read<DateProvider>();
    _appointmentProvider = context.read<AppointmentProvider>();

    _basicEventProvider =
        timetable.EventProvider.simpleStream(_appointmentProvider.eventStream.stream);
    _timetableController = timetable.TimetableController<timetable.BasicEvent>(
      eventProvider: _basicEventProvider,
      initialTimeRange: timetable.InitialTimeRange.range(
        startTime: LocalTime(4, 30, 0),
        endTime: LocalTime(18, 0, 0),
      ),
      initialDate: _dateProvider.date,
      visibleRange: timetable.VisibleRange.days(1),
      firstDayOfWeek: DayOfWeek.monday,
    );

    _timetableController.dateListenable.addListener(_setCurrentDate);
    _dateProvider.addListener(_animateToDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appointmentProvider.fetchAppointments(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    _basicEventProvider.dispose();
    _timetableController.dateListenable.removeListener(_setCurrentDate);
    _dateProvider.removeListener(_animateToDate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimetableContent<timetable.BasicEvent>(
      controller: _timetableController,
      eventBuilder: (event) => timetable.BasicEventWidget(event),
    );
  }
}
