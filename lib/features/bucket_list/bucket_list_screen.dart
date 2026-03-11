import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/bucket_list_provider.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/translation_data.dart';

class BucketListScreen extends ConsumerStatefulWidget {
  const BucketListScreen({super.key});

  @override
  ConsumerState<BucketListScreen> createState() => _BucketListScreenState();
}

class _BucketListScreenState extends ConsumerState<BucketListScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final lang = ref.watch(localeProvider).languageCode;
        return AlertDialog(
          backgroundColor: AppTheme.cardPurple,
          title: Text(TranslationData.translate('add_to_bucket_list', lang)),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'e.g. Go stargazing at midnight',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primaryPink),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.softPink, width: 2),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                TranslationData.translate('cancel', lang),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = _textController.text.trim();
                if (text.length >= 5) {
                  ref.read(bucketListProvider.notifier).addItem(text);
                  _textController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item must be at least 5 characters long.'),
                    ),
                  );
                }
              },
              child: Text(TranslationData.translate('add', lang)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(bucketListProvider);
    final completedCount = items.where((i) => i.isCompleted).length;
    final progress = items.isEmpty ? 0.0 : completedCount / items.length;
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationData.translate('stickers', lang),
        ), // Using stickers or better 'bucket_list'
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            color: AppTheme.softPink,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardPurple,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        TranslationData.translate('progress', lang),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.softPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.deepPurple,
                    color: AppTheme.primaryPink,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          item.isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: item.isCompleted
                              ? AppTheme.softPink
                              : Colors.white38,
                          size: 28,
                        ),
                        onPressed: () {
                          if (!item.isCompleted) {
                            ref
                                .read(bucketListProvider.notifier)
                                .toggleItem(item.id);
                            // Show small celebration snackbar or lottie later
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  TranslationData.translate(
                                    'memory_made',
                                    lang,
                                  ),
                                ),
                                backgroundColor: AppTheme.primaryPink,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      title: Text(
                        (lang == 'hi' && item.hindiTitle != null)
                            ? item.hindiTitle!
                            : item.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isCompleted
                              ? Colors.white54
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
