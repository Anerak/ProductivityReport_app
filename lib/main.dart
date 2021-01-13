import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:progress_tracker/src/models/Report.dart';
import 'package:progress_tracker/src/views/main_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ReportAdapter());
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
      initialRoute: 'home',
      routes: {
        MainView.routeName: (_) => MainView(),
      },
    );
  }
}
