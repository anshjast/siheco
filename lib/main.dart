import 'package:flutter/material.dart';
import 'auth/splash_page.dart';
import 'auth/login_page.dart';
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
      // Define the initial route and the routes table for navigation
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const EcoGamesHomePage(),
      },
    );
  }
}

