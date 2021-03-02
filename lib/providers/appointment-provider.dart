import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:han4you/api/exceptions/unauthenticated-exception.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:han4you/providers/facility-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/period-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/time-machine-utils.dart';
import 'package:han4you/utils/event-utils.dart';
import 'package:provider/provider.dart';
import 'package:timetable/timetable.dart';

class AppointmentProvider extends ChangeNotifier {
  bool loading = true;
  List<int> weeksDownloaded = [];
  List<Appointment> appointments = [];
  StreamController<List<BasicEvent>> eventStream =
      StreamController<List<BasicEvent>>.broadcast();

  void updateEvents(BuildContext context) {
    final groups = context.read<GroupProvider>().selectedGroups;
    final facilities = context.read<FacilityProvider>().facilities;

    final events = EventUtils.getEventsFromAppointments(appointments, facilities, groups);
    eventStream.add(events);
  }

  void fetchAppointments(BuildContext context) async {
    final xeduleProvider = context.read<XeduleProvider>();
    final periodProvider = context.read<PeriodProvider>();
    final groupProvider = context.read<GroupProvider>();
    final dateProvider = context.read<DateProvider>();

    int weekNumber = TimeMachineUtils.weekNumber(dateProvider.date);
    if (weeksDownloaded.contains(weekNumber)) {
      updateEvents(context);
      setLoading(false);
      return;
    }

    setLoading(true);

    try {
      if (periodProvider.periods.length == 0) {
        await periodProvider.fetchPeriods(context);
      }

      final appointments = await xeduleProvider.xedule.fetchAppointments(
        groupProvider.selectedGroups,
        periodProvider.periods,
        weekNumber,
      );

      setLoading(false);
      addAppointments(appointments);
      addDownloadedWeek(weekNumber);
      updateEvents(context);
    } catch (exception) {
      if (exception is UnauthenticatedException) {
        xeduleProvider.resetConfig();
        xeduleProvider.save();
      } else {
        throw exception;
      }

      setLoading(false);
    }
  }

  void addAppointments(List<Appointment> appointments) {
    for (final appointment in appointments) {
      this.appointments.removeWhere((a) => a.id == appointment.id);
      this.appointments.add(appointment);
    }
  }

  void addDownloadedWeek(int weekNumber) {
    if(weeksDownloaded.contains(weekNumber)) return;
    this.weeksDownloaded.add(weekNumber);
  }


  void setLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }

  void clear() {
    this.weeksDownloaded.clear();
    this.appointments.clear();
  }
}
