import 'package:flutter/material.dart';
import '../widgets/floating_nav_bar.dart';

// Import all of your page widgets
import './home_page.dart';
import './lessons_page.dart';
import './community_page.dart';
import './leaderboard_page.dart';
import './profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  // Removed `const` here because the widgets might not be constant constructors
  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const LessonsPage(),
    // const CommunityPage(),
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages.elementAt(_selectedIndex),
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