import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Center(
        child: Text(
          'Footer',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}