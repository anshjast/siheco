import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:project/widgets/calendar_widget.dart';
import 'package:vibration/vibration.dart';

class UserProfileCard extends StatefulWidget {
  // --- The widget now accepts the current points as a parameter ---
  final double currentPoints;

  const UserProfileCard({super.key, required this.currentPoints});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

// --- 1. Added AutomaticKeepAliveClientMixin to preserve state ---
class _UserProfileCardState extends State<UserProfileCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<UserProfileCard> {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Set<double> _vibratedMilestones = {};
  final Map<double, bool> _isPopping = {};

  // --- The hardcoded points value has been removed from here ---
  final double _maxPoints = 8000;

  final Map<double, String> thresholds = {
    500: 'assets/images/1star.png',
    2000: 'assets/images/2star.png',
    4000: 'assets/images/3star.png',
    8000: 'assets/images/trophy.png',
  };

  // --- 2. Override wantKeepAlive to ensure the widget state is not disposed ---
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation.addListener(() {
      // --- Use widget.currentPoints to calculate progress ---
      final currentProgressPoints = _animation.value * widget.currentPoints;
      for (final points in thresholds.keys) {
        if (currentProgressPoints >= points &&
            !_vibratedMilestones.contains(points)) {
          Vibration.hasVibrator().then((hasVibrator) {
            if (hasVibrator ?? false) {
              Vibration.vibrate(duration: 100);
            }
          });
          _vibratedMilestones.add(points);

          setState(() {
            _isPopping[points] = true;
          });

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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCalendarDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const CalendarWidget();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- 3. Call super.build() as required by the mixin ---
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          const SizedBox(height: 8),
          _buildDateDisplay(context),
          const SizedBox(height: 16),
          _buildAnimatedPointsBar(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                    'Eco-Points',
                    // --- Display the points passed into the widget ---
                    NumberFormat('#,###').format(widget.currentPoints),
                    Icons.star_rounded),
              ),
              Expanded(
                child: _buildStatColumn(
                    'Trees Saved', '12', Icons.forest_rounded),
              ),
              Expanded(
                child:
                _buildStatColumn('Rank', '#42', Icons.emoji_events_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCalendarDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: Colors.white, size: 14),
            const SizedBox(width: 8),
            Text(
              DateFormat('MMMM d, yyyy').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedPointsBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      height: 12,
                      // --- Use widget.currentPoints for the progress bar width ---
                      width: (_animation.value * widget.currentPoints / _maxPoints) *
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
              ...thresholds.entries.map((entry) {
                final points = entry.key;
                final imagePath = entry.value;
                final position = (points / _maxPoints) * constraints.maxWidth;
                // --- Use widget.currentPoints here as well ---
                final currentProgressPoints = _animation.value * widget.currentPoints;
                final isLastBadge = points == _maxPoints;
                final isAchieved = currentProgressPoints >= points;
                final isPopping = _isPopping[points] ?? false;
                const double unachievedSize = 18.0;
                const double achievedSize = 30.0;
                const double peakSize = 50.0;
                final double iconSize = isPopping
                    ? peakSize
                    : (isAchieved ? achievedSize : unachievedSize);

                return Positioned(
                  left: isLastBadge
                      ? position - achievedSize
                      : position - (achievedSize / 2),
                  top: (60 - iconSize) / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
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
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}
