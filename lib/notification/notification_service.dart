import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('revolve');

    //InitializationSettings for initializing settings for both the Android platform
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones(); //  <----

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //       builder: (context) => HomeScreen(payload: payload)),
    // );
  }

  Future<void> scheduleNotifications({
    required DateTime time,
    required int id,
    required String notify,
  }) async {
    var androidPlatformSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'revolve',
      sound: RawResourceAndroidNotificationSound('sound'),
      largeIcon: DrawableResourceAndroidBitmap('revolve'),
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Sandbox',
      notify,
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(android: androidPlatformSpecifics),
      payload: 'Notification Payload',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
