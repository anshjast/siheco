import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/header_section.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/section_title.dart';
import '../widgets/challenges_grid.dart';
import '../widgets/daily_tip_card.dart';

class EcoGamesHomePage extends StatelessWidget {
  const EcoGamesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the status bar style to match the app's theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // A light, earthy background
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: const [
            SizedBox(height: 20),
            // -- Header Section --
            HeaderSection(),
            SizedBox(height: 30),
            // -- User Profile Card --
            UserProfileCard(),
            SizedBox(height: 30),
            // -- Eco Challenges Section --
            SectionTitle(title: 'Your Eco-Challenges'),
            SizedBox(height: 20),
            ChallengesGrid(),
            SizedBox(height: 30),
            // -- Daily Tip Section --
            SectionTitle(title: 'Fact of the Day'),
            SizedBox(height: 20),
            DailyTipCard(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

