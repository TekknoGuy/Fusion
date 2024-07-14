import 'package:flutter/material.dart';
import 'package:fusion/widgets/generic/theme_selector.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const ThemeSelector(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: 'English',
                items: <String>['English', 'Spanish', 'French']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle language change
                },
              ),
            ),
            // Add more settings options here
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            // Handle save settings
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
