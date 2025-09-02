import 'package:flutter/material.dart';

// A placeholder page for app settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: const Center(
        child: Text(
          'Settings Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
