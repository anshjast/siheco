import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // App details
    const String appName = "EcoGames";
    const String appVersion = "1.0.0";
    const String appDescription =
        "Our app is designed to make environmental education engaging, practical, and fun for students in schools and colleges. We believe that learning about climate change, sustainability, and eco-friendly living should go beyond textbooks and into everyday actions.\n\n"
        "Through gamification, challenges, quizzes, and real-world tasks, we encourage students to adopt green habits, track their progress, and compete in a positive way with peers. The platform connects education with action—helping learners understand how their choices impact the planet and empowering them to make a difference.\n\n"
        "Our mission is to build an eco-conscious generation that not only learns about sustainability but also lives it daily, contributing to a cleaner, greener future.";

    return Scaffold(
      appBar: AppBar(
        title: const Text("About EcoGames"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/app_icon.png', // Make sure you've added this to your assets folder
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 24),

            // App Name
            Text(
              appName,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // App Version
            Text(
              "Version $appVersion",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),

            // App Description
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  appDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Copyright notice
            Text(
              "© 2024 EcoGames. All rights reserved.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

