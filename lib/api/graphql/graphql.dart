import 'dart:convert';

import 'package:http/http.dart' as http;

import 'graphql-query.dart';

dynamic decode(String json) {
  return jsonDecode(json);
}

class GraphQL {
  String endpoint;

  GraphQL({this.endpoint});

  Future<String> execute(GraphQLQuery query) async {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = {'query': query.query, 'variables': query.variables};
    final res =
        await http.post(endpoint, headers: headers, body: jsonEncode(body));
    return res.body;
  }
}
