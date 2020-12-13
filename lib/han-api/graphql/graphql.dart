import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'cache-item.dart';

class GraphQLClient {
  String apiUrl;
  HashMap<String, CacheItem> queryCache = HashMap<String, CacheItem>();
  int now = DateTime.now().microsecond;

  GraphQLClient({this.apiUrl});

  Future<Map<String, dynamic>> query(String query,
      [Map<String, String> variables, bool force = false]) async {
    String cacheId = buildCacheId(query, variables);
    bool useCache = !force &&
        queryCache[cacheId] != null &&
        !queryCache[cacheId].isExpired();
    if (useCache) return queryCache[cacheId].value;

    Map<String, String> finalVariables = variables == null ? {} : variables;
    http.Response response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(
        <String, dynamic>{'query': query, 'variables': finalVariables},
      ),
    );

    if (response.statusCode != 200) throw response.body;

    Map<String, dynamic> decodedBody = convert.jsonDecode(response.body);
    queryCache[cacheId] = CacheItem(value: decodedBody);
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
