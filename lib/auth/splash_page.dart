import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for the authentication check and a minimum display time to complete.
    final isLoggedIn = await _checkAuthStatus();

    // Ensure the widget is still mounted before navigating.
    if (!mounted) return;

    if (isLoggedIn) {
      // If logged in, go to the main app shell.
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If not logged in, go to the login screen.
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  /// Simulates checking the user's authentication status.
  Future<bool> _checkAuthStatus() async {
    // This is a placeholder for your actual authentication logic.
    // You might check SharedPreferences, a secure token, or Firebase Auth.
    //
    // For this example, we'll wait for 3 seconds to ensure animations play,
    // and we'll return 'false' to simulate a user who needs to log in.
    await Future.delayed(const Duration(seconds: 3));

    // TO-DO: Replace 'false' with your actual login check.
    // For example: return FirebaseAuth.instance.currentUser != null;
    return false;
  }

  @override
  Widget build(BuildContext context) {
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