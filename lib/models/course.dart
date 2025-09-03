import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final int xp;
  final int coins;
  final IconData icon;
  final Color color;
  final String badgeName;
  final String badgeAsset;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.xp,
    required this.coins,
    required this.icon,
    required this.color,
    required this.badgeName,
    required this.badgeAsset,
  });
}

