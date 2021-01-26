import 'package:han4you/models/xedule/schedule.dart';

class XeduleConfig {
  String userId;
  String sessionId;
  List<Schedule> schedules;

  XeduleConfig({this.userId, this.sessionId, this.schedules});
}