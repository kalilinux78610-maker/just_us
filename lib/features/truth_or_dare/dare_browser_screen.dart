import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/truth_or_dare_data.dart';
import '../../shared/widgets/premium_widgets.dart';

class DareBrowserScreen extends StatelessWidget {
  const DareBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dares = TruthOrDareData.items;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('THE COLLECTION')),
      body: SpicyBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
          itemCount: dares.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final dare = dares[index];
            return GlassCard(
              padding: const EdgeInsets.all(20),
              borderColor: AppTheme.primaryPink.withValues(alpha: 0.1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: AppTheme.primaryPink.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      dare.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
