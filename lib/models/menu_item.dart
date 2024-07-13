import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final IconData icon;
  final Widget Function() widgetBuilder;

  MenuItem({
    required this.name,
    required this.icon,
    required this.widgetBuilder,
  });
}