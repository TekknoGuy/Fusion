import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback onSettingsTapped;

  const ProfileMenu({super.key, required this.onSettingsTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              debugPrint('Settings tapped');
              Navigator.pop(context);                                           // Close the bottom sheet
              onSettingsTapped();                                               // Trigger callback to show settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              debugPrint('Profile tapped');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              debugPrint('Logout tapped');
              Navigator.pop(context);
            },
          ),
          // Add more ListTiles as needed
        ],
      ),
    );
  }
}