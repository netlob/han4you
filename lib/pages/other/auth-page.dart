import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/han-api/oauth/oauth.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _codeVerifier = OAuth.createCodeVerifier();
  
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: OAuth.createAuthUrl(_codeVerifier),
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          if(url.startsWith(OAuth.redirectUrl)) {
            print('AUTH === ' + url);
          }
        },
      ),
    );
  }
}
