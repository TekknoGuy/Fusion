import 'package:flutter/material.dart';
import '../widgets/web_nav_bar.dart';
import '../widgets/web_header.dart';
import '../widgets/web_footer.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  _WebLayoutState createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  bool _isNavBarOpen = true;

  void _toggleNavBar() {
    setState(() {
      _isNavBarOpen = !_isNavBarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            onMenuPressed: _toggleNavBar,
          ),
          Expanded(
            child: Row(
              children: [
                if (_isNavBarOpen) const NavBar(),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Text('Web Content'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}