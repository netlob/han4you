import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/models/xedule/facility.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/agenda-provider.dart';
import 'package:han4you/providers/facility-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/src/content/timetable_content.dart';
import 'package:timetable/timetable.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  GroupProvider _groupProvider;
  AgendaProvider _agendaProvider;
  FacilityProvider _facilityProvider;
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
    _agendaProvider.setDate(_timetableController.dateListenable.value);
  }

  void _updateEvents() {
    List<BasicEvent> events = [];

    for (Appointment appointment in _agendaProvider.appointments) {
      if (events.where((e) => e.id == appointment.id).length > 0) continue;

      List<Group> groups = _getGroupByAppointment(appointment);
      List<Facility> facilities = _getFacilitiesByAppointment(appointment);
      int groupsId = groups.fold(0, (p, g) => p + int.parse(g.id) % 127);

      Random random = Random(groupsId);

      BasicEvent event = BasicEvent(
        id: appointment.id,
        title: _createTitle(appointment, groups, facilities),
        start: appointment.start,
        end: appointment.end,
        color: Colors.accents[random.nextInt(Colors.accents.length)],
      );

      events.add(event);
    }

    _eventController.add(events);
  }

  List<Group> _getGroupByAppointment(Appointment appointment) {
    List<Group> groups = _groupProvider.selectedGroups;
    return groups
        .where(
          (g) => appointment.atts.contains(int.parse(g.id)),
        )
        .toList();
  }

  List<Facility> _getFacilitiesByAppointment(Appointment appointment) {
    List<Facility> facilities = _facilityProvider.facilities;
    return facilities
        .where(
          (f) => appointment.atts.contains(int.parse(f.id)),
        )
        .toList();
  }

  String _createTitle(
    Appointment appointment,
    List<Group> groups,
    List<Facility> facilities,
  ) {
    const hourPattern = 'hh:mm';

    String title =
        '${appointment.name} - ${appointment.start.toString(hourPattern)}-${appointment.end.toString(hourPattern)}';
    for (Group group in groups) {
      title += '\n${group.code}';
    }
    for (Facility facility in facilities) {
      title += '\n${facility.code}';
    }

    return title;
  }

  @override
  void initState() {
    _agendaProvider = context.read<AgendaProvider>();
    _groupProvider = context.read<GroupProvider>();
    _facilityProvider = context.read<FacilityProvider>();

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
