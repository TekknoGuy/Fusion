import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fusion/widgets/custom_snackbar.dart';
import 'package:fusion/services/app_state_service.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> {
  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  Future<bool> _login() async {
    final appState = Provider.of<AppStateService>(context, listen: false);
    final result =
        await appState.login(usernameController.text, passwordController.text);

    if (!mounted) {
      return result.success; // Check if the widget is still in the widget tree
    }

    if (appState.isLoggedIn) {
      if (result.message != null) {
        CustomSnackBar.show(context, result.message!);
      }
    } else {
      CustomSnackBar.show(context, result.message ?? 'An error occurred');
    }
    return result.success;
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final appState = Provider.of<AppStateService>(context, listen: false);
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            // shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Fusion Login',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                obscureText: true,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () async {
                    if (await _login()) {
                      appState.setMobileToHome();
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
