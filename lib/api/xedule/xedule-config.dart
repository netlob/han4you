class XeduleConfig {
  String endpoint;
  String userId;
  String sessionId;

  XeduleConfig({this.endpoint, this.userId, this.sessionId});

  bool get authenticated =>
      endpoint != null && userId != null && sessionId != null;

  XeduleConfig.fromJson(Map<String, dynamic> json) {
    endpoint = json['endpoint'];
    userId = json['userId'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['endpoint'] = this.endpoint;
    data['userId'] = this.userId;
    data['sessionId'] = this.sessionId;
    return data;
  }
}
