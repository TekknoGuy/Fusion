import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Layout'),
      ),
      body: const Center(
        child: Text('Mobile Content'),
      ),
    );
  }
}