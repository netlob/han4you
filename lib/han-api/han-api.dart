import 'package:han4you/han-api/xedule/xedule-client.dart';

import 'graphql/graphql-client.dart';
import 'han-config.dart';
import 'models/han-building.dart';
import 'models/han-outage.dart';

class HanApi {
  static GraphQLClient graphQl = GraphQLClient(apiUrl: HanConfig.graphqlApiUrl);
  static XeduleClient xedule = XeduleClient(apiUrl: HanConfig.xeduleApiUrl);

  static Future<List<HanBuilding>> getBuildings() async {
    var res = await graphQl.query('{buildings {address available total}}');

    List<HanBuilding> buildings = List<HanBuilding>();
    for (var building in res['data']['buildings']) {
      buildings.add(HanBuilding.fromJson(building));
    }
    return buildings;
  }

  static Future<List<HanOutage>> getOutages(String outageStatus) async {
    var res = await graphQl.query(
      '{$outageStatus: outages(outageStatus: $outageStatus) {title link publicationDate outageStatus description}}',
    );

    if (res['data'][outageStatus] == null)
      throw 'Outage status "$outageStatus" not found';

    List<HanOutage> outages = List<HanOutage>();
    for (var outage in res['data'][outageStatus]) {
      outages.add(HanOutage.fromJson(outage));
    }
    return outages;
  }
}
