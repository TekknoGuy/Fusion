import 'package:flutter/material.dart';
import 'package:fusion/widgets/mobile/profile_menu.dart';
import 'package:fusion/widgets/mobile/main_screen.dart';
import 'package:fusion/widgets/mobile/settings_screen.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _currentIndex = 0;

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ProfileMenu(onSettingsTapped: () {
          _switchToScreen(1);
          Navigator.pop(context);
        });
      },
    );
  }

  void _switchToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      _switchToScreen(0);
      return false; // Prevents default back button behavior
    }
    return true; // Allows the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
              onPressed: () {
                _showProfileMenu(context);
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const MainScreen(),
            SettingsScreen(onBack: () {
              _switchToScreen(0);
            }),
          ],
        ),
      ),
    );
  }
}
