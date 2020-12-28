import 'package:flutter/material.dart';
import 'package:han4you/view/bar-button.dart';
import 'package:table_calendar/table_calendar.dart';

typedef void OnDaySelected(DateTime date);

class Calendar extends StatefulWidget {
  final OnDaySelected onDaySelected;

  Calendar({@required this.onDaySelected});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
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
            widget.onDaySelected(date);
          },
        ),
        BarButton(
          "ga naar vandaag",
          onTap: () {
            setState(() {
              _calendarController.setSelectedDay(DateTime.now());
            });
          },
        ),
      ],
    );
  }
}
