class UnauthenticatedException implements Exception {
  final String message;
  const UnauthenticatedException([this.message = ""]);

  String toString() => "UnauthenticatedException: $message";
}