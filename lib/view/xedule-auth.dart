import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule-config.dart';
import 'package:han4you/models/xedule/schedule.dart';
import 'package:han4you/providers/xedule/group-provider.dart';
import 'package:han4you/utils/commons.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XeduleAuth extends StatefulWidget {
  @override
  _XeduleAuthState createState() => _XeduleAuthState();
}

class _XeduleAuthState extends State<XeduleAuth> {
  WebViewController _webViewController;
  WebviewCookieManager _webViewCookieManager;

  // This method is run after xedule is initialized with a config.
  void _postAuthHook() {
    context.read<GroupProvider>().fetchGroups(context);
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _webViewCookieManager = WebviewCookieManager();
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

        if (userId == null) throw 'no User found';
        if (sessionId == null) throw 'no ASP.NET_SessionId found';

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

        context.read<XeduleProvider>().setConfig(config);
        _postAuthHook();
      },
    );
  }
}
