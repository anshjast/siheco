import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:confetti/confetti.dart'; // Import the confetti package

// Import the reusable widget
import '../widgets/community_card_widget.dart';

// The EcoCommunity class is defined directly in this file.
class EcoCommunity {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls;
  int memberCount;
  bool isJoined;
  final String organisation;
  final String clubName;

  EcoCommunity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.memberCount,
    this.isJoined = false,
    required this.organisation,
    required this.clubName,
  });
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ConfettiController _confettiController; // Controller for confetti

  final GlobalKey _myCommunitiesTabKey = GlobalKey();
  final GlobalKey _discoverTabKey = GlobalKey();
  late Map<String, GlobalKey> _cardKeys;

  final List<EcoCommunity> _communities = [
    EcoCommunity(
      id: 'rangers',
      name: 'Reforestation Rangers',
      description: 'Join us to plant trees and restore local habitats.',
      imageUrls: [
        'https://i.pinimg.com/736x/59/86/7b/59867bc59b9731c1e22a27e688f4a9ba.jpg',
        'https://i.pinimg.com/1200x/d9/60/8f/d9608fdaee47a0fe9050f40f91c3b923.jpg',
        'https://i.pinimg.com/1200x/10/73/bf/1073bfc9948042140c5aa530dce8cd4f.jpg',
      ],
      memberCount: 1824,
      organisation: 'Manipal University Jaipur',
      clubName: 'GreenBit',
    ),
    EcoCommunity(
      id: 'guardians',
      name: 'Ocean Guardians',
      description: 'Dedicated to cleaning beaches and protecting marine life.',
      imageUrls: [
        'https://i.pinimg.com/736x/37/4e/ea/374eea78bea8d4fcfc6507125133295d.jpg',
        'https://i.pinimg.com/736x/61/54/b5/6154b5ca012717a14ca6e13a18b2fa92.jpg',
        'https://i.pinimg.com/1200x/1c/ba/5d/1cba5d01e185c60d86c8cec3fa2a4190.jpg',
      ],
      memberCount: 7841,
      organisation: 'Global Ocean Cleanup',
      clubName: 'Aqua Warriors',
    ),
    EcoCommunity(
      id: 'gardeners',
      name: 'Urban Gardeners Collective',
      description: 'Transforming city spaces into green oases.',
      imageUrls: [
        'https://i.pinimg.com/736x/d4/12/cd/d412cdcc2c0fbd599c0f6d3ccbdf590a.jpg',
        'https://i.pinimg.com/1200x/2b/d9/e6/2bd9e66c4ecc21fd6f204984015ff20a.jpg',
        'https://i.pinimg.com/736x/93/15/07/9315074bf061701c3d6190d63e433617.jpg',
      ],
      memberCount: 459,
      isJoined: true,
      organisation: 'City Parks Dept.',
      clubName: 'Urban Roots',
    ),
    EcoCommunity(
      id: 'warriors',
      name: 'Waste Warriors',
      description: 'Promoting recycling and zero-waste lifestyles.',
      imageUrls: [
        'https://i.pinimg.com/1200x/c1/69/3a/c1693a9f3ed734ed6a7a2f6fc30ecf12.jpg',
        'https://i.pinimg.com/736x/e6/90/3b/e6903b31a15fdd68dc6bb490ae629379.jpg',
        'https://i.pinimg.com/736x/eb/31/2a/eb312ac55c512c1daf895d07cb9bacab.jpg',
      ],
      memberCount: 3201,
      organisation: 'Jaipur Municipal Corp.',
      clubName: 'Eco-Warriors',
    ),
  ];

  final List<String> _reelUrls = [
    'https://www.instagram.com/reel/DKgXXTISRbR/?igsh=ZW5zZnF5ZGIwN3Bj',
    'https://www.instagram.com/reel/DMJ4-xBIESK/?igsh=MWhxc2YyZ3ZyMGx5MQ==',
  ];
  late final List<WebViewController> _controllers;
  late final List<bool> _isLoading;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    _cardKeys = {
      for (var community in _communities) community.id: GlobalKey()
    };

    _isLoading = List.generate(_reelUrls.length, (_) => true);
    _controllers = List.generate(
      _reelUrls.length,
          (index) {
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                if (mounted) setState(() => _isLoading[index] = false);
              },
            ),
          );
        controller.loadRequest(Uri.parse(_reelUrls[index]));
        return controller;
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose(); // Dispose the confetti controller
    super.dispose();
  }

  void _animateCard(EcoCommunity community, GlobalKey destinationTabKey, VoidCallback onAnimationEnd) {
    final cardKey = _cardKeys[community.id];
    if (cardKey == null) return;

    final cardBox = cardKey.currentContext?.findRenderObject() as RenderBox?;
    final tabBox = destinationTabKey.currentContext?.findRenderObject() as RenderBox?;

    if (cardBox == null || tabBox == null) return;

    final cardPosition = cardBox.localToGlobal(Offset.zero);
    final tabPosition = tabBox.localToGlobal(Offset.zero);

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 1.0, end: 0.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          onEnd: () {
            onAnimationEnd();
            entry.remove();
          },
          builder: (context, value, child) {
            final position = Offset.lerp(cardPosition, tabPosition, 1 - value)!;
            return Positioned(
              top: position.dy,
              left: position.dx,
              child: Transform.scale(
                scale: value,
                alignment: Alignment.center,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              ),
            );
          },
          child: SizedBox(
            width: cardBox.size.width,
            height: cardBox.size.height,
            child: CommunityCard(
              community: community,
              onSwipe: (_) {},
              cardKey: GlobalKey(),
            ),
          ),
        );
      },
    );
    overlay.insert(entry);
  }

  void _onJoinCommunity(EcoCommunity community) {
    _animateCard(community, _myCommunitiesTabKey, () {
      setState(() {
        community.memberCount++;
        community.isJoined = true;
      });
      _confettiController.play(); // Play confetti
      _showSuccessDialog(community.name);
    });
  }

  void _onLeaveCommunity(EcoCommunity community) {
    _animateCard(community, _discoverTabKey, () {
      setState(() {
        community.memberCount--;
        community.isJoined = false;
      });
    });
  }

  void _showSuccessDialog(String groupName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/gifs/joined_community.gif',
                height: 120,
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are now a part of\n$groupName!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final joined = _communities.where((c) => c.isJoined).toList();
    final discover = _communities.where((c) => !c.isJoined).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(child: _buildCompactHeader()),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildCommunitiesList(joined, onSwipe: _onLeaveCommunity, isJoinedList: true),
                  _buildCommunitiesList(discover, onSwipe: _onJoinCommunity, isJoinedList: false),
                  _buildCreationsTab(),
                ],
              ),
            ),
            // Confetti Widget layer
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple
                ],
                createParticlePath: (size) {
                  double degToRad(double deg) => deg * pi / 180.0;
                  final path = Path();
                  path.addOval(Rect.fromCircle(center: Offset.zero, radius: 10));
                  path.moveTo(0, 0);
                  return path;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Hub',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: [
                Tab(
                    child: Row(
                        key: _myCommunitiesTabKey,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('My Hub')
                        ])),
                Tab(
                    child: Row(
                        key: _discoverTabKey,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.travel_explore_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Discover')
                        ])),
                Tab(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.dynamic_feed_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Creations')
                        ])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitiesList(List<EcoCommunity> communities, {required Function(EcoCommunity) onSwipe, required bool isJoinedList}) {
    if (communities.isEmpty) {
      // If this is the "My Hub" tab and it's empty, show the button.
      if (isJoinedList) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You haven\'t joined any communities yet.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Switch to the "Discover" tab
                    _tabController.animateTo(1);
                  },
                  icon: const Icon(Icons.travel_explore_rounded),
                  label: const Text('Discover Communities'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600)
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Center(
        child: Text(
          'No new communities to discover.',
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 100.0),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return CommunityCard(
          cardKey: _cardKeys[community.id]!,
          community: community,
          onSwipe: onSwipe,
        );
      },
    );
  }

  Widget _buildCreationsTab() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _reelUrls.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[200],
          child: Stack(
            alignment: Alignment.center,
            children: [
              WebViewWidget(controller: _controllers[index]),
              if (_isLoading[index])
                CircularProgressIndicator(color: Colors.green.shade600),
            ],
          ),
        );
      },
    );
  }
}

