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

