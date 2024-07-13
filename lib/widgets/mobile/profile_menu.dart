import 'package:flutter/material.dart';
import 'package:fusion/models/menu_item.dart';

class ProfileMenu extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Function(int) onMenuItemSelected;

  const ProfileMenu({
    super.key,
    required this.menuItems,
    required this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: menuItems.asMap().entries.map((entry) {
          int index = entry.key;
          MenuItem item = entry.value;
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.name),
            onTap: () {
              debugPrint('${item.name} option tapped');
              Navigator.pop(context);  // Close the bottom sheet
              Future.delayed(
                  const Duration(milliseconds: 300),
                      () => onMenuItemSelected(index + 1)
              );  // Ensure state update after closing
            },
          );
        }).toList(),
      ),
    );
  }
}