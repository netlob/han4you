import 'package:flutter/foundation.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/commons.dart';

class GraphQLProvider extends ChangeNotifier {
  GraphQL graphql = GraphQL(endpoint: Commons.graphQLEndpoint);
}