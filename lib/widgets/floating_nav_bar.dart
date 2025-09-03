import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  // A helper list to define the new navigation items
  static const List<_NavBarItem> _items = [
    _NavBarItem(icon: Icons.home_rounded, label: 'Home'),
    _NavBarItem(icon: Icons.menu_book, label: 'Lessons'),
    _NavBarItem(icon: Icons.people_rounded, label: 'Community'),
    _NavBarItem(icon: Icons.leaderboard_rounded, label: 'Leaderboard'),
    _NavBarItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          // This outer Container adds the drop shadow for the 3D effect.
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(_items.length, (index) {
                      final item = _items[index];
                      return _buildBottomNavItem(
                        context,
                        index,
                        item.icon,
                        item.label,
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(
      BuildContext context,
      int index,
      IconData icon,
      String label,
      ) {
    final bool isActive = widget.selectedIndex == index;

    final color = isActive
        ? Colors.green
        : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        // *** FIX: Reduced widths to prevent overflow with five items ***
        width: isActive ? 100 : 50,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.50)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive
              ? [
            // Top-left highlight for the emboss effect
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(-2, -2),
            ),
            // Bottom-right shadow for the emboss effect
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            if (isActive) ...[
              const SizedBox(width: 4),
              Flexible(
                child: AnimatedOpacity(
                  opacity: isActive ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// A simple data class for the navigation items
class _NavBarItem {
  final IconData icon;
  final String label;

  const _NavBarItem({required this.icon, required this.label});
}