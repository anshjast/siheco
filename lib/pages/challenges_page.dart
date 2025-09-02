import 'package:flutter/material.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F4F0),
      body: Center(
        child: Text(
          'Challenges Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}