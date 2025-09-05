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
  bool isLocked; // <-- ADDED: To handle locked state

  EcoTask({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.isCompleted = false,
    this.isLocked = false, // <-- ADDED: Default to not locked
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

// --- MODIFIED: Added AutomaticKeepAliveClientMixin to preserve state ---
class _DailyEcoPointsState extends State<DailyEcoPoints> with AutomaticKeepAliveClientMixin {
  // A list of tasks for the user to complete, with a green theme
  final List<EcoTask> _tasks = [
    EcoTask(
        title: 'Login to App',
        subtitle: 'Log in for the first time today',
        points: 10,
        icon: Icons.login_rounded,
        iconColor: Colors.blue.shade800,
        backgroundColor: Colors.blue.shade100,
        isCompleted: true),
    EcoTask(
        title: 'Complete a Challenge',
        subtitle: 'Finish any daily challenge',
        points: 50,
        icon: Icons.star_border_rounded,
        iconColor: Colors.amber.shade800,
        backgroundColor: Colors.amber.shade100),
    EcoTask(
        title: 'Complete a Quiz',
        subtitle: 'Test your eco-knowledge',
        points: 25,
        icon: Icons.quiz_outlined,
        iconColor: Colors.purple.shade800,
        backgroundColor: Colors.purple.shade100),
    EcoTask(
        title: 'Upload Your Creation',
        subtitle: 'Share your work with the community',
        points: 100,
        icon: Icons.cloud_upload_outlined,
        iconColor: Colors.green.shade800,
        backgroundColor: Colors.green.shade100,
        isLocked: true), // <-- MODIFIED: This task is locked
    EcoTask(
        title: "Review a Member's Creation",
        subtitle: 'Provide feedback to a peer',
        points: 20,
        icon: Icons.rate_review_outlined,
        iconColor: Colors.pink.shade800,
        backgroundColor: Colors.pink.shade100,
        isLocked: true), // <-- MODIFIED: This task is locked
  ];

  // --- ADDED: Override wantKeepAlive and set to true ---
  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    // --- ADDED: Call super.build to satisfy the mixin requirements ---
    super.build(context);
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
                    if (!task.isCompleted && !task.isLocked) {
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
    Widget avatar;
    Color chipColor;
    Color labelColor;
    VoidCallback? onPressed;

    if (task.isLocked) {
      // --- LOCKED STATE ---
      // Note: Make sure 'assets/images/lock.png' exists in your project.
      avatar = Image.asset('assets/images/lock.png', width: 16, height: 16); // <-- MODIFIED: Removed color filter
      chipColor = Colors.grey.shade200;
      labelColor = Colors.grey.shade700;
      onPressed = null; // Disable the chip
    } else if (task.isCompleted) {
      // --- COMPLETED STATE ---
      avatar = Icon(Icons.check_rounded, color: Colors.green.shade700, size: 18);
      chipColor = Colors.green.shade100;
      labelColor = Colors.green.shade900;
      onPressed = () {}; // Disable but show as complete
    } else {
      // --- COLLECTIBLE STATE ---
      avatar = Image.asset(
        'assets/gifs/coin.gif',
        key: _iconKey,
        width: 18,
        height: 18,
      );
      chipColor = Colors.orange.shade100;
      labelColor = Colors.orange.shade900;
      onPressed = () => onCollect(_iconKey);
    }

    return ListTile(
      dense: true,
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
        avatar: avatar,
        label: Text(
          task.isCompleted ? 'Done' : '${task.points}',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: labelColor,
            fontSize: 13,
          ),
        ),
        backgroundColor: chipColor,
        onPressed: onPressed,
        shape: const StadiumBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      ),
    );
  }
}

