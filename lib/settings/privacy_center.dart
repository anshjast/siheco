import 'package:flutter/material.dart';

class PrivacyCenterPage extends StatefulWidget {
  const PrivacyCenterPage({super.key});

  @override
  State<PrivacyCenterPage> createState() => _PrivacyCenterPageState();
}

class _PrivacyCenterPageState extends State<PrivacyCenterPage> {
  bool _personalizedAds = true;
  final Color _lightGreen = Colors.green.shade300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Center"),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Your Privacy Rights"),
            const SizedBox(height: 8),
            _buildClickableCard(
              context,
              icon: Icons.description_outlined,
              title: "Privacy Policy",
              subtitle: "Read our full privacy policy.",
              onTap: () {
                // TODO: Navigate to Privacy Policy Page/URL
              },
            ),
            _buildClickableCard(
              context,
              icon: Icons.cookie_outlined,
              title: "Cookie Policy",
              subtitle: "Learn how we use cookies.",
              onTap: () {
                // TODO: Navigate to Cookie Policy Page/URL
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Manage Your Data"),
            const SizedBox(height: 8),
            _buildClickableCard(
              context,
              icon: Icons.download_for_offline_outlined,
              title: "Download Your Data",
              subtitle: "Get a copy of your information.",
              onTap: () {
                // TODO: Implement data download functionality
              },
            ),
            _buildClickableCard(
              context,
              icon: Icons.delete_forever_outlined,
              title: "Delete Your Account",
              subtitle: "Permanently remove your account and data.",
              onTap: () {
                // TODO: Implement account deletion flow
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Ad Settings"),
            const SizedBox(height: 8),
            _buildToggleCard(
              context,
              icon: Icons.campaign_outlined,
              title: "Personalized Ads",
              subtitle: "Allow ads based on your activity.",
              value: _personalizedAds,
              onChanged: (value) {
                setState(() {
                  _personalizedAds = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.privacy_tip,
            size: 40,
            color: _lightGreen,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Privacy Center",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage your privacy settings and control your data.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).textTheme.bodySmall?.color,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildClickableCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: _lightGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: _lightGreen),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required bool value,
        required ValueChanged<bool> onChanged,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: SwitchListTile(
        secondary: Icon(icon, color: _lightGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: _lightGreen,
      ),
    );
  }
}

