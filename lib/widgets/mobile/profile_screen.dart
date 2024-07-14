import 'package:flutter/material.dart';
import 'package:fusion/widgets/login_dialog.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ProfileScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return const LoginDialog();

    // toDo: Depending if the user is logged in or not (has valid tokens) there will be other things to display here.
  }
}
