import 'package:han4you/han-api/oauth/oauth.dart';

import 'graphql/graphql.dart';
import 'models/building.dart';
import 'models/outage.dart';

class HanApi {
  static String apiUrl = 'https://api2.han.nl/han4me-graphql/';
  static GraphQLClient graphQl = GraphQLClient(apiUrl: apiUrl);

  static Future<List<Building>> getBuildings() async {
    var res = await graphQl.query('{buildings {address available total}}');
    List<Building> buildings = List<Building>();

    for (var building in res['data']['buildings']) {
      buildings.add(Building.fromJson(building));
    }

    return buildings;
  }

  static Future<List<Outage>> getOutages(String outageStatus) async {
    var res = await graphQl.query(
      '{$outageStatus: outages(outageStatus: $outageStatus) {title link publicationDate outageStatus description}}',
    );

    List<Outage> outages = List<Outage>();

    if (res['data'][outageStatus] == null)
      throw 'Outage status "$outageStatus" not found';

    for (var outage in res['data'][outageStatus]) {
      outages.add(Outage.fromJson(outage));
    }

    return outages;
  }
}
