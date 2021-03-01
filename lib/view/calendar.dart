import 'dart:async';

import 'package:flutter/material.dart';
import 'package:han4you/providers/appointment-provider.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:han4you/providers/event-provider.dart';
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
  EventProvider _eventProvider;
  AppointmentProvider _appointmentProvider;
  timetable.EventProvider<timetable.BasicEvent> _basicEventProvider;
  timetable.TimetableController _timetableController;
  StreamController<List<timetable.BasicEvent>> _eventController =
      StreamController<List<timetable.BasicEvent>>();

  bool _animating = false;

  void _updateEvents() {
    _eventProvider.updateEvents(context);
  }

  void _displayEvents() {
    _eventController.add(_eventProvider.events);
  }

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
    _eventProvider = context.read<EventProvider>();
    _appointmentProvider = context.read<AppointmentProvider>();

    _basicEventProvider =
        timetable.EventProvider.simpleStream(_eventController.stream);
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

    _eventProvider.addListener(_displayEvents);
    _dateProvider.addListener(_animateToDate);
    _appointmentProvider.addListener(_updateEvents);

    // Reset the downloaded weeks when groups have changed,
    // the appointments will be downloaded next time you access
    // the calendar
    _appointmentProvider.weeksDownloaded.clear();
    _appointmentProvider.fetchAppointments(context);
    super.initState();
  }

  @override
  void dispose() {
    _timetableController.dateListenable.removeListener(_setCurrentDate);

    _eventProvider.removeListener(_displayEvents);
    _dateProvider.removeListener(_animateToDate);
    _appointmentProvider.removeListener(_updateEvents);
    _eventController.close();
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
