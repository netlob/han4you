import 'dart:convert';

class Outage {
  String title;
  String link;
  String publicationDate;
  String outageStatus;
  String description;

  Outage({
    this.title,
    this.link,
    this.publicationDate,
    this.outageStatus,
    this.description,
  });

  static List<Outage> decodeListFromBody(String body) {
    final json = jsonDecode(body);
    final outages = json['data']['outages'];

    return outages.map<Outage>((json) => Outage.fromJson(json)).toList();
  }

  Outage.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'];
    publicationDate = json['publicationDate'];
    outageStatus = json['outageStatus'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['link'] = this.link;
    data['publicationDate'] = this.publicationDate;
    data['outageStatus'] = this.outageStatus;
    data['description'] = this.description;
    return data;
  }
}