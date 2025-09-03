import 'package:flutter/material.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F4F0),
      body: Center(
        child: Text(
          'Lessons Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}