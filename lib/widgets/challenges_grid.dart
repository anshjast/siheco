import 'package:flutter/material.dart';

class ChallengesGrid extends StatelessWidget {
  const ChallengesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {'icon': Icons.recycling_rounded, 'title': 'Recycle Rush', 'color': Colors.blue},
      {'icon': Icons.water_drop_rounded, 'title': 'Water Saver', 'color': Colors.lightBlue},
      {'icon': Icons.lightbulb_rounded, 'title': 'Energy Wiz', 'color': Colors.amber},
      {'icon': Icons.shopping_bag_rounded, 'title': 'Waste Less', 'color': Colors.brown},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
      ),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: (challenge['color'] as Color).withOpacity(0.1),
                child: Icon(
                  challenge['icon'] as IconData,
                  size: 32,
                  color: challenge['color'] as Color,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                challenge['title'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

