import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../widgets/daily_tip_card.dart';
import '../widgets/challenges_grid.dart';
import '../widgets/header_section.dart';
import '../widgets/section_title.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/floating_nav_bar.dart';
import './profile_page.dart'; // Import the new profile page
import './settings_page.dart'; // Import the new settings page

// The home page now manages the state for the selected navigation item.
class EcoGamesHomePage extends StatefulWidget {
  const EcoGamesHomePage({super.key});

  @override
  State<EcoGamesHomePage> createState() => _EcoGamesHomePageState();
}

class _EcoGamesHomePageState extends State<EcoGamesHomePage> {
  var _contentKey = UniqueKey();
  int _selectedIndex = 0; // State for the selected navigation item

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _contentKey = UniqueKey();
      });
    }
  }

  // This function handles the tap events and navigates to the correct page.
  void _onItemTapped(int index) {
    // Only navigate if a new item is selected
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation to other pages
    switch (index) {
      case 2: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        ).then((_) => setState(() => _selectedIndex = 0)); // Reset index when returning
        break;
      case 3: // Settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        ).then((_) => setState(() => _selectedIndex = 0)); // Reset index when returning
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      // The body is a Stack to layer the content and the navigation bar.
      body: Stack(
        children: [
          SafeArea(
            child: LiquidPullToRefresh(
              onRefresh: _handleRefresh,
              color: const Color(0xFF2E7D32),
              backgroundColor: Colors.white,
              height: 100,
              animSpeedFactor: 2.0,
              showChildOpacityTransition: false,
              child: ListView(
                key: _contentKey,
                // Add padding to the bottom to prevent content from being hidden
                // behind the navigation bar.
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                children: const [
                  HeaderSection(),
                  SizedBox(height: 20),
                  UserProfileCard(),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Weekly Challenges'),
                  SizedBox(height: 15),
                  ChallengesGrid(),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Daily Eco-Tip'),
                  SizedBox(height: 15),
                  DailyTipCard(),
                ],
              ),
            ),
          ),
          // Position the floating navigation bar at the bottom of the screen.
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

