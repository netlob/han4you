import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/unauthenticated-exception.dart';
import 'package:han4you/providers/agenda-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/period-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/helpers.dart';
import 'package:han4you/view/calendar.dart';
import 'package:han4you/view/header.dart';
import 'package:han4you/view/pages/auth-page.dart';
import 'package:han4you/view/date-selector.dart';
import 'package:han4you/view/pages/group-page.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  XeduleProvider _xeduleProvider;
  AgendaProvider _agendaProvider;
  GroupProvider _groupProvider;
  PeriodProvider _periodProvider;

  int _weekNum = 0;

  void _retrieveAppointments() {
    LocalDate date = _agendaProvider.date;
    if (Helpers.weekNumber(date) == _weekNum) return;

    _weekNum = Helpers.weekNumber(date);
    final appointmentFuture = _xeduleProvider.xedule.fetchAppointments(
      _groupProvider.selectedGroups,
      _periodProvider.periods,
      date,
    );

    appointmentFuture.then((appointments) {
      _agendaProvider.setAppointments(appointments);
      return;
    }).catchError((exception) {
      if (exception is UnauthenticatedException) {
        _xeduleProvider.setAuthenticated(false);
      }
    });
  }

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Widget _unauthenticatedState() {
    bool authenticated = context.watch<XeduleProvider>().authenticated;

    return Column(
      children: [
        Header(title: 'Agenda', subtitle: 'volg de stappen om door te gaan'),
        FractionallySizedBox(
          widthFactor: 0.75,
          child: ElevatedButton.icon(
            label: Text('Log in met HAN sso'),
            icon: Icon(Icons.login),
            onPressed: authenticated ? null : () => _openPage(AuthPage()),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.75,
          child: ElevatedButton.icon(
            label: Text('Selecteer groepen'),
            icon: Icon(Icons.group),
            onPressed: !authenticated ? null : () => _openPage(GroupPage()),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    _xeduleProvider = context.read<XeduleProvider>();
    _agendaProvider = context.read<AgendaProvider>();
    _groupProvider = context.read<GroupProvider>();
    _periodProvider = context.read<PeriodProvider>();

    _agendaProvider.addListener(_retrieveAppointments);
    _groupProvider.addListener(_retrieveAppointments);
    super.initState();
  }

  @override
  void dispose() {
    _agendaProvider.removeListener(_retrieveAppointments);
    _groupProvider.removeListener(_retrieveAppointments);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool authenticated = context.watch<XeduleProvider>().authenticated;
    bool groupsSelected =
        context.watch<GroupProvider>().selectedGroups.length != 0;

    if (groupsSelected && authenticated) {
      return Column(
        children: [
          DateSelector(),
          Expanded(
            child: Calendar(),
          ),
        ],
      );
    }

    return _unauthenticatedState();
  }
}
