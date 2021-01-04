import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:han4you/api/graphql/graphql-query.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/models/graphql/outage.dart';
import 'package:han4you/utils/commons.dart';

List<Outage> decodeListFromBody(String body) {
  final json = jsonDecode(body);
  final outages = json['data']['outages'];

  return outages.map<Outage>((json) => Outage.fromJson(json)).toList();
}

class OutageProvider extends ChangeNotifier {
  GraphQL _graphql = GraphQL(endpoint: Commons.graphQLEndpoint);

  bool loading = false;
  Map<String, List<Outage>> outages = Map<String, List<Outage>>();

  void fetchOutages(String status) async {
    loading = true;

    GraphQLQuery query = GraphQLQuery(
      '{outages: outages(outageStatus: $status) {title link publicationDate outageStatus description}}',
    );
    String body = await _graphql.execute(query);
    outages[status] = decodeListFromBody(body);

    loading = false;
    notifyListeners();
  }
}
