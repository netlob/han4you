import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/cookie-not-found-exception.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/providers/facility-provider.dart';
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
  bool _loading = true;
  WebViewController _webViewController;
  WebviewCookieManager _webViewCookieManager;

  Future<List<Cookie>> _getCookies() async {
    return await _webViewCookieManager.getCookies('https://sa-han.xedule.nl/');
  }

  void _doLogin(List<Cookie> cookies) async {
    Cookie userId = cookies.singleWhere((c) => c.name == 'User');
    Cookie sessionId = cookies.singleWhere(
      (c) => c.name == 'ASP.NET_SessionId',
    );

    if (userId == null) throw CookieNotFoundException('User');
    if (sessionId == null) throw CookieNotFoundException('ASP.NET_SessionId');
    await _webViewController.loadUrl("about:blank");

    setState(() {
      _loading = true;
    });

    XeduleConfig config = XeduleConfig(
      userId: userId.value,
      sessionId: sessionId.value,
    );

    XeduleProvider xeduleProvider = context.read<XeduleProvider>();
    xeduleProvider.setConfig(config);
    xeduleProvider.setAuthenticated(true);

    PeriodProvider periodProvider = context.read<PeriodProvider>();
    FacilityProvider facilityProvider = context.read<FacilityProvider>();
    final facilities = await xeduleProvider.xedule.fetchFacilities();
    final periods = await xeduleProvider.xedule.fetchPeriods();

    periodProvider.setPeriods(periods);
    facilityProvider.setFacilities(facilities);

    Navigator.pop(context);
  }

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
    Widget floatingActionButton = _loading
        ? SizedBox.shrink()
        : FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            foregroundColor: Colors.white,
          );

    Widget loader = _loading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SizedBox.shrink();

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: Commons.xeduleSSOUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) async {
                _webViewController = controller;
              },
              onPageFinished: (String url) async {
                if (url.startsWith('https://login.microsoftonline.com/')) {
                  setState(() {
                    _loading = false;
                  });
                } else if (url == 'https://sa-han.xedule.nl/') {
                  List<Cookie> cookies = await _getCookies();
                  _doLogin(cookies);
                }
              },
            ),
            loader,
          ],
        ),
      ),
    );
  }
}
