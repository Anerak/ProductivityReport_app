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
                  title: Text('Set an hour for the reminder'),
                  trailing: Text(
                    _prettyTime(),
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
                        minute: TimeOfDay.now().minute + 3,
                      ),
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
            ],
          ),
        ),
      ),
    );
  }

  String _prettyTime() {
    String time = '';
    if (_settings.isOpen) {
      List<int> _settingsTime = _settings.get('custom_time');
      time += '${_settingsTime.first}:';
      if (_settingsTime.last < 10) {
        time += '0${_settingsTime.last}';
      } else {
        time += _settingsTime.last.toString();
      }
    }
    return time;
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
