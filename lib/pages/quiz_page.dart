import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizPage extends StatefulWidget {
  final String courseTitle;
  final List<QuizQuestion> questions;

  const QuizPage({
    super.key,
    required this.courseTitle,
    required this.questions,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;

  void _answerQuestion() {
    // Check if the selected answer is correct
    if (_selectedAnswerIndex == widget.questions[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
    }

    // Move to the next question or show results
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null; // Reset selection for the new question
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    bool passed = _score >= (widget.questions.length * 0.6); // Pass if 60% or more is correct

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(passed ? 'Congratulations!' : 'Keep Trying!'),
        content: Text('You scored $_score out of ${widget.questions.length}.'),
        actions: [
          TextButton(
            onPressed: () {
              // Pop the dialog, then pop the quiz page, returning the pass/fail result.
              Navigator.of(context).pop();
              Navigator.of(context).pop(passed);
            },
            child: Text(passed ? 'Continue' : 'Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseTitle} Quiz'),
        backgroundColor: const Color(0xFF56ab2f),
        automaticallyImplyLeading: false, // Prevents user from going back midway
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${_currentQuestionIndex + 1}/${widget.questions.length}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
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
              onPressed: _selectedAnswerIndex != null ? _answerQuestion : null,
              child: Text(
                _currentQuestionIndex == widget.questions.length - 1 ? 'Submit Answers' : 'Next Question',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
