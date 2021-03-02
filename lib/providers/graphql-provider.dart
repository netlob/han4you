import 'package:flutter/foundation.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'file:///C:/Users/idiidk/StudioProjects/han4you/lib/commons.dart';

class GraphQLProvider extends ChangeNotifier {
  GraphQL graphql = GraphQL(endpoint: Commons.graphQLEndpoint);
}