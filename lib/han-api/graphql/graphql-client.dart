import 'dart:convert' as convert;

import 'package:han4you/han-api/graphql/graphql-cache-item.dart';
import 'package:http/http.dart' as http;

class GraphQLClient {
  String apiUrl;
  Map<String, GraphQLCacheItem> queryCache = Map<String, GraphQLCacheItem>();
  int now = DateTime.now().microsecond;

  GraphQLClient({this.apiUrl});

  Future<Map<String, dynamic>> query(String query,
      [Map<String, String> variables, bool force = false]) async {
    String cacheId = buildCacheId(query, variables);
    bool useCache = !force &&
        queryCache[cacheId] != null &&
        !queryCache[cacheId].isExpired();
    if (useCache) return queryCache[cacheId].value;

    var finalVariables = variables == null ? {} : variables;
    http.Response response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(
        {'query': query, 'variables': finalVariables},
      ),
    );

    if (response.statusCode != 200) throw response.body;

    var decodedBody = convert.jsonDecode(response.body);
    queryCache[cacheId] = GraphQLCacheItem(value: decodedBody);
    return decodedBody;
  }

  String buildCacheId(String query, [Map<String, String> variables]) {
    if (variables == null) {
      return query;
    } else {
      return '$query.${variables.keys.join()}.${variables.values.join()}';
    }
  }
}
