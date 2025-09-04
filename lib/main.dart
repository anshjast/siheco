import 'package:flutter/material.dart';
import 'auth/splash_page.dart';
import 'auth/login_page.dart';
import 'pages/app_shell.dart';
import 'package:provider/provider.dart';

// ------------------- THEME PROVIDER -------------------
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// ------------------- LIGHT THEME -------------------
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.green,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: Colors.grey[100],
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black,
    textColor: Colors.black,
  ),
);

// ------------------- DARK THEME -------------------
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.green,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: Colors.black,
  cardColor: const Color(0xFF1E1E1E), // Dark grey for cards
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStatePropertyAll(Colors.green),
    trackColor: MaterialStatePropertyAll(Colors.greenAccent),
  ),
);

// ------------------- APP ENTRY -------------------
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const EcoGamesApp(),
    ),
  );
}

class EcoGamesApp extends StatelessWidget {
  const EcoGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'EcoGames',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const AppShell(),
      },
    );
  }
}