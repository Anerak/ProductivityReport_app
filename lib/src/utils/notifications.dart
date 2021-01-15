import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show RepeatInterval;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static final LocalNotifications localNotifications = LocalNotifications._();

  static String _id = 'prodreport';

  LocalNotifications._();

  /// Start the Notifications service. Execute only once at top level.
  ///
  /// [androidIconFile] must be a valid image file to use as icon. Must be located at `android/app/src/main/res/drawable/`
  Future<bool> initNotificationsService({
    @required String androidIconFile,
  }) async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(androidIconFile);

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    this._requestPermissions();
    InitializationSettings initSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    return await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// Required for iOS devices
  void _requestPermissions() => _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  /// Returns a list of pending notifications
  ///
  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> fooBar() async {
    final List foo = await this.pendingNotifications();
    for (PendingNotificationRequest i in foo) {
      print('ID: ${i.id} | Title: ${i.title} | Body: ${i.body}');
    }
  }

  /// Deletes all pending notifications
  ///
  /// Returns a `bool` value based if the pending notifications list is empty.
  Future<bool> cancelNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    List<PendingNotificationRequest> ntfs = await this.pendingNotifications();

    if (ntfs.isEmpty) return true;
    return false;
  }

  /// Send a simple notification
  ///
  /// [sound] is a `bool` value. `false` by default.
  void simpleNotification({bool sound = false}) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _id, 'reminder', 'Reminder to report your day',
        priority: Priority.max, importance: Importance.max, playSound: sound);
    IOSNotificationDetails iOSDetails = IOSNotificationDetails();
    NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _flutterLocalNotificationsPlugin.show(0, 'Should be the title',
        'Flutter Simple Notification', platformDetails);
  }

  /// Schedule a notification
  void scheduleNotification({bool sound = false}) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _id,
      'reminder',
      'Reminder to report your day ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1)}',
      category: 'CATEGORY_REMINDER',
      onlyAlertOnce: true,
      playSound: sound,
      priority: Priority.high,
      importance: Importance.high,
    );

    IOSNotificationDetails iOSDetails = IOSNotificationDetails(
      presentSound: sound,
    );

    NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Report your day!',
        'In case you haven\'t reported your day yet.',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 20)),
        platformDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void periodicNotification(
      {bool sound = false,
      RepeatInterval interval = RepeatInterval.daily}) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _id,
      'reminder',
      'Reminder to report your day',
      category: 'CATEGORY_REMINDER',
      playSound: sound,
      priority: Priority.high,
      importance: Importance.high,
    );

    NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Report your day!',
      'Don\'t forget to report your day',
      interval,
      platformDetails,
      androidAllowWhileIdle: true,
    );
  }
}
