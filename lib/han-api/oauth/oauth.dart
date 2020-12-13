import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class OAuth {
  static Random _random = Random();
  static String appId = '5d73e7b7-b3e1-4d00-b303-056140b2a3b4';
  static String clientId = '288d35bf-6285-4d4b-9199-9004a96c9093';
  static String redirectUrl = 'nl.han.app://auth';
  static String responseType = 'code';
  static String codeChallengeMethod = 'S256';

  static List<int> randomBytes(int len) {
    return List<int>.generate(32, (i) => _random.nextInt(256));
  }

  static randomString(int len) {
    return String.fromCharCodes(List.generate(len, (index) => _random.nextInt(33) + 89));
  }

  static safeBase64Encode(List<int> bytes) {
    String encoded = base64UrlEncode(bytes);
    encoded = encoded.replaceAll('+', '-');
    encoded = encoded.replaceAll('/', '-');
    encoded = encoded.replaceAll('=', '');

    return encoded;
  }

  static String createCodeVerifier() {
    String verifier = safeBase64Encode(randomBytes(32));
    return verifier;
  }

  static String createCodeChallenge(String verifier) {
    List<int> hash = sha256.convert(utf8.encode(verifier)).bytes;
    String finals = safeBase64Encode(hash);
    return finals;
  }

  static String createAuthUrl(String verifier) {
    String state = OAuth.randomString(8);
    String codeChallenge = OAuth.createCodeChallenge(verifier);

    return 'https://login.microsoftonline.com/$appId/oauth2/authorize?redirect_uri=$redirectUrl&client_id=$clientId&response_type=$responseType&state=$state&code_challenge=$codeChallenge&code_challenge_method=$codeChallengeMethod';
  }
}