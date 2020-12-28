import 'dart:convert';

import 'package:http/http.dart' as http;

class GraphQL {
  String endpoint;

  GraphQL({this.endpoint});

  decodedExecute(GraphQLQuery query) async {
    return decode(await execute(query));
  }

  execute(GraphQLQuery query) async {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = {'query': query.query, 'variables': query.variables};
    final res =
        await http.post(endpoint, headers: headers, body: jsonEncode(body));
    return res.body;
  }

  decode(String body) {
    return jsonDecode(body);
  }
}

class GraphQLQuery {
  String query;
  Map<String, dynamic> variables;

  GraphQLQuery({this.query, this.variables}) {
    if (variables == null) variables = {};
  }
}
