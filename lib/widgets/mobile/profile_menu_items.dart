import 'package:flutter/material.dart';
import 'package:fusion/models/menu_item.dart';

// Screens/Widgets Attached to MenuItems
import 'profile_screen.dart';
import 'settings_screen.dart';

List<MenuItem> getMenuItems(VoidCallback onBack) {
  return [
    MenuItem(
      name: 'Profile',
      icon: Icons.account_circle,
      widgetBuilder: () => ProfileScreen(onBack: onBack),
    ),
    MenuItem(
      name: 'Settings',
      icon: Icons.settings,
      widgetBuilder: () => SettingsScreen(onBack: onBack),
    ),
    MenuItem(
      name: 'Logout',
      icon: Icons.logout,
      widgetBuilder: () => const Center(child: Text('Logout Screen')),
    )
  ];
}
