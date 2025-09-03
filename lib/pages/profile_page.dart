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
    const Color primaryGreen = Color(0xFF518548);
    const Color progressBarBg = Color(0xFFDFF2D8);
    const Color progressBarFill = Color(0xFF4CAF50);
    const Color xpContainerBg = Color(0xFFE3F2DD);

    Widget buildBadge(String label, Color color, IconData iconData) {
      return Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Center(
              child: Icon(iconData, color: color, size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black54,
              size: 28,
            ),
            onPressed: () {
              // ✅ Open SettingsPage without bottom nav
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
              backgroundColor: Colors.white,
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
                const Text(
                  'Olivia Green',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: xpContainerBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.menu_book_outlined, color: Color(0xFFF1B233)),
                  SizedBox(width: 6),
                  Text(
                    '1,250',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'XP Progress',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '750 / 1000',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
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
          const Text(
            'Badges',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.black87,
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
                buildBadge('Water Saver', const Color(0xFF439AAD),
                    Icons.water_drop_outlined),
                const SizedBox(width: 20),
                buildBadge('Recycling Pro', const Color(0xFF3E5A27),
                    Icons.recycling),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'My Sanctuary',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 2,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
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
                    color: const Color(0xFFFFE4D3),
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
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      children: [
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
        unselectedItemColor: const Color(0xFF8FA89B),
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
    const Color cardBackground = Color(0xFFF8FAF3);
    const Color textColor = Color(0xFF26492D);
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
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
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
