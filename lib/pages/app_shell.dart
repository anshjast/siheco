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

  // This list now contains your actual page widgets
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    LessonsPage(),
    CommunityPage(),
    LeaderboardPage(),
    ProfilePage(),
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