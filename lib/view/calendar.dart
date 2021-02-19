import 'package:flutter/material.dart';
import 'package:han4you/providers/agenda-provider.dart';
import 'package:han4you/view/bar-button.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_machine/time_machine.dart';

typedef void OnDaySelected(DateTime date);

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  AgendaProvider _agendaProvider;
  CalendarController _calendarController;

  void _onDateChanged() {
    setState(() {
      _calendarController.setSelectedDay(
        _agendaProvider.date.toDateTimeUnspecified(),
      );
    });
  }

  @override
  void initState() {
    _agendaProvider = context.read<AgendaProvider>();
    _calendarController = CalendarController();
    _agendaProvider.addListener(_onDateChanged);

    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _agendaProvider.removeListener(_onDateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'nl_NL',
          calendarController: _calendarController,
          availableCalendarFormats: {
            CalendarFormat.week: 'week',
            CalendarFormat.twoWeeks: '2 weken',
            CalendarFormat.month: 'maand',
          },
          headerStyle: HeaderStyle(
            formatButtonDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            formatButtonTextStyle: TextStyle(color: Colors.white),
          ),
          calendarStyle: CalendarStyle(
            selectedColor: Theme.of(context).primaryColor,
            todayColor: Theme.of(context).accentColor,
          ),
          weekendDays: [],
          initialCalendarFormat: CalendarFormat.week,
          onDaySelected: (date, _, __) {
            _agendaProvider.setDate(LocalDate.dateTime(date));
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
        ),
        BarButton(
          "ga naar vandaag",
          onTap: () {
            _agendaProvider.setDate(LocalDate.today());
          },
        ),
      ],
    );
  }
}
