import 'package:flutter/material.dart';

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
  if (Hive.box('settings').getAt(0)) {
    localNotifications.periodicNotification(
        sound: true, interval: RepeatInterval.daily);
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
      initialRoute: SettingsView.routeName,
      routes: {
        MainView.routeName: (_) => MainView(),
        SettingsView.routeName: (_) => SettingsView(),
      },
    );
  }
}
