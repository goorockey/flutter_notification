package com.example.flutter_notification;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.core.app.NotificationManagerCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterNotificationPlugin implements MethodCallHandler {
  private Registrar mRegistrar;

  FlutterNotificationPlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_notification");
    channel.setMethodCallHandler(new FlutterNotificationPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("notificationIsOpen")) {
      checkNotificationOpen(call, result);
    } else if (call.method.equals("goNotificationSetting")){
      goNotificationSetting(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void checkNotificationOpen(MethodCall call, Result result) {
    boolean isOpen = NotificationManagerCompat.from(mRegistrar.activity()).areNotificationsEnabled();
    result.success(isOpen);
  }

  private void goNotificationSetting(MethodCall call, Result result) {
    try {
      Intent intent = new Intent();
      if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        intent.setAction(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
        intent.putExtra(Settings.EXTRA_APP_PACKAGE, mRegistrar.activity().getPackageName());
      } else {
        intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
        intent.putExtra("app_package", mRegistrar.activity().getPackageName());
        intent.putExtra("app_uid", mRegistrar.activity().getApplicationInfo().uid);
      }
      mRegistrar.activity().startActivity(intent);
    } catch (Exception e) {
      e.printStackTrace();

      // 出现异常则跳转到应用设置界面, 如锤子坚果OD103
      Intent intent = new Intent();
      intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
      Uri uri = Uri.fromParts("package", mRegistrar.activity().getPackageName(), null);
      intent.setData(uri);
      mRegistrar.activity().startActivity(intent);
    }
  }
}
