import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/translation_data.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(TranslationData.translate('settings', lang))),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: TranslationData.translate('language', lang),
            trailing: DropdownButton<String>(
              value: lang,
              underline: const SizedBox(),
              dropdownColor: AppTheme.cardPurple,
              items: [
                const DropdownMenuItem(
                  value: 'en',
                  child: Text('English', style: TextStyle(color: Colors.white)),
                ),
                const DropdownMenuItem(
                  value: 'hi',
                  child: Text('HINDI', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (newLang) {
                if (newLang != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(newLang));
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            icon: Icons.volume_up,
            title: TranslationData.translate('sound_effects', lang),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeThumbColor: AppTheme.primaryPink,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            icon: Icons.eighteen_up_rating,
            title: TranslationData.translate('allow_spicy', lang),
            subtitle: TranslationData.translate('allow_spicy_sub', lang),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeThumbColor: AppTheme.primaryPink,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            icon: Icons.restore,
            title: TranslationData.translate('reset_progress', lang),
            subtitle: TranslationData.translate('reset_progress_sub', lang),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Not implemented yet.')),
              );
            },
          ),
          const SizedBox(height: 48),
          Center(
            child: Text(
              'Just Us v1.0.0\nMade with 💕 by Antigravity',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.softPink),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      subtitle: subtitle != null
          ? Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)
          : null,
      trailing: trailing,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tileColor: AppTheme.cardPurple,
    );
  }
}
