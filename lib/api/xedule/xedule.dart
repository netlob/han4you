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
    return res.body;
  }
}
