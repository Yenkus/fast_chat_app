import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;
  final double? bottomPadding;
  const MyDrawerTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 25,
        bottom: bottomPadding ?? 0,
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
