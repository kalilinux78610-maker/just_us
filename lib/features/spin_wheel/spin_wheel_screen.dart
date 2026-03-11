import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SpinWheelScreen extends ConsumerStatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  ConsumerState<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends ConsumerState<SpinWheelScreen> {
  // Streams for Fortune Wheel
  StreamController<int> selected = StreamController<int>();
  int? _lastResultIndex;

  final List<String> _segments = [
    'Romantic Truth',
    'Spicy Truth',
    'Romantic Dare',
    'Spicy Dare',
    'Bucket List Pick',
    'Couple Quiz',
    'Bonus Challenge',
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void _spin() {
    // Logic: Avoid spinning the exact same result twice in a row if possible (Proposal rule)
    final random = Random();
    int nextResult;
    do {
      nextResult = random.nextInt(_segments.length);
    } while (nextResult == _lastResultIndex && _segments.length > 1);

    _lastResultIndex = nextResult;
    selected.add(nextResult);
  }

  void _onSpinComplete() {
    if (_lastResultIndex == null) return;
    final result = _segments[_lastResultIndex!];

    // Show dialog with result
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Result!',
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'You landed on:\n\n$result',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleResultAction(result);
            },
            child: const Text('Let\'s Go!'),
          ),
        ],
      ),
    );
  }

  void _handleResultAction(String result) {
    // Navigate to the appropriate game mode or show bonus popup
    if (result.contains('Truth') || result.contains('Dare')) {
      context.push('/truth-or-dare');
    } else if (result == 'Couple Quiz') {
      context.push('/quiz');
    } else if (result == 'Bucket List Pick') {
      context.push('/bucket-list');
    } else {
      // Bonus Challenge - just show a fun snackbar for now
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bonus Challenge: Give your partner a 1 minute massage! 💕',
          ),
          backgroundColor: AppTheme.primaryPink,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spin the Wheel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: FortuneWheel(
                    selected: selected.stream,
                    onAnimationEnd: _onSpinComplete,
                    indicators: const <FortuneIndicator>[
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(color: AppTheme.softPink),
                      ),
                    ],
                    items: [
                      for (int i = 0; i < _segments.length; i++)
                        FortuneItem(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _segments[i],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: FortuneItemStyle(
                            color: i % 2 == 0
                                ? AppTheme.primaryPink
                                : AppTheme.deepPurple,
                            borderColor: AppTheme.cardPurple,
                            borderWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(onPressed: _spin, child: const Text('SPIN!')),
          ],
        ),
      ),
    );
  }
}
