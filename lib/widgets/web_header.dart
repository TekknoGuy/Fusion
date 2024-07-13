import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const Header({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuPressed,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Header',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle login button press
                print('Login button pressed');
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}