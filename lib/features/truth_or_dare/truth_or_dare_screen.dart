import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/truth_or_dare_item.dart';
import '../../data/repositories/truth_or_dare_data.dart';
import '../../data/providers/user_progress_provider.dart';
import '../../shared/widgets/premium_widgets.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/translation_data.dart';

class TruthOrDareScreen extends ConsumerStatefulWidget {
  final TodCategory? initialCategory;
  const TruthOrDareScreen({super.key, this.initialCategory});

  @override
  ConsumerState<TruthOrDareScreen> createState() => _TruthOrDareScreenState();
}

class _TruthOrDareScreenState extends ConsumerState<TruthOrDareScreen> {
  List<TruthOrDareItem> _shuffledDares = [];
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final _random = Random();
  TodCategory? _selectedCategory; // null means "All"

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadDares();
  }

  void _loadDares() {
    setState(() {
      _shuffledDares = TruthOrDareData.items.where((i) {
        if (_selectedCategory == null) {
          return i.category == TodCategory.spicyDare ||
              i.category == TodCategory.kissing ||
              i.category == TodCategory.intimate ||
              i.category == TodCategory.immersive ||
              i.category == TodCategory.truth ||
              i.category == TodCategory.inPerson ||
              i.category == TodCategory.longDistance;
        }
        return i.category == _selectedCategory;
      }).toList()..shuffle(_random);

      // Reset page controller if it's already initialized
      if (this.mounted && _pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  void _switchCategory(TodCategory? category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
    });
    _loadDares();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeChallenge(int index) {
    ref.read(userProgressProvider.notifier).addScore(10);
    ref.read(userProgressProvider.notifier).recordPlayToday();

    final lang = ref.read(localeProvider).languageCode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(TranslationData.translate('challenge_completed', lang)),
        backgroundColor: AppTheme.primaryPink,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white70,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle_rounded, color: Colors.white70),
            onPressed: _loadDares,
          ),
        ],
      ),
      body: SpicyBackground(
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 10),
            // Category Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _CategoryChip(
                    label: TranslationData.translate('all', lang),
                    isSelected: _selectedCategory == null,
                    onTap: () => _switchCategory(null),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('truth_category', lang),
                    isSelected: _selectedCategory == TodCategory.truth,
                    onTap: () => _switchCategory(TodCategory.truth),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('spicy', lang),
                    isSelected: _selectedCategory == TodCategory.spicyDare,
                    onTap: () => _switchCategory(TodCategory.spicyDare),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('kiss', lang),
                    isSelected: _selectedCategory == TodCategory.kissing,
                    onTap: () => _switchCategory(TodCategory.kissing),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('intimate', lang),
                    isSelected: _selectedCategory == TodCategory.intimate,
                    onTap: () => _switchCategory(TodCategory.intimate),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('immersive', lang),
                    isSelected: _selectedCategory == TodCategory.immersive,
                    onTap: () => _switchCategory(TodCategory.immersive),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('stickers', lang),
                    isSelected: _selectedCategory == TodCategory.stickerDare,
                    onTap: () => _switchCategory(TodCategory.stickerDare),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('long_distance', lang),
                    isSelected: _selectedCategory == TodCategory.longDistance,
                    onTap: () => _switchCategory(TodCategory.longDistance),
                  ),
                  _CategoryChip(
                    label: TranslationData.translate('in_person', lang),
                    isSelected: _selectedCategory == TodCategory.inPerson,
                    onTap: () => _switchCategory(TodCategory.inPerson),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _shuffledDares.length,
                itemBuilder: (context, index) {
                  final item = _shuffledDares[index];
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                      }
                      return Center(
                        child: Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value.clamp(0.5, 1.0),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onDoubleTap: () => _completeChallenge(index),
                      child: _buildCardFront(item, lang),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 12,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.swipe_rounded,
                      color: Colors.white24,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      TranslationData.translate('swipe_to_swap', lang),
                      style: const TextStyle(
                        color: Colors.white24,
                        letterSpacing: 1.5,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      color: Colors.white24,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      TranslationData.translate('double_tap_to_finish', lang),
                      style: const TextStyle(
                        color: Colors.white24,
                        letterSpacing: 1.5,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(TruthOrDareItem item, String lang) {
    return GlassCard(
      width: double.infinity,
      height: 480,
      borderColor: AppTheme.primaryPink.withValues(alpha: 0.4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.lottiePath != null)
                Container(
                  height: 240,
                  width: double.infinity,
                  child: Lottie.asset(
                    item.lottiePath!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.cardPurple.withValues(alpha: 0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.animation_rounded,
                              color:
                                  AppTheme.primaryPink.withValues(alpha: 0.5),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'ANIMATION ERROR',
                              style: TextStyle(
                                color: Colors.white24,
                                letterSpacing: 2,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              else if (item.imageUrl != null)
                Container(
                  height: 240,
                  width: double.infinity,
                  child: Image.asset(
                    item.imageUrl!,
                    fit: item.imageUrl!.contains('stickers/')
                        ? BoxFit.contain
                        : BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.cardPurple.withValues(alpha: 0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: AppTheme.goldAccent.withValues(alpha: 0.5),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'AI IMAGE READY',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTheme.goldAccent.withValues(
                                      alpha: 0.6,
                                    ),
                                    letterSpacing: 2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Use Local SD to Generate',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white24,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              else
                const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      TranslationData.translate('dare_accepted', lang),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.goldAccent.withValues(alpha: 0.8),
                        letterSpacing: 4,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      (lang == 'hi' && item.hindiContent != null)
                          ? item.hindiContent!
                          : item.content,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Outfit',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.primaryPink,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPink.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryPink
                : Colors.white.withValues(alpha: 0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryPink.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
