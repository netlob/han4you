import 'package:flutter/material.dart';

class Commons {
  static const graphQLEndpoint = 'https://api2.han.nl/han4me-graphql/';
  static const microsoftBase = 'https://login.microsoftonline.com/';
  static const xeduleBase = 'https://sa-han.xedule.nl/';
  static const xeduleEndpoint = '$xeduleBase/api/';
  static const xeduleSSO = '$xeduleBase/Authentication/sso/SSOLogin.aspx/';

  // waarom is de officiele HAN kleur zo moeilijk te integreren...
  // gebruik blauw voor nu
  static Color primaryColor = Color(0xFF006CFF); // Color(0xFFE50056);

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    accentColor: HSLColor.fromColor(primaryColor).withLightness(0.63).toColor(),
    primaryColorLight: primaryColor,
    indicatorColor: primaryColor,
    fontFamily: 'LexendDeca',
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    accentColor: HSLColor.fromColor(primaryColor).withLightness(0.63).toColor(),
    primaryColorLight: primaryColor,
    indicatorColor: primaryColor,
    toggleableActiveColor: primaryColor,
    fontFamily: 'LexendDeca',
  );
}
