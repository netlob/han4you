import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/han-api/han-config.dart';
import 'package:han4you/han-api/xedule/xedule-auth.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef void OnAuthenticated(XeduleAuth xeduleAuth);

class AuthView extends StatefulWidget {
  final OnAuthenticated onAuthenticated;

  AuthView({this.onAuthenticated});

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _loading = false;

  //THE PERSON WHO WROTE THIS LIBRARY TRIGGERS ME
  WebviewCookieManager _webViewCookieManager;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _webViewCookieManager = WebviewCookieManager();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return WebView(
      initialUrl: HanConfig.ssoLoginUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (String url) async {
        if (url == 'https://sa-han.xedule.nl/') {
          List<Cookie> cookies = await _webViewCookieManager.getCookies(url);
          Cookie userId = cookies.singleWhere((c) => c.name == 'User');
          Cookie sessionId = cookies.singleWhere(
            (c) => c.name == 'ASP.NET_SessionId',
          );

          if (userId == null) throw 'no User found';
          if (sessionId == null) throw 'no ASP.NET_SessionId found';

          XeduleAuth auth = XeduleAuth(
            userId: userId.value,
            sessionId: sessionId.value,
          );
          if (widget.onAuthenticated != null) widget.onAuthenticated(auth);
        }
      },
    );
  }
}
