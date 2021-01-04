import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:han4you/api/graphql/graphql-query.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/models/graphql/room.dart';
import 'package:han4you/utils/commons.dart';

List<Room> decodeListFromBody(String body) {
  final json = jsonDecode(body);
  final rooms = json['data']['rooms'];
  return rooms.map<Room>((json) => Room.fromJson(json)).toList();
}

class RoomProvider extends ChangeNotifier {
  GraphQL _graphql = GraphQL(endpoint: Commons.graphQLEndpoint);

  bool loading = false;
  List<Room> rooms;

  void fetchRooms(String address) async {
    loading = true;

    GraphQLQuery query = GraphQLQuery(
      'query (\$code: String!) { rooms(building: \$code) { available id name total }}',
      variables: {
        'code': address,
      },
    );
    String body = await _graphql.execute(query);
    rooms = await compute(decodeListFromBody, body);

    loading = false;
    notifyListeners();
  }
}
