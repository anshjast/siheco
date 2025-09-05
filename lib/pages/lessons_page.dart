import 'package:flutter/material.dart';
import 'dart:math'; // Import for math operations like pi

// --- Imports for Navigation ---
// Note: Make sure the paths to these files are correct for your project structure.
import 'course_hub_page.dart';
import '../models/course.dart';


// This data model is for the cards displayed on this lessons page.
class Lesson {
  final String title;
  final String subtitle;
  final String icon;
  final String xp;
  final String coins;
  final bool isLocked;

  const Lesson({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.xp,
    required this.coins,
    this.isLocked = false,
  });
}

// This is the main widget for the lessons page, now designed to fit into AppShell.
class LessonsPage extends StatelessWidget {
  const LessonsPage({Key? key}) : super(key: key);

  // Dummy data based on your screenshot
  final List<Lesson> lessons = const [
    Lesson(
      title: "The Waste Warrior's Quest",
      subtitle: 'Master the basics of waste segregation.',
      icon: '♻️', // Using emoji for simplicity
      xp: '',
      coins: '+50',
    ),
    Lesson(
      title: "The Water Guardian's Vow",
      subtitle: 'Learn to reduce water wastage at home.',
      icon: '💧',
      xp: '',
      coins: '+60',
      isLocked: true,
    ),
    Lesson(
      title: "The Energy Wiz",
      subtitle: 'Vanquish energy vampires by unplugging.',
      icon: '⚡️', // This might look different on various devices
      xp: '',
      coins: '+60',
      isLocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Using SafeArea to ensure content isn't obscured by the status bar.
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The 'Learning Hub' title, now part of the page body.
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            child: Text(
              'Learning Hub',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),

          // Expanded ensures the ListView takes up all remaining vertical space.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                // Pass both the lesson data and the index for staggered animations.
                return LessonCard(lesson: lessons[index], index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// A widget for each lesson card, now with a 3D entry animation.
class LessonCard extends StatefulWidget {
  final Lesson lesson;
  final int index;

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.index,
  }) : super(key: key);

  @override
  _LessonCardState createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create a curved animation for a more natural feel.
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Start the animation with a delay based on the card's index.
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Apply a 3D rotation transform based on the animation value.
        // The card will flip up from a -90 degree angle.
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // This creates the perspective effect.
          ..rotateX((1 - _animation.value) * (-pi / 2));

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          // Also fade the card in as it animates.
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16), // Match the Card's border radius
          onTap: () {
            if (!widget.lesson.isLocked) {
              // --- NAVIGATION LOGIC ADDED HERE ---
              // 1. Create a Course object from the lesson data.
              final course = Course(
                id: widget.lesson.title, // Using title as a simple unique ID
                title: widget.lesson.title,
                description: widget.lesson.subtitle,
                badgeName: "Waste Warrior", // Example data
                badgeAsset: 'assets/badges/waste_warrior.png',
                icon: Icons.school, // Corrected: Used IconData instead of a String
                xp: 100, // Example data
                coins: int.tryParse(widget.lesson.coins.replaceAll('+', '')) ?? 50,
                color: Colors.green,
              );

              // 2. Navigate to the CourseHubPage when a card is tapped.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseHubPage(
                    course: course,
                    onCourseComplete: () {
                      // This function is called when the final task is completed.
                      // You can add logic here to unlock the next lesson.
                      print("${course.title} completed!");
                    },
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Opacity(
              opacity: widget.lesson.isLocked ? 0.5 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: widget.lesson.isLocked ? Colors.grey.shade200 : const Color(0xFFE9F5E9),
                        child: Text(
                          widget.lesson.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lesson.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lesson.subtitle,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.lesson.isLocked)
                        const Icon(Icons.lock, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'REWARDS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.lesson.xp,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('🪙', style: TextStyle(fontSize: 16)), // Coin emoji
                          const SizedBox(width: 4),
                          Text(
                            widget.lesson.coins,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

