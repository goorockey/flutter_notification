#import "FlutterNotificationPlugin.h"

@implementation FlutterNotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_notification"
            binaryMessenger:[registrar messenger]];
  FlutterNotificationPlugin* instance = [[FlutterNotificationPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"notificationIsOpen" isEqualToString:call.method]) {
    [self checkNotificationOpen:call result: result];
  } else if([@"goNotificationSetting" isEqualToString:call.method]) {
    [self goNotificationSetting:call result: result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)checkNotificationOpen:(FlutterMethodCall*)call result:(FlutterResult)result {
  BOOL isEnable = NO;
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
      UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
      isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
  } else { // iOS版本 <8.0 处理逻辑
      UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
      isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
  }
  result(@(isEnable));
}

- (void)goNotificationSetting:(FlutterMethodCall*)call result:(FlutterResult)result {
  UIApplication *application = [UIApplication sharedApplication];
  NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
  if ([application canOpenURL:url]) {
      if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
          [application openURL:url options:@{} completionHandler:nil];
      } else {
          [application openURL:url];
      }
  }
  result(@(YES));
}

@end
