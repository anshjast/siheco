import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // CRITICAL: No Scaffold here!
    return const SafeArea(
      child: Center(
        child: Text(
          'Profile Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}