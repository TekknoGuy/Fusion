import 'package:flutter/material.dart';
import 'package:fusion/services/app_state_service.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppStateService>(context);

    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        value: settings.themeMode,
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light'),
          ),
        ],
        onChanged: (ThemeMode? newValue) {
          if(newValue != null) {
            settings.setThemeMode(newValue);
          }
        },
      ),
    );
  }
}