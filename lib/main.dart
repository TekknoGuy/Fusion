import 'package:flutter/material.dart';
import 'package:fusion/services/app_state_service.dart';
import 'package:fusion/services/auth_service.dart';
import 'package:fusion/services/background_service.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'layouts/base_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeService(); // Initialize the background service

  debugPrint("Attempting token login...");
  var isLoggedIn = await AuthService.refreshAccessToken(); // If it fails, we just stay logged out
  if(isLoggedIn.isErr()) {
    debugPrint('Error: ${isLoggedIn.unwrapErr()}');
  } else {
    debugPrint("Login Successful");
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppStateService()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateService>(
      builder: (context, settings, child) {
        return MaterialApp(
            title: 'Flutter Platform Specific Demo',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            debugShowCheckedModeBanner: false,
            home: const BaseLayout());
      },
    );
  }
}
