import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:project/main.dart'; // Import to get the supabase client

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // Wait for a short duration to allow the animation to be visible.
    await Future.delayed(const Duration(seconds: 3));

    // Ensure the widget is still mounted before proceeding.
    if (!mounted) return;

    final session = supabase.auth.currentSession;

    if (session != null) {
      // If there's a session, the user is logged in.
      // Navigate to the main app shell.
      Navigator.of(context).pushReplacementNamed('/app');
    } else {
      // If there's no session, the user needs to log in.
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Before building, make sure you have the 'animate_do' package in your pubspec.yaml
    // Also, ensure you have 'assets/images/sapling.gif' in your project and
    // it is declared in the 'assets' section of your pubspec.yaml
    return Scaffold(
      body: Container(
        color: const Color(0xFFFCFCFC),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/sapling.gif'),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 1500),
                child: Text(
                  'EcoGames',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
