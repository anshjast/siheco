import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final int xp;
  final int coins;
  final IconData icon;
  final Color color;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.xp,
    required this.coins,
    required this.icon,
    required this.color,
  });
}

