// ignore_for_file: depend_on_referenced_packages

import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications_listener_service/notifications_listener_service.dart';
import 'package:service_example/notification_provider.dart';
import 'package:timezone/timezone.dart' as tz;

NotificationProvider provider = NotificationProvider.instance;
NotificationServicePlugin plugin = NotificationServicePlugin.instance;
final receiver = ReceivePort();
const isolateName = "NotificationListenerService";

final player = AudioPlayer(playerId: "myID");

void onNotificationStateChange() {
  plugin.executeNotificationListener((evt) async {
    debugPrint("$evt");
    if (evt!.state == NotificationState.post) {
      await player.play(
        UrlSource(
          "https://jesusful.com/wp-content/uploads/music/2021/07/Pharrell_Williams_-_Happy_(Naijay.com).mp3",
        ),
      );
      SendPort? sendPort = IsolateNameServer.lookupPortByName(isolateName);
      debugPrint("send port with name $isolateName is $sendPort");
      if (sendPort != null) {
        sendPort.send(evt.packageName);
      }
    } else {
      await player.stop();
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("main function called");
  await plugin.initialize(onNotificationStateChange);
  await provider.init();
  IsolateNameServer.removePortNameMapping(isolateName);
  IsolateNameServer.registerPortWithName(receiver.sendPort, isolateName);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DeviceInfo? info;
  FlutterLocalNotificationsPlugin? notificationsPlugin;
  String? notificationTag;
  AndroidNotificationDetails details = const AndroidNotificationDetails(
    "Basic_Channel_Id",
    "Basic_Channel_Name",
    channelDescription: "Basic_Channel_Description",
    playSound: false,
    priority: Priority.max,
    importance: Importance.max,
  );

  Future<void> update() async {
    notificationsPlugin = await provider.notificationPlugin();
    info = await plugin.getDeviceInfo();
    setState(() {});
  }

  @override
  void initState() {
    update();
    receiver.listen((message) {
      notificationTag = message;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("notification package name: $notificationTag"),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text('Running on: $info\n'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await notificationsPlugin?.show(
                  1,
                  "Title 1",
                  "Body 1",
                  NotificationDetails(
                    android: details,
                  ),
                  payload: "1",
                );
              },
              child: const Text(
                'Show Notification',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await notificationsPlugin?.zonedSchedule(
                  2,
                  "Title 2",
                  "Body 2",
                  tz.TZDateTime.now(tz.local).add(
                    const Duration(seconds: 30),
                  ),
                  NotificationDetails(
                    android: details,
                  ),
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime,
                  matchDateTimeComponents: DateTimeComponents.dateAndTime,
                  androidAllowWhileIdle: true,
                  payload: "2",
                );
              },
              child: const Text(
                'Schedule Notification 30 Seconds',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await notificationsPlugin?.zonedSchedule(
                  3,
                  "Title 3",
                  "Body 3",
                  tz.TZDateTime.now(tz.local).add(
                    const Duration(minutes: 5),
                  ),
                  NotificationDetails(
                    android: details,
                  ),
                  androidAllowWhileIdle: true,
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime,
                  matchDateTimeComponents: DateTimeComponents.dateAndTime,
                  payload: "3",
                );
              },
              child: const Text(
                'Schedule Notification 5 Minutes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
