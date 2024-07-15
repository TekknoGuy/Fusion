import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fusion/models/menu_item.dart';
import 'package:fusion/services/app_state_service.dart';

// Screens/Widgets Attached to MenuItems
import 'profile_screen.dart';
import 'settings_screen.dart';

List<MenuItem> getMenuItems(VoidCallback onBack, BuildContext context) {
  final appState = Provider.of<AppStateService>(context, listen: false);

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
      widgetBuilder: () => Center(
        child: ElevatedButton(
            onPressed: () async {
              await appState.logout();
              Navigator.of(context).pop(); // Close context menu
            },
            child: const Text('Confirm Logout')),
      ),
    )
  ];
}
