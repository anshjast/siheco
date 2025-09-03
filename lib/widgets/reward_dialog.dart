import 'package:flutter/material.dart';

class RewardDialog extends StatelessWidget {
  final String title;
  final int xp;
  final int coins;
  final IconData badgeIcon;

  const RewardDialog({
    super.key,
    required this.title,
    required this.xp,
    required this.coins,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 Congratulations! 🎉',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Icon(badgeIcon, color: Colors.amber, size: 80),
            const SizedBox(height: 16),
            Text(
              'You are now a\n$title!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'REWARDS EARNED',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRewardChip('+${xp.toString()} XP', Colors.green),
                _buildRewardChip('🪙 +${coins.toString()}', Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF56ab2f),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
