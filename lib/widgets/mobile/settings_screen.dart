import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.arrow_back),
          title: const Text('Back'),
          onTap: () {
            onBack();
          },
        ),
        // Add more settings options here
        const Center(
          child: Text('Settings Screen'),
        ),
      ],
    );
  }
}
