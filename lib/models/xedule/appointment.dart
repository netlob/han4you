import 'dart:convert';

import 'package:han4you/utils/helpers.dart';
import 'package:time_machine/time_machine.dart';

class Appointment {
  String id;
  String name;
  String summary;
  String attention;
  String meetingInfo;
  LocalDateTime start;
  LocalDateTime end;
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
    List<Appointment> appointments = [];
    final json = jsonDecode(body);

    for (dynamic response in json) {
      if (response == null) continue;

      final apps = response['apps'];
      if (apps == null) return [];
      appointments.addAll(
        apps.map<Appointment>((json) => Appointment.fromJson(json)).toList(),
      );
    }

    return appointments;
  }

  Appointment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    summary = json['summary'];
    attention = json['attention'];
    meetingInfo = json['meetingInfo'];
    start = Helpers.localDateTime(DateTime.parse(json['iStart']));
    end = Helpers.localDateTime(DateTime.parse(json['iEnd']));
    atts = json['atts'].cast<int>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['summary'] = this.summary;
    data['attention'] = this.attention;
    data['meetingInfo'] = this.meetingInfo;
    data['iStart'] = this.start.toDateTimeLocal().toIso8601String();
    data['iEnd'] = this.end.toDateTimeLocal().toIso8601String();
    data['atts'] = this.atts;
    data['id'] = this.id;
    return data;
  }
}
