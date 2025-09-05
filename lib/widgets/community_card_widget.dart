import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the community page to access the EcoCommunity class definition.
import '../pages/community_page.dart';

class CommunityCard extends StatelessWidget {
  final EcoCommunity community;
  final Function(EcoCommunity) onSwipe;
  final GlobalKey cardKey;

  const CommunityCard({
    super.key,
    required this.community,
    required this.onSwipe,
    required this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: cardKey,
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.3),
        color: community.isJoined ? Colors.green[50] : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NEW: Image Carousel
            if (community.imageUrls.isNotEmpty)
              ImageCarousel(imageUrls: community.imageUrls),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    community.description,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.school_outlined, 'Organised by: ${community.organisation}'),
                  const SizedBox(height: 4),
                  _buildDetailRow(Icons.group_work_outlined, 'Club: ${community.clubName}'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.people_alt_rounded, '${community.memberCount} members'),

                ],
              ),
            ),
            if (community.isJoined)
              SwipeButton(
                text: 'Swipe to Leave',
                onSwiped: () => onSwipe(community),
                backgroundColor: Colors.red.shade400,
                iconColor: Colors.red.shade600,
              )
            else
              SwipeButton(
                text: 'Swipe to Join',
                onSwiped: () => onSwipe(community),
                backgroundColor: Colors.green.shade400,
                iconColor: Colors.green.shade600,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                color: Colors.grey[800],
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// --- NEW IMAGE CAROUSEL WIDGET ---
class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  const ImageCarousel({super.key, required this.imageUrls});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null ? child : const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                },
              );
            },
          ),
          // Page Indicator Dots
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 8.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 8.0,
                    width: _currentPage == index ? 24.0 : 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}


// --- REUSABLE SWIPE BUTTON WIDGET ---
class SwipeButton extends StatefulWidget {
  final String text;
  final VoidCallback onSwiped;
  final Color backgroundColor;
  final Color iconColor;

  const SwipeButton({
    super.key,
    required this.text,
    required this.onSwiped,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragPosition = 0.0;
  bool _isActionTaken = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      setState(() {
        _dragPosition = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isActionTaken) return;
    final buttonWidth = context.size?.width ?? 0;
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, buttonWidth);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isActionTaken) return;
    final buttonWidth = context.size?.width ?? 120;
    if (_dragPosition > buttonWidth * 0.6) {
      setState(() {
        _isActionTaken = true;
      });
      widget.onSwiped();
    } else {
      // Animate back to the start.
      _controller.animateTo(0.0, curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50.0;

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: LayoutBuilder(
          builder: (context, constraints) {
            final double buttonWidth = constraints.maxWidth;
            // Calculate the position based on animation value or drag position.
            final double currentPosition = _controller.isAnimating ? _controller.value * buttonWidth : _dragPosition;

            return Container(
              height: buttonHeight,
              width: buttonWidth,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    widget.text,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Positioned(
                    left: currentPosition.clamp(0.0, buttonWidth - buttonHeight),
                    child: Container(
                      height: buttonHeight,
                      width: buttonHeight,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_forward_ios_rounded, color: widget.iconColor, size: 24),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}

