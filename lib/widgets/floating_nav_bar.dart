import 'package:flutter/material.dart';
import 'dart:ui';

// A reusable floating navigation bar with an expanding "pill" animation.
class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // A helper list to define the navigation items
  static const List<_NavBarItem> _items = [
    _NavBarItem(icon: Icons.home_rounded, label: 'Home'),
    _NavBarItem(icon: Icons.games_rounded, label: 'Games'),
    _NavBarItem(icon: Icons.person_rounded, label: 'Profile'),
    _NavBarItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Reduced horizontal padding to make the bar wider
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0), // Fully rounded ends
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              // Added a mint-green tint to the background
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              // Distribute the items evenly across the wider bar
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final bool isSelected = selectedIndex == index;
                return _buildNavItem(item.icon, item.label, index, isSelected);
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build each individual navigation button.
  Widget _buildNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // The decoration creates the "pill" shape that expands when selected.
        decoration: BoxDecoration(
          // Use a gradient for the selected item for a richer effect
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Colors.green.shade200.withOpacity(0.5),
              Colors.green.shade400.withOpacity(0.5)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF1B5E20) // Darker green for selected icon
                  : Colors.black.withOpacity(0.6),
              size: 24,
            ),
            // The AnimatedSize and ClipRect widgets create the smooth
            // expanding and collapsing effect for the text label.
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              child: ClipRect(
                child: isSelected
                    ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF1B5E20), // Darker green for text
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
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

