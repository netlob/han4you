import 'dart:math';

import 'package:flutter/material.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/models/xedule/facility.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:timetable/timetable.dart';

class EventUtils {
  static int getIdFromGroups(List<Group> groups) {
    return groups.fold(0, (p, g) => p + int.parse(g.id) % 127);
  }

  static String createTitle(
    Appointment appointment,
    List<Group> groups,
    List<Facility> facilities,
  ) {
    const hourPattern = 'HH:mm';

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

  static List<Group> getGroupByAppointment(
    Appointment appointment,
    List<Group> groups,
  ) {
    return groups
        .where((g) => appointment.atts.contains(int.parse(g.id)))
        .toList();
  }

  static List<Facility> getFacilitiesByAppointment(
    Appointment appointment,
    List<Facility> facilities,
  ) {
    return facilities
        .where((f) => appointment.atts.contains(int.parse(f.id)))
        .toList();
  }

  static List<BasicEvent> getEventsFromAppointments(
    List<Appointment> appointments,
    List<Facility> facilities,
    List<Group> groups,
  ) {
    List<BasicEvent> events = [];

    for (final appointment in appointments) {
      if (events.where((e) => e.id == appointment.id).length > 0) continue;

      final selectedGroups = getGroupByAppointment(appointment, groups);
      final selectedFacilities = getFacilitiesByAppointment(appointment, facilities);
      final groupsId = getIdFromGroups(selectedGroups);

      final random = Random(groupsId);

      final event = BasicEvent(
        id: appointment.id,
        title: createTitle(appointment, selectedGroups, selectedFacilities),
        start: appointment.start,
        end: appointment.end,
        color: Colors.accents[random.nextInt(Colors.accents.length)],
      );

      events.add(event);
    }

    return events;
  }
}
