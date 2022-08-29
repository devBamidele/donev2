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

  static const icon = 'notify';
  static const alarm2 = 'rick';
  static const channelId = '244456';
  static const channelName = 'Done Notifications';
  static const channelDes = 'Channel for Done notification';

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(icon);

    //InitializationSettings for initializing settings for both the Android platform
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    tz.initializeTimeZones(); //  <----

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) {},
    );
  }

  Future<void> scheduleNotifications({
    required DateTime time,
    required int id,
    required String notify,
    required String? heading,
  }) async {
    var androidPlatformSpecifics = const AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDes,
      icon: icon,
      sound: RawResourceAndroidNotificationSound(
        alarm2,
      ),
      largeIcon: DrawableResourceAndroidBitmap(icon),
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'This is a ticker',
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      heading != null ? 'Category: ${heading.toString()}' : '',
      'Task: $notify',
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(android: androidPlatformSpecifics),
      payload: notify,
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
