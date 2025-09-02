import 'package:flutter/material.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.shade200, width: 1),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.eco_rounded, color: Color(0xFF2E7D32), size: 40),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'Turning off the tap while brushing your teeth can save up to 8 gallons of water per day!',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF388E3C),
                height: 1.5,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

