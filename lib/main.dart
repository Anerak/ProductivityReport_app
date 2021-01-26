import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:progress_tracker/src/models/Report.dart';

import 'package:progress_tracker/src/views/main_view.dart';
import 'package:progress_tracker/src/views/settings_view.dart';

import 'package:progress_tracker/src/utils/notifications.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ReportAdapter());
  await Hive.openBox('settings');
  tz.initializeTimeZones();
  LocalNotifications localNotifications = LocalNotifications.localNotifications;
  localNotifications.initNotificationsService(androidIconFile: 'ic_launcher');
  if (Hive.box('settings').get('notif_on', defaultValue: false)) {
    final List<PendingNotificationRequest> pending =
        await localNotifications.pendingNotifications();
    if (pending.length < 2) {
      localNotifications.scheduleMultiple(
          amount: 10, time: Hive.box('settings').get('custom_time'));
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productivity Report',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MainView.routeName,
      routes: {
        MainView.routeName: (_) => MainView(),
        SettingsView.routeName: (_) => SettingsView(),
      },
    );
  }
}
