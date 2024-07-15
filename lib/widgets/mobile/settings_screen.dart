import 'package:flutter/material.dart';
import 'package:fusion/widgets/generic/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
//  final VoidCallback onBack;

  // const SettingsScreen({super.key, required this.onBack});
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.arrow_back),
          title: const Text('Back'),
          onTap: () {
            // onBack();
          },
        ),
        // Add more settings options here
        const ThemeSelector(),
        const Center(
          child: Text('Settings Screen'),
        ),
      ],
    );
  }
}
