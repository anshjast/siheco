import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A data class to hold information about each task
class EcoTask {
  final String title;
  final String subtitle;
  final int points;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  bool isCompleted;

  EcoTask({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.isCompleted = false,
  });
}

// The main widget that holds the list of tasks
class DailyEcoPoints extends StatefulWidget {
  // --- Callback to trigger the animation in the parent (HomePage) ---
  final Function(GlobalKey, int) onPointsCollected;

  const DailyEcoPoints({
    super.key,
    required this.onPointsCollected,
  });

  @override
  State<DailyEcoPoints> createState() => _DailyEcoPointsState();
}

class _DailyEcoPointsState extends State<DailyEcoPoints> {
  // A list of tasks for the user to complete, with a green theme
  final List<EcoTask> _tasks = [
    EcoTask(
        title: 'Plant Two Trees',
        subtitle: 'Completed (1/2)',
        points: 500,
        icon: Icons.park_rounded,
        iconColor: Colors.green.shade800,
        backgroundColor: Colors.green.shade100),
    EcoTask(
        title: 'Recycle Plastics',
        subtitle: 'Recycle 5 plastic bottles',
        points: 25,
        icon: Icons.recycling_rounded,
        iconColor: Colors.teal.shade800,
        backgroundColor: Colors.teal.shade100),
    EcoTask(
        title: 'Conserve Water',
        subtitle: 'Take a 5-minute shower',
        points: 15,
        icon: Icons.water_drop_rounded,
        iconColor: Colors.cyan.shade800,
        backgroundColor: Colors.cyan.shade100),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Compact Header ---
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.eco_rounded, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Daily Goals',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ),
            // --- Task List ---
            Column(
              children: _tasks.map((task) {
                return _EcoTaskItem(
                  task: task,
                  onCollect: (startKey) {
                    if (!task.isCompleted) {
                      widget.onPointsCollected(startKey, task.points);
                      setState(() {
                        task.isCompleted = true;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget for a single compact task item in the list
class _EcoTaskItem extends StatelessWidget {
  final EcoTask task;
  final Function(GlobalKey) onCollect;
  // --- A key to get the position of the icon for the animation ---
  final GlobalKey _iconKey = GlobalKey();

  _EcoTaskItem({required this.task, required this.onCollect});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // This is key for a compact layout
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: task.backgroundColor,
        child: Icon(task.icon, color: task.iconColor, size: 20),
      ),
      title: Text(
        task.title,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        task.subtitle,
        style: GoogleFonts.nunito(
          color: Colors.grey.shade600,
          fontSize: 13,
        ),
      ),
      trailing: ActionChip(
        avatar: task.isCompleted
            ? Icon(Icons.check_rounded, color: Colors.green.shade700, size: 18)
        // --- Changed back to coin.gif ---
            : Image.asset(
          'assets/gifs/coin.gif',
          key: _iconKey,
          width: 18,
          height: 18,
        ),
        label: Text(
          task.isCompleted ? 'Done' : '${task.points}',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: task.isCompleted ? Colors.green.shade900 : Colors.orange.shade900,
            fontSize: 13,
          ),
        ),
        backgroundColor: task.isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
        onPressed: task.isCompleted ? () {} : () => onCollect(_iconKey),
        shape: const StadiumBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces chip padding
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      ),
    );
  }
}