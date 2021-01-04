import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:han4you/api/graphql/graphql-query.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/models/graphql/building.dart';
import 'package:han4you/utils/commons.dart';

List<Building> decodeListFromBody(String body) {
  final json = jsonDecode(body);
  final buildings = json['data']['buildings'];
  return buildings.map<Building>((json) => Building.fromJson(json)).toList();
}

class BuildingProvider extends ChangeNotifier {
  GraphQL _graphql = GraphQL(endpoint: Commons.graphQLEndpoint);

  bool loading = false;
  List<Building> buildings;

  void fetchBuildings() async {
    loading = true;

    GraphQLQuery query = GraphQLQuery('{buildings {address available total}}');
    String body = await _graphql.execute(query);
    buildings = await compute(decodeListFromBody, body);

    loading = false;
    notifyListeners();
  }
}
