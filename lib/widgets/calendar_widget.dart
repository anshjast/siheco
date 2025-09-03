import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;

  // --- You can easily add or change the streak dates here ---
  // Note: The time of day is ignored, only the date matters.
  final Set<DateTime> _streakDates = {
    DateTime(2025, 8, 29),
    DateTime(2025, 8, 30),
    DateTime(2025, 8, 31),
    DateTime(2025, 9, 1),
    DateTime(2025, 9, 2),
    DateTime(2025, 9, 3),
    DateTime(2025, 9, 4),
  };

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _changeMonth(int months) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + months);
    });
  }

  // --- Calculates the current streak ending today ---
  int _calculateStreak() {
    // To have a streak, today must be marked as a streak day.
    if (!_streakDates.any((d) => DateUtils.isSameDay(d, DateTime.now()))) {
      return 0;
    }

    int streakCount = 0;
    DateTime dateToCheck = DateTime.now();

    // Loop backwards day-by-day and count consecutive days in the streak set.
    while (_streakDates.any((d) => DateUtils.isSameDay(d, dateToCheck))) {
      streakCount++;
      dateToCheck = dateToCheck.subtract(const Duration(days: 1));
    }
    return streakCount;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        // --- Reduced vertical padding for a more compact UI ---
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF0F4F8), Color(0xFFD9E2EC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // --- Added SingleChildScrollView to prevent overflow on smaller screens ---
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 15), // Reduced spacing
              _buildWeekdays(),
              const SizedBox(height: 10),
              _buildCalendarGrid(),
              const SizedBox(height: 15), // Reduced spacing
              _buildStreakCounter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left_rounded,
              size: 30, color: Color(0xFF3D4C5E)),
          onPressed: () => _changeMonth(-1),
        ),
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D4C5E),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right_rounded,
              size: 30, color: Color(0xFF3D4C5E)),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildWeekdays() {
    final weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map((day) => Text(
        day,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF6A788A),
          fontSize: 12,
        ),
      ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
    DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOfMonth =
    DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        // --- Made the cells square for a more compact grid ---
        childAspectRatio: 1.0,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth + startingWeekday - 1,
      itemBuilder: (context, index) {
        if (index < startingWeekday - 1) {
          return const SizedBox.shrink(); // Empty cells before the 1st day
        }
        final day = index - (startingWeekday - 2);
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isToday = DateUtils.isSameDay(date, DateTime.now());
        final isSelected = DateUtils.isSameDay(date, _selectedDate);

        // --- Check if the current date has a streak ---
        final hasStreak =
        _streakDates.any((d) => DateUtils.isSameDay(d, date));

        // --- A streak day is only highlighted if it is also today ---
        final isHighlightedStreak = hasStreak && isToday;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.of(context).pop();
            });
          },
          // --- Use a Stack to layer the icon behind the date ---
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- Show eco icon if date is part of the streak ---
              if (hasStreak && !isSelected)
                Icon(
                  Icons.eco_outlined,
                  // --- Updated: Leaf is now always green if part of a streak ---
                  color: Colors.green.withOpacity(0.5),
                  size: 36,
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : (isHighlightedStreak // Only highlight if it's a streak on today's date
                      ? const Color(0xFFB5E0B7)
                      : Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                  // --- No border for glowing or selected items ---
                  border: (isSelected || hasStreak)
                      ? null
                      : Border.all(
                      color: const Color(0xFFD1D9E6).withOpacity(0.8),
                      width: 1.5),
                  boxShadow: [
                    if (isSelected)
                      ...[
                        const BoxShadow(
                          color: Color(0xFF388E3C),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                        const BoxShadow(
                          color: Color(0xFF66BB6A),
                          offset: Offset(-3, -3),
                          blurRadius: 5,
                        ),
                      ],
                    // --- Add a green glow for the highlighted streak day ---
                    if (isHighlightedStreak && !isSelected)
                      BoxShadow(
                        color: Colors.green.withOpacity(0.6),
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                      )
                  ],
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                      isSelected ? Colors.white : const Color(0xFF3D4C5E),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- New widget to display the streak count ---
  Widget _buildStreakCounter() {
    final streak = _calculateStreak();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFA3B1C6),
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 5,
            ),
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_fire_department_rounded,
              color: streak > 0 ? Colors.orange[600] : Colors.grey, size: 24),
          const SizedBox(width: 8),
          Text(
            '$streak Day Streak',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D4C5E),
            ),
          ),
        ],
      ),
    );
  }
}

