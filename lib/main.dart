import 'package:flutter/material.dart';
import 'auth/splash_page.dart'; // Import the new splash page

// The main entry point for the Flutter application.
void main() {
  runApp(const EcoGamesApp());
}

// The root widget of the application.
class EcoGamesApp extends StatelessWidget {
  const EcoGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoGames',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      // The splash screen is now loaded from its own file.
      home: const SplashScreen(),
    );
  }
}

// A placeholder HomeScreen to navigate to after the splash screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoGames Home'),
        backgroundColor: const Color(0xFF56ab2f),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Main App!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

