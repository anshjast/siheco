import 'package:flutter/material.dart';

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
        CircleAvatar(
          radius: 30,
          backgroundImage: const NetworkImage(
              'https://dummyimage.com/360x360/a9dfbe/767676&text=AG'),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle error, maybe show a default icon
          },
        ),
      ],
    );
  }
}

