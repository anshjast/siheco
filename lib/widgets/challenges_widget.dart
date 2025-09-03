import 'package:flutter/material.dart';

class ChallengesWidget extends StatelessWidget {
  const ChallengesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Data updated with more descriptive and engaging content ---
    final challenges = [
      {
        'icon': 'assets/images/trophy.png', // Replace with your actual file name
        'title': 'Recycle Rush',
        'description': 'Master the art of sorting to give new life to materials.'
      },
      {
        'icon': 'assets/images/trophy.png', // Replace with your actual file name
        'title': 'Water Saver',
        'description': 'Become a hero—every drop counts, from showers to sinks.'
      },
      {
        'icon': 'assets/images/trophy.png', // Replace with your actual file name
        'title': 'Energy Wiz',
        'description': 'Vanquish energy vampires by unplugging unused devices.'
      },
      {
        'icon': 'assets/images/trophy.png', // Replace with your actual file name
        'title': 'Waste Less',
        'description': 'Embrace mindful consumption and choose reusables.'
      },
    ];

    // For the best emboss effect, set your Scaffold's background color
    // to match the card's base color (e.g., Color(0xFFE0E5EC))
    const Color neumorphicBaseColor = Color(0xFFE0E5EC);

    // --- The main widget is now a Column to accommodate a title ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Professional looking section title ---
        SizedBox(
          height: 220, // Reduced height for smaller tiles
          child: PageView.builder(
            controller: PageController(
              viewportFraction: 0.85, // Slightly adjusted for a better look
            ),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Container(
                // Padding between the carousel cards
                margin:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: const EdgeInsets.all(15), // Reduced internal padding
                // --- This decoration creates a softer 3D emboss effect ---
                decoration: BoxDecoration(
                  color: neumorphicBaseColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    // Darker shadow on the bottom right (more subtle)
                    BoxShadow(
                      color: Color(0xFFA3B1C6),
                      offset: Offset(5, 5),
                      blurRadius: 15,
                    ),
                    // Lighter shadow on the top left (more subtle)
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Use Image.asset to display the PNG icon ---
                    Image.asset(
                      challenge['icon'] as String,
                      height: 70, // Reduced image size
                      width: 70, // Reduced image size
                    ),
                    const SizedBox(height: 10), // Adjusted spacing
                    // --- Title with updated styling ---
                    Text(
                      challenge['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18, // Reduced font size
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced spacing for compact text
                    // --- Added description text ---
                    Text(
                      challenge['description'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13, // Reduced font size
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[700],
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

