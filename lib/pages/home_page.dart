import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// Make sure these import paths match your project structure
import '../widgets/daily_tip_card.dart';
import '../widgets/challenges_grid.dart';
import '../widgets/header_section.dart';
import '../widgets/section_title.dart';
import '../widgets/user_profile_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _contentKey = UniqueKey();

  Future<void> _handleRefresh() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _contentKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget returns SafeArea, NOT a Scaffold. This is correct.
    return SafeArea(
      child: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: const Color(0xFF2E7D32),
        backgroundColor: Colors.white,
        height: 100,
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        child: ListView(
          key: _contentKey,
          // Padding at the bottom prevents content from being hidden by the nav bar
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
    );
  }
}