import 'package:flutter/material.dart';
import '../models/course.dart';
import 'course_hub_page.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  int userProgressLevel = 0;

  // --- THIS IS THE MAIN CHANGE FOR STEP 2 ---
  // We are updating each course to use the new 'badgeAsset' property
  // with the correct image path.
  final List<Course> courses = const [
    Course(
      id: 'c1',
      title: "The Waste Warrior's Quest",
      description: 'Master the basics of waste segregation.',
      xp: 100,
      coins: 50,
      icon: Icons.recycling,
      color: Colors.green,
      badgeName: 'Waste Warrior',
      badgeAsset: 'assets/images/badge_waste.png', // <-- CHANGED
    ),
    Course(
      id: 'c2',
      title: "The Water Guardian's Vow",
      description: 'Learn to reduce water wastage at home.',
      xp: 120,
      coins: 60,
      icon: Icons.water_drop,
      color: Colors.blue,
      badgeName: 'Water Guardian',
      badgeAsset: 'assets/images/badge_water.png', // <-- CHANGED
    ),
    Course(
      id: 'c3',
      title: 'The Energy Wiz',
      description: 'Vanquish energy vampires by unplugging.',
      xp: 120,
      coins: 60,
      icon: Icons.power_off,
      color: Colors.amber,
      badgeName: 'Energy Wiz',
      badgeAsset: 'assets/images/badge_energy.png', // <-- CHANGED
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Learning Hub'),
        backgroundColor: const Color(0xFF56ab2f),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final bool isLocked = index > userProgressLevel;

          return Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: isLocked
                    ? null
                    : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CourseHubPage(
                        course: course,
                        onCourseComplete: () {
                          setState(() {
                            if (userProgressLevel == index) {
                              userProgressLevel++;
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: course.color.withOpacity(0.15),
                            child:
                            Icon(course.icon, color: course.color, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  course.description,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          if (isLocked)
                            Icon(Icons.lock, color: Colors.grey[700], size: 28),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REWARDS',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '+${course.xp} XP',
                                style: const TextStyle(
                                  color: Color(0xFF56ab2f),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '🪙 +${course.coins}',
                                style: const TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
          );
        },
      ),
    );
  }
}

