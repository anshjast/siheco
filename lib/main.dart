import 'package:flutter/material.dart';
import 'auth/splash_page.dart';
import 'auth/login_page.dart';
import 'pages/app_shell.dart';

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
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        // Point the '/home' route to the new AppShell
        '/home': (context) => const AppShell(),
      },
    );
  }
}