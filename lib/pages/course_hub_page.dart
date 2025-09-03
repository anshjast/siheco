import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/quiz_question.dart';
import '../models/final_task.dart';
import 'course_detail_page.dart';
import 'quiz_page.dart';
import 'task_page.dart';

class CourseHubPage extends StatefulWidget {
  final Course course;
  final VoidCallback onCourseComplete;

  const CourseHubPage({
    super.key,
    required this.course,
    required this.onCourseComplete,
  });

  @override
  State<CourseHubPage> createState() => _CourseHubPageState();
}

class _CourseHubPageState extends State<CourseHubPage> {
  bool _isQuizUnlocked = false;
  bool _isTaskUnlocked = false;

  FinalTask _getFinalTaskForCourse() {
    return const FinalTask(
      title: "Set Up Your Segregation System!",
      instructions: "1. Find two containers for your home.\n2. Label one 'Wet Waste' and the other 'Dry Waste'.\n3. Put all your waste into the correct bin for 24 hours.",
      submissionRequirement: "To complete this challenge and earn your rewards, upload a photo of your two labeled bins.",
    );
  }

  List<QuizQuestion> _getQuizQuestionsForCourse() {
    return const [
      QuizQuestion(
        question: "What is the main problem with mixing all waste together in landfills?",
        options: ["It smells bad", "It pollutes soil, water, and air", "It looks ugly"],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: "An old newspaper belongs in which category?",
        options: ["Wet Waste", "Dry Waste", "Hazardous Waste"],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: "What is the superpower of Wet Waste?",
        options: ["It can be recycled", "It can be composted", "It is very strong"],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: "An expired bottle of medicine is an example of...",
        options: ["Wet Waste", "Dry Waste", "Hazardous Waste"],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: "What happens to properly segregated dry waste?",
        options: ["It is burned", "It goes to recycling centers", "It is buried"],
        correctAnswerIndex: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        backgroundColor: const Color(0xFF56ab2f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Lessons Card (No changes) ---
            _buildHubCard(
              icon: Icons.menu_book,
              title: 'Lessons',
              subtitle: 'Start here to learn the basics',
              isLocked: false,
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CourseDetailPage(
                    courseTitle: widget.course.title,
                    onComplete: () {},
                  ),
                ));
                setState(() {
                  _isQuizUnlocked = true;
                });
              },
            ),
            const SizedBox(height: 16),
            // --- Quiz Card (No changes) ---
            _buildHubCard(
              icon: Icons.quiz,
              title: 'Quiz',
              subtitle: 'Test your knowledge',
              isLocked: !_isQuizUnlocked,
              onTap: () async {
                final bool? quizPassed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => QuizPage(
                      courseTitle: widget.course.title,
                      questions: _getQuizQuestionsForCourse(),
                    ),
                  ),
                );
                if (quizPassed == true) {
                  setState(() {
                    _isTaskUnlocked = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quiz Passed! Final Challenge Unlocked.'), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Try again! You need to pass the quiz to continue.'), backgroundColor: Colors.redAccent),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // --- Final Challenge Card (THIS IS THE MAIN CHANGE) ---
            _buildHubCard(
              icon: Icons.camera_alt,
              title: 'Final Challenge',
              subtitle: 'Put your knowledge into action!',
              isLocked: !_isTaskUnlocked,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TaskPage(
                    // We now pass the ENTIRE course object, which includes the
                    // new badge name, icon, XP, and coins.
                    course: widget.course,
                    onTaskComplete: widget.onCourseComplete,
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build cards (No changes)
  Widget _buildHubCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(icon, size: 40, color: isLocked ? Colors.grey : Theme.of(context).primaryColor),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                if (isLocked) const Icon(Icons.lock, color: Colors.grey) else const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

