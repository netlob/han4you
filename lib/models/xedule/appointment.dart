import 'dart:convert';

class Appointment {
  String id;
  String name;
  String summary;
  String attention;
  String meetingInfo;
  DateTime start;
  DateTime end;
  List<int> atts;

  Appointment({
    this.name,
    this.summary,
    this.attention,
    this.meetingInfo,
    this.start,
    this.end,
    this.atts,
    this.id,
  });

  static List<Appointment> decodeListFromBody(String body) {
    final appointments = jsonDecode(body)[0]['apps'];
    return appointments.map<Appointment>((json) => Appointment.fromJson(json)).toList();
  }

  Appointment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    summary = json['summary'];
    attention = json['attention'];
    meetingInfo = json['meetingInfo'];
    start = DateTime.parse(json['iStart']);
    end = DateTime.parse(json['iEnd']);
    atts = json['atts'].cast<int>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['summary'] = this.summary;
    data['attention'] = this.attention;
    data['meetingInfo'] = this.meetingInfo;
    data['iStart'] = this.start.toIso8601String();
    data['iEnd'] = this.end.toIso8601String();
    data['atts'] = this.atts;
    data['id'] = this.id;
    return data;
  }
}
