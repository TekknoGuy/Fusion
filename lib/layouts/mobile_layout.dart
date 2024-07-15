import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fusion/services/app_state_service.dart';
import 'package:fusion/widgets/mobile/main_screen.dart';
import 'package:fusion/widgets/mobile/profile_menu.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ProfileMenu();
      },
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final appState =
        Provider.of<AppStateService>(context, listen: false);
    if (appState.currentMobileWidget is! MainScreen) {
      appState.updateMobileWidget(const MainScreen());
      return false; // Prevent app from exiting
    }
    return true; // Allow the app to exit
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateService>(context);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            onPressed: () {
              debugPrint('Add Location Pressed');
            },
          ),
          title: const Center(
            child: Text('Fusion'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outlined),
              color: (appState.isLoggedIn ? Colors.lightGreen : Colors.white),
              onPressed: () {
                _showProfileMenu(context);
              },
            ),
          ],
        ),
        body: Consumer<AppStateService>(
          builder: (context, appState, child) {
            return appState.currentMobileWidget;
          },
        ),
      ),
    );
  }
}
