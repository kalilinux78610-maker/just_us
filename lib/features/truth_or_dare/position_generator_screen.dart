import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/truth_or_dare_item.dart';
import '../../data/repositories/truth_or_dare_data.dart';
import '../../shared/widgets/premium_widgets.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/translation_data.dart';

class PositionGeneratorScreen extends ConsumerStatefulWidget {
  const PositionGeneratorScreen({super.key});

  @override
  ConsumerState<PositionGeneratorScreen> createState() =>
      _PositionGeneratorScreenState();
}

class _PositionGeneratorScreenState
    extends ConsumerState<PositionGeneratorScreen>
    with SingleTickerProviderStateMixin {
  TruthOrDareItem? _currentPosition;
  late AnimationController _animationController;
  final _random = Random();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _generatePosition(silent: true);
  }

  void _generatePosition({bool silent = false}) async {
    final positions = TruthOrDareData.items
        .where((i) => i.category == TodCategory.immersive)
        .toList();

    if (positions.isEmpty) return;

    if (silent) {
      setState(() {
        _currentPosition = positions[_random.nextInt(positions.length)];
      });
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    _animationController.forward(from: 0);

    // Simulate thinking/generating with rapid cycling through positions
    for (int i = 0; i < 12; i++) {
      await Future.delayed(Duration(milliseconds: 60 + (i * 10)));
      setState(() {
        _currentPosition = positions[_random.nextInt(positions.length)];
      });
    }

    setState(() {
      _isGenerating = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white70,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          TranslationData.translate('positions', lang),
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 4,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SpicyBackground(
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 40),
            if (_currentPosition != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _PositionCard(
                        key: ValueKey(_currentPosition!.id),
                        item: _currentPosition!,
                        lang: lang,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Text(
                    TranslationData.translate('tap_to_generate', lang),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isGenerating ? null : () => _generatePosition(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 15,
                      shadowColor: AppTheme.primaryPink.withValues(alpha: 0.6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isGenerating)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        else
                          const Icon(Icons.auto_awesome_rounded, size: 24),
                        const SizedBox(width: 16),
                        Text(
                          TranslationData.translate('generate_position', lang),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  final TruthOrDareItem item;
  final String lang;

  const _PositionCard({super.key, required this.item, required this.lang});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 520,
      borderColor: AppTheme.primaryPink.withValues(alpha: 0.3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            if (item.imageUrl != null)
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              const Expanded(
                flex: 3,
                child: Center(
                  child: Icon(
                    Icons.favorite_rounded,
                    color: AppTheme.primaryPink,
                    size: 64,
                  ),
                ),
              ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: AppTheme.goldAccent.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        (lang == 'hi' && item.hindiContent != null)
                            ? item.hindiContent!
                            : item.content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.6,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Icon(
                        Icons.favorite_rounded,
                        color: AppTheme.primaryPink,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
