import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:han4you/providers/xedule/xedule-provider.dart';
import 'package:han4you/providers/xedule/appointment-provider.dart';
import 'package:han4you/view/appointment-list.dart';
import 'package:han4you/view/xedule-auth.dart';
import 'package:han4you/view/calendar.dart';
import 'package:provider/provider.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Xedule xedule = context.watch<XeduleProvider>().xedule;

    if (xedule.config.authenticated) {
      return Column(
        children: [
          Calendar(
            onDaySelected: (date) {
              final appointmentProvider = context.read<AppointmentProvider>();

              context.read<DateProvider>().setDate(date);

              if (appointmentProvider.appointments == null) {
                appointmentProvider.fetchAppointments(context, date);
              }
            },
          ),
          Expanded(
            child: AppointmentList(),
          ),
        ],
      );
    }

    return XeduleAuth();
  }
}
