import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // for ThemeProvider
import '../auth/login_page.dart';
import '../settings/privacy_center.dart'; // Import privacy page
import '../settings/about_page.dart';     // Import about page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ------------------- HELP -------------------
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement help page
            },
          ),

          // ------------------- PRIVACY CENTER -------------------
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Centre"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyCenterPage()),
              );
            },
          ),

          // ------------------- ACCOUNT STATUS -------------------
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text("Account Status"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement account status page
            },
          ),

          // ------------------- ABOUT -------------------
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),

          const Divider(),

          // ------------------- LANGUAGE -------------------
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Add language picker
            },
          ),

          // ------------------- THEME -------------------
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text("Dark Theme"),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),

          // ------------------- CONTACT US -------------------
          ListTile(
            leading: const Icon(Icons.contact_mail_outlined),
            title: const Text("Contact Us"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement contact page
            },
          ),

          const Divider(),

          // ------------------- LOGOUT -------------------
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

