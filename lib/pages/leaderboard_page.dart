import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F4F0),
      body: Center(
        child: Text(
          'Leaderboard Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}