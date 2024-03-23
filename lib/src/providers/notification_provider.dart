import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, macOS: null);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('main', 'main',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

  Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Consumption Reminder",
      "Don't forget to log your consumptions today!",
      const NotificationDetails(android: androidNotificationDetails),
    );
  }

  Future<void> scheduleNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('main', 'main',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotificationDaily() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        androidNotificationDetails;
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Consumption Reminder',
      "Don't forget to log your consumptions today!",
      RepeatInterval.daily,
      platformChannelSpecifics,
    );
  }

  Future<void> checkAndShowNotification() async {
    bool conditionMet = true; // Replace with logic to check if condition is met

    if (conditionMet) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Notification Title',
        'Notification Body',
        const NotificationDetails(android: androidNotificationDetails),
      );
    }
  }

  Future<void> initializeNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'main',
      'main',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
