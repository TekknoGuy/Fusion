import 'package:flutter/material.dart';
import 'package:fusion/widgets/login_form.dart';

class LoginPageDesktop extends StatelessWidget {
  const LoginPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const LoginForm(),
    );
  }
}