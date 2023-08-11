import 'package:faro_dart/faro_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faro/flutter_faro.dart';
import 'package:multiplat/core/util/platform_util.dart';
import 'package:multiplat/locator.dart';
import 'package:multiplat/ui/router.dart';

import 'dart:io' as io show Platform;

Future<void> main() async {
  var session = Session();
  session.setAttribute("device_manufacturer",
      (io.Platform.isMacOS || io.Platform.isIOS) ? 'Apple' : 'other');
  session.setAttribute("host_os", io.Platform.operatingSystem);
  session.setAttribute("host_os_version", io.Platform.operatingSystemVersion);
  session.setAttribute("host_name", io.Platform.localHostname);

  await FlutterFaro.init((settings) {
    settings.collectorUrl = Uri.parse("");
    settings.meta = Meta(
      app: App('multiplat', '0.0.1', 'dev'),
      session: session,
    );
  }, appRunner: realMain);
}

void realMain() {
  setupLocator();
  runApp(FaroUserInteractionWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (isCupertino()) {
      return CupertinoApp(
        navigatorObservers: [
          FaroNavigatorObserver(),
        ],
        debugShowCheckedModeBanner: false,
        title: 'multiplat',
        theme: CupertinoThemeData(
          primaryColor: Colors.blueGrey,
        ),
        initialRoute: 'combined',
        onGenerateRoute: MultiPlatRouter.generateRoute,
      );
    }
    return MaterialApp(
      navigatorObservers: [
        FaroNavigatorObserver(),
      ],
      debugShowCheckedModeBanner: false,
      title: 'multiplat',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: 'combined',
      onGenerateRoute: MultiPlatRouter.generateRoute,
    );
  }
}
