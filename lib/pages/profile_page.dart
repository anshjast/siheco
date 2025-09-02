import 'package:flutter/material.dart';

// A placeholder page for the user's profile.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: const Center(
        child: Text(
          'Profile Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
