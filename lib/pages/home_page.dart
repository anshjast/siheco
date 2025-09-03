import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// --- Import the external widgets that will now be used on this page ---
import 'package:project/widgets/user_profile_card.dart';
import 'package:project/widgets/calendar_widget.dart';
import 'package:project/widgets/header_section.dart';
import 'package:project/widgets/section_title.dart';
import 'package:project/widgets/daily_tip_card.dart';
import 'package:project/widgets/challenges_widget.dart';
import 'package:project/widgets/quiz_card.dart'; // Added import for quiz card

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _contentKey = UniqueKey();

  // Simulate a refresh action
  Future<void> _handleRefresh() async {
    // Simulate a network request or data reload
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Change the key to force a rebuild of the content
        _contentKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget is now just the content of the page, without a Scaffold.
    // It will be displayed inside the AppShell's Scaffold.
    return SafeArea(
      child: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: const Color(0xFF2E7D32), // Dark green color for refresh indicator
        backgroundColor: Colors.white,
        height: 100,
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        child: ListView(
          key: _contentKey,
          // Added more bottom padding to ensure content is well above the floating nav bar
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
          children: const [
            // --- All major sections are now imported from separate files ---
            HeaderSection(),
            SizedBox(height: 20),
            UserProfileCard(),
            SizedBox(height: 30),
            SectionTitle(title: 'My Challenges'),
            SizedBox(height: 15),
            // --- This now uses the imported challenges widget ---
            MyChallengesList(),
            SizedBox(height: 30),
            SectionTitle(title: 'Daily Eco-Tip'),
            SizedBox(height: 15),
            DailyTipCard(),
            SizedBox(height: 30),
            SectionTitle(title: 'Quizzes'),
            SizedBox(height: 15),
            QuizzesCard(),
            SizedBox(height: 30),
            SectionTitle(title: 'Badges Earned'),
            SizedBox(height: 15),
            BadgesList(),
            SizedBox(height: 30),
            SectionTitle(title: 'Upcoming Tasks'),
            SizedBox(height: 15),
            TasksCard(),
          ],
        ),
      ),
    );
  }
}

// --- MINOR WIDGETS USED ON THE HOME PAGE (CAN ALSO BE SEPARATED) ---

class BadgesList extends StatelessWidget {
  const BadgesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> badges = [
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.green.shade50,
        child: const Icon(Icons.recycling, size: 30, color: Colors.green),
      ),
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.orange.shade100,
        child: Icon(Icons.grass, size: 30, color: Colors.green.shade700),
      ),
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.water_drop, size: 30, color: Colors.blue.shade700),
      ),
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.red.shade100,
        child: Icon(Icons.wb_sunny, size: 30, color: Colors.amber.shade700),
      ),
    ];

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          return badges[index];
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }
}

class TasksCard extends StatelessWidget {
  const TasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.description, color: Colors.blue.shade700),
        ),
        title: const Text(
          'Research Paper',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Due: '),
              TextSpan(
                text: 'Tomorrow',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

