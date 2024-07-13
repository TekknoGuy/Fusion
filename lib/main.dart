import 'package:flutter/material.dart';
import 'package:fusion/notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';

// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;

import 'theme/app_theme.dart';

// import 'pages/desktop/login_page_desktop.dart';
// import 'pages/mobile/login_page_mobile.dart';

import 'layouts/base_layout.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
        title: 'Flutter Platform Specific Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeNotifier.themeMode,
        // themeMode: ThemeMode.system,

        // home: getHomePage()
        debugShowCheckedModeBanner: false,
        home: const BaseLayout());
  }

// Widget getHomePage() {
//   if (kIsWeb) {
//     return const LoginPageDesktop();
//   } else if(Platform.isAndroid || Platform.isIOS) {
//     return const LoginPageMobile();
//   } else {
//     return const LoginPageDesktop();
//   }
// }
}
