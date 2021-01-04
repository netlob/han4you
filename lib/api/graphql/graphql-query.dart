class GraphQLQuery {
  String query;
  Map<String, dynamic> variables;

  GraphQLQuery(this.query, {this.variables}) {
    if (variables == null) variables = {};
  }
}
