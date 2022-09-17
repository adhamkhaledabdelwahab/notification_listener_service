// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationProvider {
  static final _instance = NotificationProvider._internal();

  static NotificationProvider get instance => _instance;
  bool isInitialized = false;
  late FlutterLocalNotificationsPlugin _plugin;

  NotificationProvider._internal();

  Future<FlutterLocalNotificationsPlugin> notificationPlugin() async {
    if (!isInitialized) await init();
    return _plugin;
  }

  Future init() async {
    try {
      FlutterLocalNotificationsPlugin plugin =
          FlutterLocalNotificationsPlugin();
      await initializeTimeZone();
      if (Platform.isIOS) {
        await _initializeIOSPermissions(plugin);
      }
      var init = await _initFlutterLocalNotificationPlugin(plugin);
      if (init != null && init == true) {
        _plugin = plugin;
        isInitialized = true;
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<bool?> _initFlutterLocalNotificationPlugin(
      FlutterLocalNotificationsPlugin notificationsPlugin) async {
    return await notificationsPlugin.initialize(
      _getInitializationSettings(),
      onSelectNotification: _selectNotification,
    );
  }

  Future<void> _initializeIOSPermissions(
      FlutterLocalNotificationsPlugin notificationsPlugin) async {
    try {
      var isGained = await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      if (isGained == null || isGained == false) {
        throw Exception("IOS Permission Denied");
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  static Future<void> initializeTimeZone() async {
    try {
      tz.initializeTimeZones();
      final String timeZoneName =
          await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint("$e");
    }
  }

  InitializationSettings _getInitializationSettings() {
    return InitializationSettings(
      iOS: _getIOSInitializationSettings(),
      android: _getAndroidInitializationSettings(),
    );
  }

  IOSInitializationSettings _getIOSInitializationSettings() {
    return IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
  }

  AndroidInitializationSettings _getAndroidInitializationSettings() {
    return const AndroidInitializationSettings('res_notification_app_icon');
  }

  Future<void> _selectNotification(String? payload) async {
    //TODO
  }

  Future _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint('Task $id: $title');
  }
}
