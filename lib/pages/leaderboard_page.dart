import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Leaderboard'),
        ),
        body: const SafeArea(
          child: Column(
            children: [
              SizedBox(height: 8),
              _HeaderCard(),
              SizedBox(height: 12),
              _EcoTabBar(),
              SizedBox(height: 12),
              Expanded(child: _TabViews()),
            ],
          ),
        ),
      ),
    );
  }
}

class _EcoTabBar extends StatelessWidget {
  const _EcoTabBar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(.06)),
        ),
        child: const TabBar(
          indicator: BoxDecoration(),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          tabs: [

            Tab(text: 'This Month'),
            Tab(text: 'All-Time'),
          ],
        ),
      ),
    );
  }
}

class _TabViews extends StatelessWidget {
  const _TabViews();
  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        _LeaderboardList(kind: _BoardKind.allTime),
        _LeaderboardList(kind: _BoardKind.month),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _GlassTile(
        tint: Colors.black.withOpacity(.03),
        borderTint: Colors.black.withOpacity(.06),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'EcoGames Rankings',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: .2,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter coming soon…')),
                );
              },
              icon: const Icon(Icons.tune_rounded, color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}

enum _BoardKind { allTime, month }

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({required this.kind});
  final _BoardKind kind;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final users = _mockUsers(kind)..sort((a, b) => b.points.compareTo(a.points));
    final top = users.take(3).toList();
    final rest = users.skip(3).toList();

    return Stack(
      children: [
        LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: Colors.green,
          backgroundColor: Colors.white,
          showChildOpacityTransition: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: _Podium(top: top),
                ),
              ),
              SliverList.separated(
                itemCount: rest.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final rank = index + 4;
                  final u = rest[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _PlayfulTile(rank: rank, user: u),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),

        // Sticky My Rank pill
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "⭐ My Rank: #6   •   940",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.top});
  final List<UserScore> top;

  @override
  Widget build(BuildContext context) {
    Widget column(UserScore u, int place, double height) {
      final accent = u.accent;
      final crown = place == 1;

      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accent.withOpacity(.25), accent.withOpacity(.12)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withOpacity(.35)),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(.20),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Text(u.initials,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
              if (crown)
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD700)),
                ),
              Text(u.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text("${u.points}",
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              // Animated pillar height
              TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 700 + place * 120),
                curve: Curves.easeOutBack,
                tween: Tween(begin: 0, end: height),
                builder: (context, h, _) => Container(
                  height: h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [accent.withOpacity(.65), accent.withOpacity(.35)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (top.length > 1) column(top[1], 2, 95),
        const SizedBox(width: 8),
        if (top.isNotEmpty) column(top[0], 1, 135),
        const SizedBox(width: 8),
        if (top.length > 2) column(top[2], 3, 80),
      ],
    );
  }
}

class _PlayfulTile extends StatelessWidget {
  const _PlayfulTile({required this.rank, required this.user});
  final int rank;
  final UserScore user;

  @override
  Widget build(BuildContext context) {
    final accent = user.accent;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withOpacity(.18), accent.withOpacity(.10)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(.30)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _RankBadge(rank: rank, accent: accent),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Text(user.initials,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text("${user.points}",
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.accent});
  final int rank;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withOpacity(.30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(.45)),
      ),
      child: Text('$rank',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w800)),
    );
  }
}

class _GlassTile extends StatelessWidget {
  const _GlassTile({required this.child, this.padding, this.tint, this.borderTint});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? tint;
  final Color? borderTint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: padding ?? const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (tint ?? Colors.black.withOpacity(.03)),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: (borderTint ?? Colors.black.withOpacity(.06))),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ===== Data =====
class UserScore {
  UserScore({
    required this.name,
    required this.points,
    required this.accent,
  });
  final String name;
  final int points;
  final Color accent;
  String get initials => name.trim().split(' ').map((e) => e[0]).take(2).join();
}

List<UserScore> _mockUsers(_BoardKind kind) {
  final shift = kind == _BoardKind.month ? 1 : 0;
  const emerald = Color(0xFF4CAF50);
  const leaf = Color(0xFF66BB6A);
  const sea = Color(0xFF81C784);
  const lime = Color(0xFFA5D6A7);
  const mint = Color(0xFFC8E6C9);
  const deep = Color(0xFF2E7D32);

  return [
    UserScore(name: 'Aarav Sharma', points: 1240 + shift * 20, accent: emerald),
    UserScore(name: 'Isha Patel', points: 1170 + shift * 40, accent: deep),
    UserScore(name: 'Kabir Singh', points: 1110 + shift * 10, accent: leaf),
    UserScore(name: 'Meera Nair', points: 990 + shift * 50, accent: mint),
    UserScore(name: 'Rohan Gupta', points: 965 + shift * 25, accent: lime),
    UserScore(name: 'Gitanjali Kumari', points: 940 + shift * 35, accent: sea),
    UserScore(name: 'Tanvi Verma', points: 910 + shift * 18, accent: sea),
    UserScore(name: 'Arjun Mehta', points: 880 + shift * 12, accent: leaf),
    UserScore(name: 'Zara Khan', points: 860 + shift * 22, accent: emerald),
    UserScore(name: 'Yash Raj', points: 830 + shift * 16, accent: mint),
  ];
}
