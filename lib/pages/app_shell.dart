import 'package:flutter/material.dart';
import 'package:project/main.dart';
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

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // We add an AppBar here for the logout button
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoGames'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
        ],
      ),
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
