import 'dart:async';

import 'package:flutter/services.dart';

class FlutterNotification {
  static const MethodChannel _channel =
  const MethodChannel('flutter_notification');

  static Future<bool> notificationIsOpen() async {
    final bool isOpen = await _channel.invokeMethod('notificationIsOpen');
    return isOpen;
  }

  static Future<void> goNotificationSettings() async {
    await _channel.invokeMethod('goNotificationSetting');
  }
}