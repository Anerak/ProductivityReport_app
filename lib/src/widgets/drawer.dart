import 'package:flutter/material.dart';
import 'package:progress_tracker/src/views/main_view.dart';
import 'package:progress_tracker/src/views/settings_view.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScrollConfiguration(
        behavior: ScrollCustomBehavior(),
        child: ListView(
          children: [
            DrawerHeader(
              // TODO: add image to drawer header.
              //decoration: BoxDecoration(),
              curve: Curves.bounceIn,
              child: Stack(children: <Widget>[
                Positioned(
                  right: -5,
                  top: -5,
                  child: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () => showAboutDialog(
                      context: context,
                      children: <Widget>[
                        Text('Thank you for using this app.'),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text('Productivity Report'),
                ),
              ]),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.timelapse),
              title: Text('Reports'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(MainView.routeName),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(SettingsView.routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollCustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) =>
      child;
}
