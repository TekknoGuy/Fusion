import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double sectionWidth = constraints.maxWidth / 3;

        return SizedBox(
          height: 20,
          child: Row(
            children: [
              // Left TextBox
              SizedBox(
                width: sectionWidth,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Left'),
                ),
              ),
              // Center Text
              SizedBox(
                width: sectionWidth,
                child: const Center(
                  child: Text(
                    'Footer',
                  ),
                ),
              ),
              // Right TextBox
              SizedBox(
                width: sectionWidth,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('Right'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
