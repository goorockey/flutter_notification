import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_notification/flutter_notification.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        checkNotificationOpen();
        break;
      case AppLifecycleState.suspending:
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
            onPressed: ()=> openSetting(),
            child: Text('接受消息开启' + isOpen.toString()),
          )
        ),
      ),
    );
  }

  checkNotificationOpen() async {
    bool result = await FlutterNotification.notificationIsOpen;
    setState(() {
      isOpen = result;
    });
  }

  openSetting() async {
    await FlutterNotification.goNotificationSettings;
  }
}
