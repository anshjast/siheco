import 'package:flutter/material.dart';

// This is the blueprint for your beautiful reward pop-up.
// It's designed to be reusable for any course completion.
class RewardDialog extends StatelessWidget {
  final String title;
  final int xp;
  final int coins;
  final String badgeAsset; // It now correctly expects a String path for the image

  const RewardDialog({
    super.key,
    required this.title,
    required this.xp,
    required this.coins,
    required this.badgeAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make the dialog wrap its content
          children: [
            const Text(
              '🎉 Congratulations! 🎉',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // --- THE MAIN FIX IS HERE ---
            // We now use Image.asset to display your beautiful custom badge
            // from the path you provided in lessons_page.dart.
            Image.asset(badgeAsset, height: 100, width: 100),
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
              onPressed: () => Navigator.of(context).pop(), // Closes the dialog
              child: const Text('Continue', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  // A helper widget to create the styled reward chips.
  Widget _buildRewardChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

