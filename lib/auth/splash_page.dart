import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import '../main.dart'; // Import the supabase client

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
    try {
      // Show the splash for a short duration
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      // Check current session
      final session = supabase.auth.currentSession;

      if (session != null && session.user != null) {
        // User is logged in → fetch profile (optional)
        final profileResponse = await supabase
            .from('profiles')
            .select()
            .eq('id', session.user!.id)
            .maybeSingle();

        if (profileResponse != null) {
          // Profile exists → go to app
          Navigator.of(context).pushReplacementNamed('/app');
        } else {
          // Profile missing → go to login (or handle as needed)
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        // No session → go to login
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      // In case of any error, go to login
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
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
