class GraphQLCacheItem {
  Map<String, dynamic> value;
  DateTime createdAt = DateTime.now();
  DateTime expiresAt = DateTime.now().add(
    Duration(
      minutes: 5,
    ),
  );

  GraphQLCacheItem({this.value});

  bool isExpired() {
    return DateTime.now().isAfter(this.expiresAt);
  }
}
