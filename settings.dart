import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  SettingsGroup({@required this.title, @required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: title,
          ),
          Column(
            children: this.children,
          ),
        ],
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  final String title;

  SettingsTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme
          .of(context)
          .textTheme
          .body2
          .copyWith(color: Colors.blue.shade700),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final GestureTapCallback onTap;

  SettingsItem(this.text, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 10.0,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
