import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Added for calendar formatting

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _contentKey = UniqueKey();

  // Simulate a refresh action
  Future<void> _handleRefresh() async {
    // Simulate a network request or data reload
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Change the key to force a rebuild of the content
        _contentKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget is now just the content of the page, without a Scaffold.
    // It will be displayed inside the AppShell's Scaffold.
    return SafeArea(
      child: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: const Color(0xFF2E7D32), // Dark green color for refresh indicator
        backgroundColor: Colors.white,
        height: 100,
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        child: ListView(
          key: _contentKey,
          // Added more bottom padding to ensure content is well above the floating nav bar
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
          children: const [
            HeaderSection(),
            SizedBox(height: 20),
            UserProfileCard(),
            SizedBox(height: 30),
            SectionTitle(title: 'My Challenges'), // Updated Title
            SizedBox(height: 15),
            MyChallengesList(), // Updated Widget
            SizedBox(height: 30),
            SectionTitle(title: 'Daily Eco-Tip'),
            SizedBox(height: 15),
            DailyTipCard(),
            SizedBox(height: 30),
            SectionTitle(title: 'Quizzes'),
            SizedBox(height: 15),
            QuizzesCard(),
            SizedBox(height: 30),
            SectionTitle(title: 'Badges Earned'),
            SizedBox(height: 15),
            BadgesList(),
            SizedBox(height: 30),
            SectionTitle(title: 'Upcoming Tasks'),
            SizedBox(height: 15),
            TasksCard(),
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS USED ON THE HOME PAGE ---

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'Alex Green!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32), // Dark green
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        // Updated Row to include Calendar Icon
        Row(
          children: [
            // Button to show the calendar dialog
            IconButton(
              icon: Icon(Icons.calendar_month_outlined, color: Colors.grey.shade700, size: 28),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CalendarWidget();
                  },
                );
              },
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green.shade100,
              child: const Text('AG', style: TextStyle(fontSize: 24, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }
}

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
  final Map<double, bool> _isPopping = {};

  final double _currentPoints = 6000;
  final double _maxPoints = 8000;

  final Map<double, Widget> thresholds = {
    500: Icon(Icons.star, color: Colors.yellow[600], size: 30),
    2000: Icon(Icons.star, color: Colors.yellow[600], size: 30),
    4000: Icon(Icons.star, color: Colors.yellow[600], size: 30),
    8000: Icon(Icons.emoji_events, color: Colors.yellow[600], size: 30),
  };

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
      final currentProgressPoints = _animation.value * _currentPoints;
      for (final points in thresholds.keys) {
        if (currentProgressPoints >= points &&
            !_vibratedMilestones.contains(points)) {
          Vibration.hasVibrator().then((hasVibrator) {
            if (hasVibrator ?? false) {
              Vibration.vibrate(duration: 100);
            }
          });
          _vibratedMilestones.add(points);

          setState(() => _isPopping[points] = true);

          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() => _isPopping[points] = false);
            }
          });
        }
      }
      if(mounted) setState((){});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
              _buildStatColumn('Rank', '#42', Icons.military_tech_rounded),
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
                child: Container(
                  height: 12,
                  width: (_animation.value * _currentPoints / _maxPoints) * constraints.maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              ...thresholds.entries.map((entry) {
                final points = entry.key;
                final widget = entry.value;
                final position = (points / _maxPoints) * constraints.maxWidth;
                final currentProgressPoints = _animation.value * _currentPoints;
                final isLastBadge = points == _maxPoints;
                final isAchieved = currentProgressPoints >= points;
                final isPopping = _isPopping[points] ?? false;
                const double unachievedSize = 18.0;
                const double achievedSize = 30.0;
                const double peakSize = 50.0;
                final double iconSize = isPopping ? peakSize : (isAchieved ? achievedSize : unachievedSize);

                return Positioned(
                  left: isLastBadge ? position - achievedSize : position - (achievedSize / 2),
                  top: (60 - iconSize) / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack,
                        width: iconSize,
                        height: iconSize,
                        child: widget,
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

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }
}

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
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, size: 90, color: Colors.grey),
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


class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green.shade50,
      child: const ListTile(
        leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
        title: Text('Tip of the Day'),
        subtitle: Text('Turn off lights when you leave a room to save energy!'),
      ),
    );
  }
}

class QuizzesCard extends StatelessWidget {
  const QuizzesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Environmental Science',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Quiz 1: Ecosystems',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Test your knowledge on ecosystems',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Start Quiz', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&q=80',
                width: 100,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BadgesList extends StatelessWidget {
  const BadgesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> badges = [
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.green.shade50,
        child: const Icon(Icons.recycling, size: 30, color: Colors.green),
      ),
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.orange.shade100,
        child: Icon(Icons.grass, size: 30, color: Colors.green.shade700),
      ),
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.water_drop, size: 30, color: Colors.blue.shade700),
      ),
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.red.shade100,
        child: Icon(Icons.wb_sunny, size: 30, color: Colors.amber.shade700),
      ),
    ];

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          return badges[index];
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }
}


class TasksCard extends StatelessWidget {
  const TasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.description, color: Colors.blue.shade700),
        ),
        title: const Text(
          'Research Paper',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Due: '),
              TextSpan(
                text: 'Tomorrow',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- CALENDAR WIDGET (NOW INTEGRATED) ---

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;

  // --- FIX: Updated streak dates to be dynamic ---
  // This now creates a 5-day streak ending today for demonstration.
  final Set<DateTime> _streakDates = {
    DateTime.now(),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().subtract(const Duration(days: 4)),
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
        padding: const EdgeInsets.all(20),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildWeekdays(),
            const SizedBox(height: 10),
            _buildCalendarGrid(),
            const SizedBox(height: 20),
            // --- Added streak counter display ---
            _buildStreakCounter(),
          ],
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
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth + startingWeekday - 1,
      itemBuilder: (context, index) {
        if (index < startingWeekday - 1) {
          return const SizedBox.shrink(); // Empty cells before the 1st day
        }
        final day = index - (startingWeekday - 1); // Adjusted index for correct day
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isToday = DateUtils.isSameDay(date, DateTime.now());
        final isSelected = DateUtils.isSameDay(date, _selectedDate);

        // --- Check if the current date has a streak ---
        final hasStreak = _streakDates.any((d) => DateUtils.isSameDay(d, date));

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            Future.delayed(const Duration(milliseconds: 300), () {
              if(Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
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
                  color: Colors.green.withOpacity(0.4),
                  size: 36,
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : (isToday
                      ? const Color(0xFFB5E0B7)
                      : Colors.transparent), // Made non-streak days transparent
                  borderRadius: BorderRadius.circular(12),
                  // Use a border for non-streak days to maintain the 3D look
                  border: hasStreak || isSelected || isToday
                      ? null
                      : Border.all(color: const Color(0xFFD1D9E6), width: 2),
                  boxShadow: isSelected
                      ? [
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
                  ]
                      : [], // Removed shadow for non-selected days
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
          ]
      ),
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

