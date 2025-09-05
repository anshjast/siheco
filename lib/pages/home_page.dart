import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:math';
import 'package:vibration/vibration.dart'; // Import the vibration package

// --- Import the external widgets that will now be used on this page ---
import 'package:project/widgets/user_profile_card.dart';
import 'package:project/widgets/header_section.dart';
import 'package:project/widgets/section_title.dart';
import 'package:project/widgets/daily_tip_card.dart';
import 'package:project/widgets/challenges_widget.dart';
import 'package:project/widgets/quiz_card.dart';
import 'package:project/widgets/daily_eco_points.dart';

// Note: To use vibration, add this to your pubspec.yaml:
// dependencies:
//   vibration: ^1.8.4

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _contentKey = UniqueKey();
  double _currentPoints = 6000;
  final GlobalKey _pointsDisplayKey = GlobalKey();

  final List<Widget> _flyingCoins = [];
  final Random _random = Random();
  bool _isCollectingPoints = false;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _contentKey = UniqueKey();
      });
    }
  }

  void _onPointsCollected(GlobalKey startKey, int points) {
    final startContext = startKey.currentContext;
    final endContext = _pointsDisplayKey.currentContext;

    if (startContext == null || endContext == null || _isCollectingPoints) return;

    setState(() {
      _isCollectingPoints = true;
    });

    final RenderBox startBox = startContext.findRenderObject() as RenderBox;
    final Offset startPosition = startBox.localToGlobal(Offset.zero);

    final RenderBox endBox = endContext.findRenderObject() as RenderBox;
    final Offset endPosition = endBox.localToGlobal(Offset.zero);
    final animationKey = UniqueKey();

    for (int i = 0; i < 10; i++) {
      final flyingCoin = _FlyingCoin(
        key: ValueKey('${animationKey.toString()}_$i'),
        startPosition: startPosition,
        endPosition: endPosition,
        onCompleted: () {
          if (mounted) {
            setState(() {
              _flyingCoins.removeWhere((widget) => widget.key == ValueKey('${animationKey.toString()}_$i'));
            });
          }
        },
        animationDelay: Duration(milliseconds: i * 50 + _random.nextInt(100)),
      );
      if (mounted) {
        setState(() {
          _flyingCoins.add(flyingCoin);
        });
      }
    }

    Future.delayed(const Duration(milliseconds: 750), () async {
      if (mounted) {
        if (await Vibration.hasVibrator() ?? false) {
          int vibrationCount = (points / 10).floor();

          const int maxVibrations = 25;
          if (vibrationCount > maxVibrations) {
            vibrationCount = maxVibrations;
          }

          for (int i = 0; i < vibrationCount; i++) {
            Vibration.vibrate(duration: 20, amplitude: 100);
            await Future.delayed(const Duration(milliseconds: 60));
          }
        }
        setState(() {
          _currentPoints += points;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2100), () {
      if (mounted) {
        setState(() {
          _isCollectingPoints = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // A list of all widgets that will appear below the sticky header.
    final List<Widget> scrollableContent = [
      const SizedBox(height: 20),
      UserProfileCard(currentPoints: _currentPoints),
      const SizedBox(height: 30),
      const SectionTitle(title: 'Daily Eco-Points'),
      const SizedBox(height: 15),
      DailyEcoPoints(
        onPointsCollected: _onPointsCollected,
      ),
      const SizedBox(height: 30),
      const SectionTitle(title: 'My Challenges'),
      const SizedBox(height: 15),
      const MyChallengesList(),
      const SizedBox(height: 30),
      const SectionTitle(title: 'Daily Tip'),
      const SizedBox(height: 15),
      const DailyTipCard(),
      const SizedBox(height: 30),
      const SectionTitle(title: 'Quizzes'),
      const SizedBox(height: 15),
      const QuizzesCard(),
      const SizedBox(height: 30),
      const SectionTitle(title: 'Badges Earned'),
      const SizedBox(height: 15),
      const BadgesList(),
      const SizedBox(height: 30),
      const SectionTitle(title: 'Upcoming Tasks'),
      const SizedBox(height: 15),
      const TasksCard(),
      const SizedBox(height: 120), // Padding for the floating nav bar
    ];

    return SafeArea(
      child: Stack(
        children: [
          LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: const Color(0xFF2E7D32),
            backgroundColor: Colors.white,
            height: 100,
            animSpeedFactor: 2.0,
            showChildOpacityTransition: false,
            // --- Use CustomScrollView to enable sticky headers ---
            child: CustomScrollView(
              key: _contentKey,
              slivers: [
                // --- This makes the HeaderSection sticky ---
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 96.0,
                    maxHeight: 96.0,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      // Apply the original horizontal and vertical padding here to the header
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: HeaderSection(
                        currentPoints: _currentPoints,
                        pointsDisplayKey: _pointsDisplayKey,
                        isCollecting: _isCollectingPoints,
                      ),
                    ),
                  ),
                ),
                // --- The rest of the content scrolls normally ---
                // SliverPadding ensures the scrollable content also has the correct horizontal padding
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return scrollableContent[index];
                      },
                      childCount: scrollableContent.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._flyingCoins,
        ],
      ),
    );
  }
}


// --- Delegate class to manage the sticky header's behavior ---
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// --- Animation Widget for a Single Flying Coin ---
class _FlyingCoin extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onCompleted;
  final Duration animationDelay;

  const _FlyingCoin({
    super.key,
    required this.startPosition,
    required this.endPosition,
    required this.onCompleted,
    this.animationDelay = Duration.zero,
  });

  @override
  _FlyingCoinState createState() => _FlyingCoinState();
}

class _FlyingCoinState extends State<_FlyingCoin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final randomizedStart = Offset(
      widget.startPosition.dx + _random.nextDouble() * 4 - 2,
      widget.startPosition.dy + _random.nextDouble() * 4 - 2,
    );

    _positionAnimation = Tween<Offset>(
      begin: randomizedStart,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: Image.asset('assets/gifs/coin.gif', width: 24, height: 24),
    );
  }
}


// --- MINOR WIDGETS USED ON THE HOME PAGE ---

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
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.description, color: Colors.green.shade700),
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

