import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/models/xedule/facility.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:provider/provider.dart';
import 'package:timetable/timetable.dart';

import 'appointment-provider.dart';
import 'facility-provider.dart';
import 'group-provider.dart';

class EventProvider extends ChangeNotifier {
  List<BasicEvent> events = [];

  int _hashGroupList(List<Group> groups) {
    return groups.fold(0, (p, g) => p + int.parse(g.id) % 127);
  }

  String _createTitle(
      Appointment appointment,
      List<Group> groups,
      List<Facility> facilities,
      ) {
    const hourPattern = 'hh:mm';

    String title = '';
    title += '${appointment.name} - ';
    title +=
    '${appointment.start.toString(hourPattern)}-${appointment.end.toString(hourPattern)}';

    for (Group group in groups) {
      title += '\n${group.code}';
    }
    for (Facility facility in facilities) {
      title += '\n${facility.code}';
    }

    return title;
  }

  List<Group> _getGroupByAppointment(
      BuildContext context,
      Appointment appointment,
      ) {
    final groupProvider = context.read<GroupProvider>();
    final groups = groupProvider.selectedGroups;
    return groups
        .where((g) => appointment.atts.contains(int.parse(g.id)))
        .toList();
  }

  List<Facility> _getFacilitiesByAppointment(
      BuildContext context,
      Appointment appointment,
      ) {
    final facilityProvider = context.read<FacilityProvider>();
    final facilities = facilityProvider.facilities;

    return facilities
        .where((f) => appointment.atts.contains(int.parse(f.id)))
        .toList();
  }

  void updateEvents(BuildContext context) {
    final appointmentProvider = context.read<AppointmentProvider>();
    final appointments = appointmentProvider.appointments;

    for (final appointment in appointments) {
      if (events.where((e) => e.id == appointment.id).length > 0) continue;

      final groups = _getGroupByAppointment(context, appointment);
      final facilities = _getFacilitiesByAppointment(context, appointment);
      final groupsId = _hashGroupList(groups);

      final random = Random(groupsId);

      final event = BasicEvent(
        id: appointment.id,
        title: _createTitle(appointment, groups, facilities),
        start: appointment.start,
        end: appointment.end,
        color: Colors.accents[random.nextInt(Colors.accents.length)],
      );

      events.add(event);
    }

    notifyListeners();
  }
}