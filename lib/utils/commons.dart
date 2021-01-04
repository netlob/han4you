import 'package:flutter/material.dart';

class Commons {
  static const graphQLEndpoint = 'https://api2.han.nl/han4me-graphql/';
  static const xeduleEndpoint = 'https://sa-han.xedule.nl/api/';
  static const xeduleSSOUrl =
      'https://sa-han.xedule.nl/Authentication/sso/SSOLogin.aspx';

  // waarom is de officiele HAN kleur zo moeilijk te integreren...
  // gebruik blauw voor nu
  static const primaryLight = const Color(0xFF006CFF); //const Color(0xFFE50056);
  static const primaryDark = const Color(0xFF006CFF);

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    accentColor: HSLColor.fromColor(primaryLight).withLightness(0.63).toColor(),
    primaryColorLight: primaryLight,
    indicatorColor: primaryLight,
    fontFamily: 'LexendDeca',
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   selectedItemColor: Colors.white,
    //   backgroundColor: primaryLight,
    //   unselectedItemColor: Colors.white.withOpacity(0.75)
    // ),
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    accentColor: HSLColor.fromColor(primaryDark).withLightness(0.63).toColor(),
    primaryColorLight: primaryDark,
    indicatorColor: primaryDark,
    toggleableActiveColor: primaryDark,
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   selectedItemColor: Colors.white,
    //   backgroundColor: primaryDark,
    // ),
    fontFamily: 'LexendDeca',
  );
}
