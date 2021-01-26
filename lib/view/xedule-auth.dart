import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/api/exceptions/cookie-not-found-exception.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/models/xedule/schedule.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/utils/commons.dart';
import 'package:provider/provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XeduleAuth extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const XeduleAuth({Key key, this.onAuthenticated}) : super(key: key);

  @override
  _XeduleAuthState createState() => _XeduleAuthState();
}

class _XeduleAuthState extends State<XeduleAuth> {
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
    return WebView(
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

        String result = await _webViewController.evaluateJavascript(
          'Object.keys(Session.schedules).map(k => Session.schedules[k])',
        );
        final schedulesJson = jsonDecode(result);
        final schedules = schedulesJson
            .map<Schedule>((json) => Schedule.fromJson(json))
            .toList();

        XeduleConfig config = XeduleConfig(
          schedules: schedules,
          userId: userId.value,
          sessionId: sessionId.value,
        );

        XeduleProvider xeduleProvider = context.read<XeduleProvider>();
        xeduleProvider.setConfig(config);
        xeduleProvider.setAuthenticated(true);
        if (widget.onAuthenticated != null) widget.onAuthenticated();
      },
    );
  }
}
