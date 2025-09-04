import 'package:flutter/material.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Profile tab selected

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Adjusted colors
    final Color primaryGreen = const Color(0xFF518548);
    final Color progressBarBg =
    isDark ? Colors.grey[800]! : const Color(0xFFDFF2D8);
    final Color progressBarFill = const Color(0xFF4CAF50);
    final Color xpContainerBg =
    isDark ? Colors.green.withOpacity(0.2) : const Color(0xFFE3F2DD);

    Widget buildBadge(String label, Color color, IconData iconData) {
      return Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Center(
              child: Icon(iconData, color: color, size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color,
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: theme.iconTheme.color,
              size: 28,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Profile Image
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor:
              isDark ? Colors.grey[800] : Colors.white, // Dynamic bg
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/profile_avatar.png'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name and title
          Center(
            child: Column(
              children: [
                Text(
                  'Olivia Green',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Eco-Champion - Level 7',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // XP points container
          Center(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: xpContainerBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_outlined,
                      color: Color(0xFFF1B233)),
                  const SizedBox(width: 6),
                  Text(
                    '1,250',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // XP Progress Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: isDark ? 0 : 2,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('XP Progress',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600)),
                      Text(
                        '750 / 1000',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[400] : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 750 / 1000,
                      backgroundColor: progressBarBg,
                      valueColor: AlwaysStoppedAnimation(progressBarFill),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '✨ Next Reward: Level 8 Badge ✨',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Badges',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                buildBadge('Eco-Explorer', const Color(0xFF778869), Icons.eco),
                const SizedBox(width: 20),
                buildBadge(
                    'Water Saver',
                    const Color(0xFF439AAD),
                    Icons.water_drop_outlined),
                const SizedBox(width: 20),
                buildBadge('Recycling Pro', const Color(0xFF3E5A27),
                    Icons.recycling),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'My Sanctuary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: isDark ? 0 : 2,
            color: theme.cardColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/plant_sanctuary.png',
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark
                  ? []
                  : const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.orange.withOpacity(0.2)
                        : const Color(0xFFFFE4D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.local_fire_department_outlined,
                    color: Color(0xFFF5A623),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                      children: const [
                        TextSpan(text: "You’re on a "),
                        TextSpan(
                          text: "3-Day Streak!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF5A623),
                          ),
                        ),
                        TextSpan(text: " Keep it up!"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                title: 'Challenges Done',
                value: '25',
                width: (MediaQuery.of(context).size.width - 60) / 2,
              ),
              _StatCard(
                title: 'Trees Planted',
                value: '5',
                width: (MediaQuery.of(context).size.width - 60) / 2,
              ),
              _StatCard(
                title: 'Waste Recycled',
                value: '150kg',
                width: MediaQuery.of(context).size.width - 40,
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryGreen,
        unselectedItemColor: isDark ? Colors.grey[500] : const Color(0xFF8FA89B),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const _StatCard({
    required this.title,
    required this.value,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBackground =
    isDark ? Colors.grey[900]! : const Color(0xFFF8FAF3);
    final Color textColor =
    isDark ? Colors.white : const Color(0xFF26492D);

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}