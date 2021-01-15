import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:progress_tracker/src/utils/notifications.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key key}) : super(key: key);
  static String routeName = 'settings';

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Box _settings;
  LocalNotifications _localNotifications;

  @override
  void initState() {
    loadBox();
    _localNotifications = LocalNotifications.localNotifications;
    super.initState();
  }

  void loadBox() async {
    _settings = await Hive.openBox('settings');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${_settings?.length.toString()} - ${_settings?.getAt(0)}',
                style: TextStyle(fontSize: 25.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Checkbox(
                    value: _settings?.getAt(0) ?? false,
                    tristate: false,
                    onChanged: (value) async {
                      await _settings.putAt(0, value);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(_settings?.getAt(0) == true
                        ? Icons.hourglass_full
                        : Icons.hourglass_empty),
                    onPressed: () async {
                      await _localNotifications.fooBar();
                      setState(() {});
                    },
                  ),
                  Switch(
                    value: _settings?.getAt(0) ?? false,
                    onChanged: (bool value) {
                      _settings?.putAt(0, value);
                      if (value) {
                        _localNotifications.periodicNotification(
                            sound: true, interval: RepeatInterval.everyMinute);
                      } else {
                        _localNotifications.cancelNotifications();
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.access_alarms),
                    tooltip: 'Show Notifications List',
                    onPressed: () async {
                      print(await _localNotifications.pendingNotifications());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.alarm_off),
                    tooltip: 'Cancel Notifications',
                    onPressed: () async {
                      print(await _localNotifications.cancelNotifications());
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.looks_one),
                    tooltip: 'Single Notification',
                    onPressed: () {
                      _localNotifications.simpleNotification();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.lock_clock),
                    tooltip: 'Schedule Notification',
                    onPressed: () {
                      _localNotifications.scheduleNotification(sound: true);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat),
                    tooltip: 'Recurrent Notification',
                    onPressed: () {
                      _localNotifications.periodicNotification(sound: true);
                    },
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
