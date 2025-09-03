import 'package:flutter/material.dart';

class MyChallengesList extends StatelessWidget {
  const MyChallengesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          ChallengeCard(
            imageUrl: 'https://cdn-icons-png.flaticon.com/512/616/616408.png',
            title: 'Recycling Hero',
            subtitle: 'Learn about recycling',
          ),
          ChallengeCard(
            imageUrl: 'https://cdn-icons-png.flaticon.com/512/427/427735.png',
            title: 'Plant a Tree',
            subtitle: 'Plant a tree in your community',
          ),
          ChallengeCard(
            imageUrl: 'https://cdn-icons-png.flaticon.com/512/686/686589.png',
            title: 'Water Conservation',
            subtitle: 'Reduce water usage daily',
          ),
        ],
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const ChallengeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.eco, size: 90, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
