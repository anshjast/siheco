import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Home after the animation
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Updated background color to the requested off-white shade
        color: const Color(0xFFFCFCFC),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the animated GIF
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/sapling.gif'),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 1000), // Adjusted delay
                duration: const Duration(milliseconds: 1500),
                child: Text(
                  'EcoGames Environmaents',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

