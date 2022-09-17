# notifications_listener_service

Notifications listener service

## Getting Started

this plugin is only for android devices, it defines notification listener service to enable app to
do a specific action one it receives notification in foreground or background and even if the app is
terminated.

## Setup

only thing can be done is to add the plugin into pubspec.yaml and initialize the plugin in the main
function

## How to use plugin?

```dart
  import 'package:notifications_listener_service/notifications_listener_service.dart';
  
  void callbackFunction() {
    NotificationServicePlugin.instance.executeNotificationListener((notificationEvent) {
      print("received notification info: $notificationEvent");
    });
  }
  
  Future<void> main() async {
    await NotificationServicePlugin.instance.initialize(callbackFunction);
    runApp(MyApp());
  }
```

## Features

  * Getting Device Information 

  ```dart
    Future<DeviceInfo?> fetchingDeviceInfo() async {
      final DeviceInfo? deviceInfo = await NotificationServicePlugin.instance.getDeviceInfo();
    }
  ```
  
  * Check if permission granted or not

  ```dart
    Future<bool> isNotificationPermissionGranted() async {
      final bool isGranted = await NotificationServicePlugin.instance.isServicePermissionGranted();
    }
  ```
  
  * Requesting notification listener service permission

  ```dart
    Future<void> requestNotificationServicePermission() async {
      await NotificationServicePlugin.instance.requestServicePermission();
    }
  ```
  
  * Requesting notification listener service permission if not granted

  ```dart
    Future<void> requestNotificationServicePermissionIfNotGranted() async {
      await NotificationServicePlugin.instance.requestPermissionsIfDenied();
    }
  ```

