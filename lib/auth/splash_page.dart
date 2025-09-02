import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:project/pages/home_page.dart';
import 'login_page.dart'; // CORRECTED: Import the login page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 4500), () {
      if (mounted) {
        // CORRECTED: Navigate to the LoginScreen, not the HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
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
                // CORRECTED: Asset path for gifs
                child: Image.asset('assets/images/sapling.gif'),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
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
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

