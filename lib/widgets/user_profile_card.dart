import 'package:flutter/material.dart';
import 'dart:ui';

// Converted to a StatefulWidget to manage the animation
class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Hardcoded values for demonstration
  final double _currentPoints = 1250;
  final double _maxPoints = 2500;

  @override
  void initState() {
    super.initState();
    // Setup the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // 1.5 second animation
      vsync: this,
    );

    // Create a curved animation for a smoother effect
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation when the widget is first built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'alex.green@ecoworld.com',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          // --- MOVED SECTION: Monthly progress is now at the top ---
          const Text(
            'In September...',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildAnimatedPointsBar(),
          // Added more space after the progress bar for better separation
          const SizedBox(height: 30),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          // --- Original stats are now at the bottom ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Eco-Points', '1,250', Icons.star_rounded),
              _buildStatColumn('Rank', '#42', Icons.emoji_events_rounded),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for the new animated water-flow points bar
  Widget _buildAnimatedPointsBar() {
    final List<double> thresholds = [500, 1000, 2500];

    // Use LayoutBuilder to get the width constraints for positioning
    return LayoutBuilder(
      builder: (context, constraints) {
        // Increased height of the Stack to prevent clipping of the text below stars
        return SizedBox(
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background of the bar
              Positioned(
                top: 8, // Center the bar vertically
                left: 0,
                right: 0,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Animated "water flow" bar
              Positioned(
                top: 8,
                left: 0,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      height: 12,
                      width: (_animation.value * _currentPoints / _maxPoints) *
                          constraints.maxWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Position the achievement star markers
              ...thresholds.map((points) {
                final isAchieved = _currentPoints >= points;
                final position = (points / _maxPoints) * constraints.maxWidth;
                return Positioned(
                  left: position - 12, // Center the icon
                  top: 0,
                  child: Column(
                    children: [
                      Icon(
                        isAchieved ? Icons.star : Icons.star_border,
                        color: isAchieved
                            ? const Color(0xFFFFD700)
                            : Colors.white54,
                        size: 24,
                      ),
                      Text(
                        '${points.toInt()}',
                        style: TextStyle(
                          color: isAchieved ? Colors.white : Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // Helper widget for building the stat columns (Eco-Points, Rank)
  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }
}

