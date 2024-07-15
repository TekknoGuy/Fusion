import 'package:flutter/material.dart';
import 'package:fusion/services/app_state_service.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'layouts/base_layout.dart';

void main() async {
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
