import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/quiz_item.dart';
import '../../data/repositories/quiz_data.dart';
import '../../data/providers/user_progress_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final List<QuizItem> _questions = QuizData.items;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswerLocked = false;

  void _submitAnswer() {
    setState(() {
      _isAnswerLocked = true;
      // In a real scenario, we check `correctAnswer` but since this is
      // "who knows whom better", any selected answer gives points for participation
      _score += 10;
    });

    ref.read(userProgressProvider.notifier).addScore(10);
    ref.read(userProgressProvider.notifier).recordPlayToday();

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _isAnswerLocked = false;
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardPurple,
        title: const Text('Quiz Complete!'),
        content: Text('You scored $_score Hearts! 💕'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back home
            },
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Couple Quiz'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: AppTheme.cardPurple,
              color: AppTheme.primaryPink,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.cardPurple,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.deepPurple, width: 2),
                ),
                child: Center(
                  child: Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ...question.options.map((option) {
              final isSelected = _selectedOption == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: _isAnswerLocked
                      ? null
                      : () {
                          setState(() {
                            _selectedOption = option;
                          });
                        },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryPink.withValues(alpha: 0.8)
                          : AppTheme.cardPurple,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryPink
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isSelected ? Colors.white : AppTheme.softPink,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedOption == null || _isAnswerLocked)
                  ? null
                  : _submitAnswer,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                disabledBackgroundColor: AppTheme.cardPurple.withValues(
                  alpha: 0.5,
                ),
              ),
              child: Text(_isAnswerLocked ? 'Locking...' : 'Lock Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
