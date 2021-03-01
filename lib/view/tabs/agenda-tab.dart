import 'package:flutter/material.dart';
import 'package:han4you/providers/appointment-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/view/authentication-steps.dart';
import 'package:han4you/view/calendar.dart';
import 'package:han4you/view/date-selector.dart';
import 'package:provider/provider.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AppointmentProvider>().loading;
    final authenticated =
        context.watch<XeduleProvider>().xedule.config.authenticated;
    final groupsSelected =
        context.watch<GroupProvider>().selectedGroups.length != 0;

    if (groupsSelected && authenticated) {
      return Column(
        children: [
          DateSelector(),
          Expanded(
            child: Calendar(),
          ),
          loading ? LinearProgressIndicator() : SizedBox.shrink(),
        ],
      );
    } else {
      return AuthenticationSteps();
    }
  }
}
