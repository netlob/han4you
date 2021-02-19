import 'dart:convert';

class Period {
  int oru;
  int year;
  List<int> schs;
  int periodCount;
  bool hasCalendar;
  String cal;
  String dayStart;
  String dayEnd;
  DateTime start;
  DateTime end;
  int firstDayOfWeek;
  int lastDayOfWeek;
  String id;

  Period({
    this.oru,
    this.year,
    this.schs,
    this.periodCount,
    this.hasCalendar,
    this.cal,
    this.start,
    this.end,
    this.dayStart,
    this.dayEnd,
    this.firstDayOfWeek,
    this.lastDayOfWeek,
    this.id,
  });

  static List<Period> decodeListFromBody(String body) {
    final years = jsonDecode(body);
    return years.map<Period>((json) => Period.fromJson(json)).toList();
  }

  Period.fromJson(Map<String, dynamic> json) {
    oru = json['oru'];
    year = json['year'];
    schs = json['schs'].cast<int>();
    periodCount = json['periodCount'];
    hasCalendar = json['hasCalendar'];
    cal = json['cal'];
    start = DateTime.parse(json['iStart']);
    end = DateTime.parse(json['iEnd']);
    dayStart = json['iStartOfDay'];
    dayEnd = json['iEndOfDay'];
    firstDayOfWeek = json['firstDayOfWeek'];
    lastDayOfWeek = json['lastDayOfWeek'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oru'] = this.oru;
    data['year'] = this.year;
    data['schs'] = this.schs;
    data['periodCount'] = this.periodCount;
    data['hasCalendar'] = this.hasCalendar;
    data['cal'] = this.cal;
    data['iStart'] = this.start.toIso8601String();
    data['iEnd'] = this.end.toIso8601String();
    data['iStartOfDay'] = this.dayStart;
    data['iEndOfDay'] = this.dayEnd;
    data['firstDayOfWeek'] = this.firstDayOfWeek;
    data['lastDayOfWeek'] = this.lastDayOfWeek;
    data['id'] = this.id;
    return data;
  }
}
