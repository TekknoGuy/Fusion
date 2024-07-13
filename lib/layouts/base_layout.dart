import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web_layout.dart';
import 'desktop_layout.dart';
import 'mobile_layout.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (kIsWeb) {
            return const WebLayout();
          } else if (Platform.isAndroid || Platform.isIOS) {
            return const MobileLayout();
          } else {
            return const DesktopLayout();
          }
        }
    );
  }
}
