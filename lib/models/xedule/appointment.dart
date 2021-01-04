class Appointment {
  String name;
  String summary;
  String attention;
  Null meetingInfo;
  String iStart;
  String iEnd;
  List<int> atts;
  String id;

  Appointment({
    this.name,
    this.summary,
    this.attention,
    this.meetingInfo,
    this.iStart,
    this.iEnd,
    this.atts,
    this.id,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    summary = json['summary'];
    attention = json['attention'];
    meetingInfo = json['meetingInfo'];
    iStart = json['iStart'];
    iEnd = json['iEnd'];
    atts = json['atts'].cast<int>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['summary'] = this.summary;
    data['attention'] = this.attention;
    data['meetingInfo'] = this.meetingInfo;
    data['iStart'] = this.iStart;
    data['iEnd'] = this.iEnd;
    data['atts'] = this.atts;
    data['id'] = this.id;
    return data;
  }
}
