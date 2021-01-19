import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:progress_tracker/src/utils/notifications.dart';
import 'package:progress_tracker/src/widgets/drawer.dart';

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

    if (_settings.get('notif_on') == null) {
      _settings.put('notif_on', false);
    }
    if (_settings.get('custom_time') == null) {
      _settings.put('custom_time', [22, 15]);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _settings.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SwitchListTile(
              title: Text('Notifications'),
              subtitle: Text('Reminder to report your day'),
              value: _settings?.get('notif_on') ?? false,
              onChanged: _toggleNotifications,
            ),
            if (_settings != null && _settings.get('notif_on'))
              ListTile(
                leading: Icon(Icons.access_alarm),
                title: Text('Set an hour for the reminder.'),
                trailing: Text(
                  // Believe me when I say this part is horrible
                  // but it works.
                  '${_settings.get('custom_time').first}:${_settings.get('custom_time').last < 10 ? '0' + _settings.get('custom_time').last.toString() : _settings.get('custom_time').last}' ??
                      '',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: (_settings != null && _settings.get('notif_on'))
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                onTap: () async {
                  TimeOfDay _pickerResult = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: TimeOfDay.now().hour,
                        minute: TimeOfDay.now().minute + 3),
                  );

                  if (_pickerResult != null) {
                    List<int> _pickedTime = [
                      _pickerResult.hour,
                      _pickerResult.minute
                    ];

                    if (_settings?.get('custom_time') != _pickedTime) {
                      await _settings?.put('custom_time', _pickedTime);
                      _localNotifications.cancelNotifications();
                      _toggleNotifications(true);
                    }
                    setState(() {});
                  }
                },
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
                    _localNotifications.scheduleNotification(
                        id: 99, sound: true);
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
        )),
      ),
    );
  }

  void _toggleNotifications(bool value) {
    if (_settings?.get('notif_on') == null) {
      _settings?.put('notif_on', value);
    } else {
      _settings?.put('notif_on', value);
    }

    if (value) {
      _localNotifications.scheduleMultiple(
        amount: 10,
        time: _settings.get('custom_time'),
      );
    } else {
      _localNotifications.cancelNotifications();
    }
    setState(() {});
  }
}
