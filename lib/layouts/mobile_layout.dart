import 'package:flutter/material.dart';
import 'package:fusion/models/menu_item.dart';
import 'package:fusion/widgets/mobile/profile_menu.dart';
import 'package:fusion/widgets/mobile/profile_menu_items.dart';
import 'package:fusion/widgets/mobile/main_screen.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  late List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = getMenuItems(() {
      _goToPage(0);
    });
  }

  void _showProfileMenu(BuildContext context) {
    debugPrint('Showing profile menu');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ProfileMenu(
          menuItems: _menuItems,
          onMenuItemSelected: (index) {
            _goToPage(index);
          },
        );
      },
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToPage(int page) {
    setState(() {
      // _pageController.animateToPage(page,
      //     duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _pageController.jumpToPage(page);
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentPage != 0) {
      _goToPage(0);
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
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          // Prevent swipe navigation
          children: [
            const MainScreen(),
            ..._menuItems.map((item) => item.widgetBuilder()),
          ],
        ),
      ),
    );
  }
}
