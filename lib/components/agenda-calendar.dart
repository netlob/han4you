import 'package:flutter/material.dart';
import 'package:han4you/components/design/typography-design.dart';
import 'package:table_calendar/table_calendar.dart';

typedef void OnDaySelected(DateTime date);

class AgendaCalendar extends StatefulWidget {
  final OnDaySelected onDaySelected;

  AgendaCalendar({@required this.onDaySelected});

  @override
  _AgendaCalendarState createState() => _AgendaCalendarState();
}

class _AgendaCalendarState extends State<AgendaCalendar> {
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
          calendarStyle: CalendarStyle(
            selectedColor: Theme.of(context).primaryColor,
            todayColor: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          weekendDays: [],
          initialCalendarFormat: CalendarFormat.week,
          onDaySelected: (date, _, __) {
            widget.onDaySelected(date);
          },
        ),
        Ink(
          color: Theme.of(context).primaryColor,
          height: 50,
          child: InkWell(
            child: Center(
              child: Text(
                'GA NAAR VANDAAG',
                style: TypographyDesign.overline.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _calendarController.setSelectedDay(DateTime.now());
              });
            },
          ),
        ),
      ],
    );
  }
}
