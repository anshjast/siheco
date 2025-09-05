// main.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // <-- IMPORT THE PACKAGE

// Import your pages
import 'auth/login_page.dart';
import 'auth/signup_page.dart';
import 'pages/app_shell.dart';
import 'auth/splash_page.dart'; // Import the splash screen

// Define the supabase client globally
final supabase = Supabase.instance.client;

Future<void> main() async {
  // --- MODIFICATION FOR NATIVE SPLASH ---
  // This needs to be called to preserve the splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Supabase.initialize(
    url: 'https://luadhoeeywzgydwfegma.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1YWRob2VleXd6Z3lkd2ZlZ21hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5ODMyNjksImV4cCI6MjA3MjU1OTI2OX0.06Uwriwc2P1ae7W0hiTsue5yzC1RrFNPLyrA3wnFDSw',
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );

  // --- REMOVE THE NATIVE SPLASH AFTER INITIALIZATION ---
  FlutterNativeSplash.remove();
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoGames',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      debugShowCheckedModeBanner: false,
      // Your custom splash page will now handle the logic
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/app': (context) => const AppShell(),
      },
    );
  }
}
