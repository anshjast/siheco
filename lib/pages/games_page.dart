import 'package:flutter/material.dart';

// A placeholder for the Games page.
class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Games Page',
          style: TextStyle(fontSize: 24, color: Colors.black54),
        ),
      ),
    );
  }
}
