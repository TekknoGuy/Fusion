import 'package:flutter/material.dart';
import 'package:fusion/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  Future<void> _login() async {
    final bool success = await AuthService.login(usernameController.text, passwordController.text);

    if (!mounted) return; // Check if the widget is still in the widget tree

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Successful')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _login,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0), // Customize the outline color and width
              ),
              child: const Text('Login'),
            ),
          ],
        ));
  }
}
