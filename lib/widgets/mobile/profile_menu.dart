import 'package:flutter/material.dart';
import 'package:fusion/services/app_state_service.dart';
import 'package:fusion/widgets/login_dialog.dart';
import 'package:fusion/widgets/mobile/profile_screen.dart';
import 'package:fusion/widgets/mobile/settings_screen.dart';
import 'package:provider/provider.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateService>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile
          // Use Consumer to listen to AppStateService
          Consumer<AppStateService>(
            builder: (context, appState, child) {
              return ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(appState.isLoggedIn ? 'Profile' : 'Login'),
                onTap: () {
                  Navigator.pop(context);
                  if(appState.isLoggedIn) {
                    context.read<AppStateService>().updateMobileWidget(const ProfileScreen());
                  } else {
                    context.read<AppStateService>().updateMobileWidget(const LoginDialog());
                  }
                }
              );
            },
          ),
          // Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the bottom sheet
              context
                  .read<AppStateService>()
                  .updateMobileWidget(const SettingsScreen());
            },
          ),
          // Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context); // Close the bottom sheet
              await appState.logout();
            },
          ),
        ],
      ),
    );
  }
}
