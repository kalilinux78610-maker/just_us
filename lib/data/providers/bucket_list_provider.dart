import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../models/bucket_list_item.dart';

final bucketListProvider =
    NotifierProvider<BucketListNotifier, List<BucketListItem>>(() {
      return BucketListNotifier();
    });

class BucketListNotifier extends Notifier<List<BucketListItem>> {
  @override
  List<BucketListItem> build() {
    return _loadItems();
  }

  List<BucketListItem> _loadItems() {
    final box = StorageService.bucketBox;
    final List<dynamic>? storedItems = box.get('items');

    if (storedItems != null) {
      return storedItems.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        return BucketListItem.fromMap(map);
      }).toList();
    } else {
      // Load defaults
      final defaults = [
        BucketListItem(
          id: '1',
          title: 'Cook dinner together',
          hindiTitle: 'Sath mein dinner banao',
          isCompleted: false,
        ),
        BucketListItem(
          id: '2',
          title: 'Go on a weekend getaway',
          hindiTitle: 'Weekend par bahar jao',
          isCompleted: false,
        ),
        BucketListItem(
          id: '3',
          title: 'Watch a sunset',
          hindiTitle: 'Sunset dekho',
          isCompleted: false,
        ),
        BucketListItem(
          id: '4',
          title: 'Take a polaroid photo',
          hindiTitle: 'Ek polaroid photo kheencho',
          isCompleted: false,
        ),
        BucketListItem(
          id: '5',
          title: 'Have a movie marathon',
          hindiTitle: 'Movie marathon karo',
          isCompleted: false,
        ),
      ];
      final box = StorageService.bucketBox;
      box.put('items', defaults.map((e) => e.toMap()).toList());
      return defaults;
    }
  }

  void addItem(String title) {
    final newItem = BucketListItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
    );
    state = [...state, newItem];
    _saveItems();
  }

  void toggleItem(String id) {
    state = state.map((item) {
      if (item.id == id) {
        // Completed items cannot be unchecked based on rules
        if (item.isCompleted) return item;
        return item.copyWith(isCompleted: true);
      }
      return item;
    }).toList();
    _saveItems();
  }

  void _saveItems() {
    final box = StorageService.bucketBox;
    box.put('items', state.map((e) => e.toMap()).toList());
  }
}
