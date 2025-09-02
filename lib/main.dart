import 'package:flutter/material.dart';
import 'auth/splash_page.dart';
import 'auth/login_page.dart'; // Re-import the login page
import 'pages/home_page.dart';

void main() {
  runApp(const EcoGamesApp());
}

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
      // The app starts with the splash screen.
      home: const SplashScreen(),
      // Define the routes for navigation
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const EcoGamesHomePage(),
      },
    );
  }
}

