class CookieNotFoundException implements Exception {
  final String cookieName;
  const CookieNotFoundException([this.cookieName = ""]);

  String toString() => "CookieNotFoundException: $cookieName";
}