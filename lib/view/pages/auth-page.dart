import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/cookie-not-found-exception.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/providers/period-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/commons.dart';
import 'package:provider/provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  WebViewController _webViewController;
  WebviewCookieManager _webViewCookieManager;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _webViewCookieManager = WebviewCookieManager();

    if (_webViewController != null) {
      _webViewController.clearCache();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: Commons.xeduleSSOUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onPageFinished: (String url) async {
            if (url != 'https://sa-han.xedule.nl/') return;

            List<Cookie> cookies = await _webViewCookieManager.getCookies(url);
            Cookie userId = cookies.singleWhere((c) => c.name == 'User');
            Cookie sessionId = cookies.singleWhere(
              (c) => c.name == 'ASP.NET_SessionId',
            );

            if (userId == null) throw CookieNotFoundException('User');
            if (sessionId == null)
              throw CookieNotFoundException('ASP.NET_SessionId');

            XeduleConfig config = XeduleConfig(
              userId: userId.value,
              sessionId: sessionId.value,
            );

            PeriodProvider periodProvider = context.read<PeriodProvider>();
            XeduleProvider xeduleProvider = context.read<XeduleProvider>();
            xeduleProvider.setConfig(config);

            Navigator.pop(context);

            xeduleProvider.xedule.fetchPeriods().then((periods) {
              periodProvider.setPeriods(periods);
              xeduleProvider.setAuthenticated(true);
            });
          },
        ),
      ),
    );
  }
}
