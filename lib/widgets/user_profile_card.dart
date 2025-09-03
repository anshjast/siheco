import 'package:flutter/material.dart';
import 'dart:ui';
// TODO: Add vibration package to pubspec.yaml:
// dependencies:
//   vibration: ^1.8.4
//
// TODO: For vibration on Android, add this line to your
// android/app/src/main/AndroidManifest.xml file, just before the <application> tag:
// <uses-permission android:name="android.permission.VIBRATE"/>
import 'package:vibration/vibration.dart';

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
  final Set<double> _vibratedMilestones = {};
  final Map<double, bool> _isPopping = {}; // New state for pop animation

  // Hardcoded values for demonstration - updated points
  final double _currentPoints = 6000;
  // Updated final point value
  final double _maxPoints = 8000;

  // Map to hold point thresholds and their corresponding asset images
  final Map<double, String> thresholds = {
    500: 'assets/images/1star.png',
    2000: 'assets/images/2star.png',
    4000: 'assets/images/3star.png',
    8000: 'assets/images/trophy.png',
  };

  @override
  void initState() {
    super.initState();
    // Setup the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500), // Slower for effect
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Add a listener to trigger vibrations and the pop animation
    _animation.addListener(() {
      final currentProgressPoints = _animation.value * _currentPoints;
      for (final points in thresholds.keys) {
        if (currentProgressPoints >= points &&
            !_vibratedMilestones.contains(points)) {
          // Check if the device can vibrate before attempting to
          Vibration.hasVibrator().then((hasVibrator) {
            if (hasVibrator ?? false) {
              Vibration.vibrate(duration: 100);
            }
          });
          _vibratedMilestones.add(points);

          // Trigger the start of the pop animation
          setState(() {
            _isPopping[points] = true;
          });

          // After a short duration, shrink the badge to its final size
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _isPopping[points] = false;
              });
            }
          });
        }
      }
    });

    // Start the animation when the widget is first built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 15),
          const Text(
            'In September...',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildAnimatedPointsBar(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Eco-Points', '6,000', Icons.star_rounded),
              _buildStatColumn('Trees Saved', '12', Icons.forest_rounded),
              _buildStatColumn('Rank', '#42', Icons.emoji_events_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPointsBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 60, // Adjusted height for new peak size
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Background of the bar
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Animated "fill" bar
              Align(
                alignment: Alignment.centerLeft,
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
              // Position the achievement badges from the map
              ...thresholds.entries.map((entry) {
                final points = entry.key;
                final imagePath = entry.value;
                final position = (points / _maxPoints) * constraints.maxWidth;
                final currentProgressPoints = _animation.value * _currentPoints;
                final isLastBadge = points == _maxPoints;

                // Determine the milestone's state
                final isAchieved = currentProgressPoints >= points;
                final isPopping = _isPopping[points] ?? false;

                // Define new badge sizes
                const double unachievedSize = 18.0; // Changed initial size
                const double achievedSize = 30.0;
                const double peakSize = 50.0;

                // Determine the target size for the animation
                final double iconSize;
                if (isPopping) {
                  iconSize = peakSize;
                } else if (isAchieved) {
                  iconSize = achievedSize;
                } else {
                  iconSize = unachievedSize;
                }

                return Positioned(
                  // Center the badge based on its final achieved size
                  left: isLastBadge
                      ? position - achievedSize
                      : position - (achievedSize / 2),
                  // Adjust top position to keep badges centered vertically as they resize
                  top: (60 - iconSize) / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic, // Smoother animation curve
                        width: iconSize,
                        height: iconSize,
                        child: Image.asset(imagePath),
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

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

