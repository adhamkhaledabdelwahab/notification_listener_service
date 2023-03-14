import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'device_info.dart';
import 'notification_event.dart';

typedef EventCallbackFunc = void Function(NotificationEvent? evt);

class NotificationServicePlugin {
  static final _instance = NotificationServicePlugin._constructor();

  static NotificationServicePlugin get instance => _instance;

  final MethodChannel _onNotificationChannel = const MethodChannel(
      "notifications_listener_service/RUN_DART_BACKGROUND_METHOD");
  final MethodChannel _runNativeForegroundChannel = const MethodChannel(
      "notifications_listener_service/RUN_NATIVE_FOREGROUND_METHOD");
  final String _permissionGrantedMethod = "isNotificationPermissionGranted";
  final String _requestPermissionMethod = "requestNotificationPermission";
  final String _getDeviceInfoMethod = "getDeviceInfo";
  final String _registerNotificationCallback = "registerNotificationCallback";
  final String _channelNameExistsMethod = "isExist";
  final String _stopServiceMethod = "stopService";
  final String _isServiceRunningMethod = "isServiceRunning";
  final String _startServiceMethod = "startService";

  NotificationServicePlugin._constructor();

  static void _printError(String text) {
    debugPrint('\x1B[31m$text\x1B[0m');
  }

  Future<MethodChannel?> _testWhichChannel() async {
    try {
      await _runNativeForegroundChannel.invokeMethod(_channelNameExistsMethod);
      return _runNativeForegroundChannel;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _isPermissionGranted() async {
    return await (await _testWhichChannel())
        ?.invokeMethod(_permissionGrantedMethod) as bool;
  }

  Future<bool> isServicePermissionGranted() async {
    try {
      return await _isPermissionGranted();
    } catch (e) {
      _printError(
        "Fetching Notifications Listener Service Permission State Error: $e",
      );
      return false;
    }
  }

  Future<void> _stopService() async {
    await (await _testWhichChannel())?.invokeMethod(_stopServiceMethod);
  }

  Future<void> stopService() async {
    try {
      await _stopService();
    } catch (e) {
      _printError(
        "Stop service Error: $e",
      );
    }
  }

  Future<void> _startService() async {
    await (await _testWhichChannel())?.invokeMethod(_startServiceMethod);
  }

  Future<void> startService() async {
    try {
      await _startService();
    } catch (e) {
      _printError(
        "Start Service Error: $e",
      );
    }
  }

  Future<bool> _isServiceRunning() async {
    return await (await _testWhichChannel())
        ?.invokeMethod(_isServiceRunningMethod) as bool;
  }

  Future<bool> isServiceRunning() async {
    try {
      return await _isServiceRunning();
    } catch (e) {
      _printError(
        "Is Service Running Error: $e",
      );
      return false;
    }
  }

  Future<void> _requestPermission() async {
    return await (await _testWhichChannel())
        ?.invokeMethod(_requestPermissionMethod);
  }

  Future<void> requestServicePermission() async {
    try {
      return await _requestPermission();
    } catch (e) {
      _printError(
        "Requesting Notifications Listener Service Permission Error: $e",
      );
    }
  }

  Future<void> requestPermissionsIfDenied() async {
    final permissionGranted = await isServicePermissionGranted();
    if (!permissionGranted) {
      await requestServicePermission();
    }
  }

  Future _getDeviceInfo() async {
    return await (await _testWhichChannel())
        ?.invokeMethod(_getDeviceInfoMethod);
  }

  Future<DeviceInfo?> getDeviceInfo() async {
    try {
      final result = await _getDeviceInfo();
      return DeviceInfo.newEvent(result);
    } catch (e) {
      _printError("Fetching Device Info Error: $e");
    }
    return null;
  }

  Future<void> _registerNotificationReceiverCallback(int handler) async {
    return await (await _testWhichChannel())
        ?.invokeMethod(_registerNotificationCallback, handler);
  }

  Future<void> _registerNotificationCallbackHandler(int handler) async {
    try {
      return await _registerNotificationReceiverCallback(handler);
    } catch (e) {
      _printError(
        "Registering Notifications Listener Service Callback Error: $e",
      );
    }
  }

  Future<void> initialize(Function callbackHandler) async {
    CallbackHandle? callbackTest =
        PluginUtilities.getCallbackHandle(callbackHandler);
    if (callbackTest == null) {
      throw Exception(
          "The callbackDispatcher needs to be either a static function or a top level function to be accessible as a Flutter entry point.");
    }
    _registerNotificationCallbackHandler(callbackTest.toRawHandle());
    await requestPermissionsIfDenied();
  }

  void executeNotificationListener(EventCallbackFunc callback) {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    _onNotificationChannel.setMethodCallHandler((call) {
      final result = _onNotificationStateChanges(callback, call);
      return Future.value(result);
    });
  }

  bool _onNotificationStateChanges(
      EventCallbackFunc callback, MethodCall call) {
    try {
      NotificationEvent evt = NotificationEvent.newEvent(call.arguments);
      callback(evt);
      return true;
    } catch (e) {
      _printError('Registering CallBack Handler Error: $e');
      return false;
    }
  }
}
