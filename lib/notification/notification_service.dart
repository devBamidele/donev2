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

  Future<void> scheduleNotifications() async {
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
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Sandbox',
      'Sandbox launched a notification successfully',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      platformChannelSpecifics,
      payload: 'Notification Payload',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
