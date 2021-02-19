import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:han4you/models/graphql/building.dart';
import 'package:han4you/models/graphql/outage.dart';
import 'package:han4you/models/graphql/room.dart';
import 'package:http/http.dart' as http;

import 'graphql-query.dart';

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

  Future<List<Building>> fetchBuildings() async {
    GraphQLQuery query = GraphQLQuery('{buildings {address available total}}');
    String body = await execute(query);
    return await compute(Building.decodeListFromBody, body);
  }

  Future<List<Outage>> fetchOutages(String status) async {
    GraphQLQuery query = GraphQLQuery(
      '{outages: outages(outageStatus: $status) {title link publicationDate outageStatus description}}',
    );
    String body = await execute(query);
    return await compute(Outage.decodeListFromBody, body);
  }

  Future<List<Room>> fetchRooms(String address) async {
    GraphQLQuery query = GraphQLQuery(
      'query (\$code: String!) { rooms(building: \$code) { available id name total }}',
      variables: {
        'code': address,
      },
    );
    String body = await execute(query);
    return await compute(Room.decodeListFromBody, body);
  }
}
