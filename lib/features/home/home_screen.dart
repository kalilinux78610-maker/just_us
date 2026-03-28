import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/premium_widgets.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/translation_data.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final lang = locale.languageCode;

    return Scaffold(
      body: SpicyBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TranslationData.translate('app_title', lang),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => ref
                              .read(localeProvider.notifier)
                              .toggleLanguage(),
                          child: Text(
                            lang == 'en' ? 'HINDI' : 'EN',
                            style: const TextStyle(
                              color: AppTheme.primaryPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () => context.go('/settings'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Center(
                  child: Text(
                    TranslationData.translate('beyond_words', lang),
                    style: const TextStyle(
                      color: Colors.white24,
                      letterSpacing: 8,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Hero Dare Button
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/truth-or-dare'),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: const DecorationImage(
                          image:
                              AssetImage('assets/images/biting_lips_hero.png'),
                          fit: BoxFit.cover,
                          opacity: 0.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPink.withValues(alpha: 0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TranslationData.translate('spicy_dares', lang),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                TranslationData.translate(
                                    'tap_to_ignite', lang),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Positions Generator Button
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/position-generator'),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/pos_im14.png'),
                          fit: BoxFit.cover,
                          opacity: 0.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.goldAccent.withValues(alpha: 0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TranslationData.translate('positions', lang),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                TranslationData.translate(
                                  'tap_to_generate',
                                  lang,
                                ),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Chat & Play Button
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/multiplayer'),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A00E0).withValues(alpha: 0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Icon(
                                Icons.chat_bubble_rounded,
                                size: 150,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.flash_on_rounded, color: AppTheme.goldAccent),
                                      const SizedBox(width: 8),
                                      Text(
                                        TranslationData.translate('chat_and_play', lang),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    TranslationData.translate('connect_remotely', lang),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sticker Dares Button
                Center(
                  child: GestureDetector(
                    onTap: () => context
                        .push('/truth-or-dare?category=stickerDare'),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: const DecorationImage(
                          image: AssetImage('assets/stickers/1758671495.webp'),
                          fit: BoxFit.contain,
                          opacity: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPink.withValues(alpha: 0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TranslationData.translate('sticker_dares', lang),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                TranslationData.translate(
                                  'tap_to_see_stickers',
                                  lang,
                                ),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
