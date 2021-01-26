import 'package:flutter/foundation.dart';
import 'package:han4you/api/exceptions/unauthenticated-exception.dart';
import 'package:han4you/models/xedule/appointment.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/models/xedule/year.dart';
import 'package:han4you/utils/helpers.dart';
import 'package:http/http.dart' as http;

import 'xedule-config.dart';

class Xedule {
  String endpoint;
  XeduleConfig config;

  Xedule({this.endpoint, this.config});

  Future<String> get(String url) async {
    final headers = {
      'Cookie': 'ASP.NET_SessionId=${config.sessionId}; User=${config.userId}'
    };

    final res = await http.get(endpoint + url, headers: headers);
    if(res.body == '') throw UnauthenticatedException('no response body');
    return res.body;
  }

  Future<List<Appointment>> fetchAppointments(DateTime date) async {
    int weekNum = Helpers.weekNumber(date);

    String body = await get('schedule/?ids[0]=17_2020_${weekNum}_22735');
    return await compute(Appointment.decodeListFromBody, body);
  }

  Future<List<Group>> fetchGroups() async {
    String body = await get("group");
    return await compute(Group.decodeListFromBody, body);
  }

  Future<List<Year>> fetchYears() async {
    String body = await get("year");
    return await compute(Year.decodeListFromBody, body);
  }
}
