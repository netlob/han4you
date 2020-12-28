import 'package:han4you/api/graphql.dart';
import 'package:han4you/config.dart';

import 'models/graphql/building.dart';
import 'models/graphql/outage.dart';
import 'models/graphql/room.dart';

class GraphQLRepository {
  final _graphql = GraphQL(endpoint: AppConfig.graphQLEndpoint);

  Future<List<Building>> getBuildings() async {
    final query = GraphQLQuery(query: '{buildings {address available total}}');
    final res = await _graphql.decodedExecute(query);
    final buildings = res['data']['buildings'];

    return buildings.map<Building>((json) => Building.fromJson(json)).toList();
  }

  Future<List<Outage>> getOutages(String status) async {
    final query = GraphQLQuery(
      query:
          '{outages: outages(outageStatus: $status) {title link publicationDate outageStatus description}}',
    );

    final res = await _graphql.decodedExecute(query);
    final outages = res['data']['outages'];

    return outages.map<Outage>((json) => Outage.fromJson(json)).toList();
  }

  Future<List<Room>> getRooms(String address) async {
    final query = GraphQLQuery(
      query:
          'query (\$code: String!) { rooms(building: \$code) { available id name total }}',
      variables: {
        'code': address,
      },
    );

    final res = await _graphql.decodedExecute(query);
    final rooms = res['data']['rooms'];

    return rooms.map<Room>((json) => Room.fromJson(json)).toList();
  }
}
