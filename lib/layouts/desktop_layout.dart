import 'package:flutter/material.dart';
import 'package:fusion/widgets/desktop/settings_dialog.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  void _showSettingsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SettingsDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop Layout'),
        actions: [
          // Add desktop-specific menu items here
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _showSettingsDialog(context);
              }),
        ],
      ),
      body: const Center(
        child: Text('Desktop Content'),
      ),
    );
  }
}
