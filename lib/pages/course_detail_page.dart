import 'package:flutter/material.dart';
import 'dart:async';

// --- 1. IMPORT the models from their proper files ---
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/final_task.dart';

// --- 2. THE OLD, DUPLICATE CLASS DEFINITIONS HAVE BEEN REMOVED FROM THIS FILE ---

enum CourseView { lessons, quiz, task }

class CourseDetailPage extends StatefulWidget {
  final String courseTitle;
  final VoidCallback onComplete;

  const CourseDetailPage({
    super.key,
    required this.courseTitle,
    required this.onComplete,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  CourseView _currentView = CourseView.lessons;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  final List<int?> _userAnswers = [];
  int _quizScore = 0;

  // --- Course Content ---
  // This data is now using the imported models.
  final List<Lesson> _lessons = [
    Lesson(
      title: "The Problem with Piles",
      content: "Every day, our cities create mountains of trash called landfills. When all waste is mixed, it pollutes our soil, water, and air. But we have the power to change this!",
      imageAsset: 'assets/images/piles.png',
    ),
    Lesson(
      title: "What is 'Geela Kachra' (Wet Waste)?",
      content: "Think of it as anything that was once alive and is moist. It has a superpower: it can decompose and turn back into healthy soil for plants!",
      imageAsset: 'assets/images/wet_waste.png',
    ),
    Lesson(
      title: "What is 'Sookha Kachra' (Dry Waste)?",
      content: "This is anything man-made and not organic, like paper, plastic, metal, and glass. Its superpower is that it can be recycled into new items!",
      imageAsset: 'assets/images/dry_waste.png',
    ),
    Lesson(
      title: "The Danger Zone (Hazardous Waste)",
      content: "This includes items with harmful chemicals like used batteries, old bulbs, and expired medicines. They must be disposed of separately and with care.",
      imageAsset: 'assets/images/hazardous_waste.png',
    ),
    Lesson(
      title: "The Journey of Your Jars",
      content: "When you segregate, wet waste becomes compost for farms, and dry waste goes to recycling centers to become new products. You're not just throwing away trash, you're creating resources!",
      imageAsset: 'assets/images/dry_waste.png',
    ),
  ];

  final List<QuizQuestion> _quizQuestions = [
    const QuizQuestion(
      question: "What is the main problem with mixing all waste together in landfills?",
      options: ["It smells bad", "It pollutes soil, water, and air", "It looks ugly"],
      correctAnswerIndex: 1,
    ),
    const QuizQuestion(
      question: "An old newspaper belongs in which category?",
      options: ["Wet Waste", "Dry Waste", "Hazardous Waste"],
      correctAnswerIndex: 1,
    ),
    const QuizQuestion(
      question: "What is the superpower of Wet Waste?",
      options: ["It can be recycled", "It can be composted", "It is very strong"],
      correctAnswerIndex: 1,
    ),
    const QuizQuestion(
      question: "An expired bottle of medicine is an example of...",
      options: ["Wet Waste", "Dry Waste", "Hazardous Waste"],
      correctAnswerIndex: 2,
    ),
    const QuizQuestion(
      question: "What happens to properly segregated dry waste?",
      options: ["It is burned", "It goes to recycling centers", "It is buried"],
      correctAnswerIndex: 1,
    ),
  ];

  final FinalTask _finalTask = FinalTask(
    title: "Set Up Your Segregation System!",
    instructions: "1. Find two containers for your home.\n2. Label one 'Wet Waste' and the other 'Dry Waste'.\n3. For the next 24 hours, put all your waste into the correct bin.",
    submissionRequirement: "To complete this challenge and earn your rewards, upload a photo of your two labeled bins.",
  );

  // --- All the methods below are the same as before ---

  @override
  void initState() {
    super.initState();
    _userAnswers.addAll(List.generate(_quizQuestions.length, (index) => null));
  }

  // ... (The rest of your build methods like _buildLessonsView, _buildQuizView, etc., remain exactly the same) ...
  // --- All the methods below are the same as before ---

  Widget _buildLessonsView() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _lessons.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final lesson = _lessons[index];
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(lesson.imageAsset, height: 150),
                    const SizedBox(height: 30),
                    Text(lesson.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Text(lesson.content, style: TextStyle(fontSize: 16, color: Colors.grey[700]), textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_lessons.length, (index) =>
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: _currentPageIndex == index ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color: _currentPageIndex == index ? Colors.green : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: _currentPageIndex == _lessons.length - 1 ? Colors.green : Colors.grey,
            ),
            onPressed: _currentPageIndex == _lessons.length - 1
                ? () => setState(() => _currentView = CourseView.quiz)
                : null,
            child: const Text('Start Quiz', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizView() {
    final question = _quizQuestions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question ${_currentQuestionIndex + 1}/${_quizQuestions.length}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          const SizedBox(height: 8),
          Text(question.question, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...List.generate(question.options.length, (index) =>
              RadioListTile<int>(
                title: Text(question.options[index], style: const TextStyle(fontSize: 18)),
                value: index,
                groupValue: _selectedAnswerIndex,
                onChanged: (value) => setState(() => _selectedAnswerIndex = value),
                activeColor: Colors.green,
              ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: _selectedAnswerIndex != null ? Colors.green : Colors.grey,
            ),
            onPressed: _selectedAnswerIndex != null ? _goToNextQuestion : null,
            child: Text(
              _currentQuestionIndex == _quizQuestions.length - 1 ? 'Submit Answers' : 'Next Question',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextQuestion() {
    setState(() {
      _userAnswers[_currentQuestionIndex] = _selectedAnswerIndex;
      _selectedAnswerIndex = null;

      if (_currentQuestionIndex < _quizQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _submitQuiz();
      }
    });
  }

  void _submitQuiz() {
    _quizScore = 0;
    for (int i = 0; i < _quizQuestions.length; i++) {
      if (_userAnswers[i] == _quizQuestions[i].correctAnswerIndex) {
        _quizScore++;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Results'),
        content: Text('You scored $_quizScore out of ${_quizQuestions.length}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_quizScore >= 3) {
                setState(() => _currentView = CourseView.task);
              } else {
                _resetQuiz();
              }
            },
            child: Text(_quizScore >= 3 ? 'Continue to Final Task' : 'Try Again'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswerIndex = null;
      _userAnswers.clear();
      _userAnswers.addAll(List.generate(_quizQuestions.length, (index) => null));
    });
  }

  Widget _buildTaskView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.flag_circle, color: Colors.green, size: 80),
          const SizedBox(height: 24),
          Text(_finalTask.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(_finalTask.instructions, style: TextStyle(fontSize: 16, color: Colors.grey[700]), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text(_finalTask.submissionRequirement, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Complete & Upload Photo', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Great job! Rewards added!'), backgroundColor: Colors.green),
              );
              widget.onComplete();
              Timer(const Duration(seconds: 2), () {
                if(mounted) {
                  Navigator.of(context).pop();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
        backgroundColor: const Color(0xFF56ab2f),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: switch (_currentView) {
          CourseView.lessons => _buildLessonsView(),
          CourseView.quiz => _buildQuizView(),
          CourseView.task => _buildTaskView(),
        },
      ),
    );
  }
}

