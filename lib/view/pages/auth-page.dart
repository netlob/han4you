import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/cookie-not-found-exception.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'file:///C:/Users/idiidk/StudioProjects/han4you/lib/commons.dart';
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

    XeduleProvider xeduleProvider = context.read<XeduleProvider>();

    XeduleConfig config = XeduleConfig(
      endpoint: Commons.xeduleEndpoint,
      userId: userId.value,
      sessionId: sessionId.value,
    );
    xeduleProvider.setConfig(config);
    xeduleProvider.save();

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
              initialUrl: Commons.xeduleSSO,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) async {
                _webViewController = controller;
              },
              onPageFinished: (String url) async {
                if (url.startsWith(Commons.microsoftBase)) {
                  setState(() {
                    _loading = false;
                  });
                } else if (url == Commons.xeduleBase) {
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
