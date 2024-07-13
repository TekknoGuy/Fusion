import 'package:flutter/material.dart';
import 'package:fusion/models/menu_item.dart';
// Screens/Widgets Attached to MenuItems
import 'profile_screen.dart';
import 'settings_screen.dart';

final List<MenuItem> menuItems = [
  MenuItem(
    name: 'Profile',
    icon: Icons.account_circle,
    widgetBuilder: () => ProfileScreen(onBack: () {
      // Implement the onBack behavior here if necessary
    }),
  ),
  MenuItem(
    name: 'Settings',
    icon: Icons.settings,
    widgetBuilder: () => SettingsScreen(onBack: () {
      // Implement the onBack behavior here if necessary
    }),
  ),
  MenuItem(
    name: 'Logout',
    icon: Icons.logout,
    widgetBuilder: () => const Center(child: Text('Logout Screen')),
  ),
];