import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/agenda-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/src/content/timetable_content.dart';
import 'package:timetable/timetable.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  AgendaProvider _agendaProvider;
  GroupProvider _groupProvider;
  EventProvider<BasicEvent> _eventProvider;
  TimetableController _timetableController;
  StreamController<List<BasicEvent>> _eventController =
      StreamController<List<BasicEvent>>();

  bool _animating = false;

  void _onAgendaDateChanged() async {
    _updateEvents();
    if (_animating) return;

    _animating = true;
    await _timetableController.animateTo(_agendaProvider.date);
    _animating = false;
  }

  void _onTimetableDateChanged() {
    if (_animating) return;

    _animating = true;
    _agendaProvider.setDate(_timetableController.dateListenable.value);
    _animating = false;
  }

  Group _getGroupByAppointment(Appointment appointment) {
    List<Group> groups = _groupProvider.selectedGroups;
    return groups.firstWhere((g) =>
        appointment.atts.contains(int.parse(g.id)));
  }

  String _createTitle(Appointment appointment, Group group) {
    const hourPattern = 'hh:mm';
    return '${appointment.name} - ${appointment.start.toString(hourPattern)}-${appointment.end.toString(hourPattern)}\n${group.code}';
  }

  void _updateEvents() {
    List<BasicEvent> events = [];

    for (Appointment appointment in _agendaProvider.appointments) {
      if (events.where((e) => e.id == appointment.id).length > 0) continue;

      Group group = _getGroupByAppointment(appointment);
      Random random = Random(int.parse(group.id));

      BasicEvent event = BasicEvent(
        id: appointment.id,
        title: _createTitle(appointment, group),
        start: appointment.start,
        end: appointment.end,
        color: Colors.accents[random.nextInt(Colors.accents.length)],
      );

      events.add(event);
    }

    _eventController.add(events);
  }

  @override
  void initState() {
    _agendaProvider = context.read<AgendaProvider>();
    _groupProvider = context.read<GroupProvider>();

    _eventProvider = EventProvider.simpleStream(_eventController.stream);
    _timetableController = TimetableController<BasicEvent>(
      eventProvider: _eventProvider,
      initialTimeRange: InitialTimeRange.range(
        startTime: LocalTime(4, 30, 0),
        endTime: LocalTime(18, 0, 0),
      ),
      initialDate: _agendaProvider.date,
      visibleRange: VisibleRange.days(1),
      firstDayOfWeek: DayOfWeek.monday,
    );

    _updateEvents();
    _agendaProvider.addListener(_onAgendaDateChanged);
    _timetableController.dateListenable.addListener(_onTimetableDateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _agendaProvider.removeListener(_onTimetableDateChanged);
    _timetableController.dateListenable.removeListener(_onTimetableDateChanged);

    _timetableController.dispose();
    _eventProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimetableContent<BasicEvent>(
      controller: _timetableController,
      eventBuilder: (event) => BasicEventWidget(event),
    );
  }
}
