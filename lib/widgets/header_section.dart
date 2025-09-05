import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

// Note: To use vibration, add this to your pubspec.yaml:
// dependencies:
//   vibration: ^1.8.4

class HeaderSection extends StatefulWidget {
  final double currentPoints;
  final GlobalKey pointsDisplayKey;
  final bool isCollecting;
  final String fullName;
  final String userName;
  final String? avatarUrl; // <-- ADD THIS LINE

  const HeaderSection({
    super.key,
    required this.currentPoints,
    required this.pointsDisplayKey,
    required this.isCollecting,
    required this.fullName,
    required this.userName,
    this.avatarUrl, // <-- ADD THIS LINE
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

// --- Use TickerProviderStateMixin for multiple AnimationControllers ---
class _HeaderSectionState extends State<HeaderSection>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _countController; // Controller for the number count-up
  late Animation<double> _scaleAnimation;
  late Animation<double> _countAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    // --- Initialize a separate controller for the counting animation ---
    _countController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Longer duration for a smooth count
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    _countAnimation = Tween<double>(
        begin: widget.currentPoints, end: widget.currentPoints)
        .animate(
        CurvedAnimation(parent: _countController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(HeaderSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // --- Control the scale (enlarge/shrink) animation ---
    if (widget.isCollecting && !oldWidget.isCollecting) {
      Vibration.hasVibrator().then((hasVibrator) {
        if (hasVibrator ?? false) {
          Vibration.vibrate(duration: 50, amplitude: 128);
        }
      });
      _scaleController.forward();
    }
    if (!widget.isCollecting && oldWidget.isCollecting) {
      _scaleController.reverse();
    }

    // --- Control the count-up animation independently ---
    if (widget.currentPoints != oldWidget.currentPoints) {
      _countAnimation = Tween<double>(
        begin: oldWidget.currentPoints,
        end: widget.currentPoints,
      ).animate(
          CurvedAnimation(parent: _countController, curve: Curves.easeOut));

      _countController.reset();
      _countController.forward();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _countController.dispose(); // Dispose the new controller
    super.dispose();
  }

  /// Generates initials from a full name.
  String getInitials(String fullName) {
    List<String> names = fullName.trim().split(' ');
    if (names.isEmpty || names.first.isEmpty) {
      return '?'; // Return a placeholder if the name is empty
    }
    String initials = names.first[0];
    if (names.length > 1 && names.last.isNotEmpty) {
      initials += names.last[0];
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar = widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty;
    final initials = getInitials(widget.fullName);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.fullName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Inter',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                '@${widget.userName}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontFamily: 'Inter',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              key: widget.pointsDisplayKey,
              child: _buildPointsDisplay(),
            ),
            const SizedBox(width: 12),
            // --- UPDATED AVATAR LOGIC ---
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green.shade200,
              backgroundImage: hasAvatar ? NetworkImage(widget.avatarUrl!) : null,
              child: !hasAvatar
                  ? Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              )
                  : null, // Display nothing if there is an image
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPointsDisplay() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/gifs/coin.gif', width: 20, height: 20),
            const SizedBox(width: 6),
            // This AnimatedBuilder now uses the independent count animation
            AnimatedBuilder(
              animation: _countAnimation,
              builder: (context, child) {
                return Text(
                  NumberFormat('#,###').format(_countAnimation.value.toInt()),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
