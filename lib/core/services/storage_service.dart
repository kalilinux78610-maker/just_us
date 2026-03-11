import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _settingsBox = 'settingsBox';
  static const String _progressBox = 'progressBox';
  static const String _bucketBox = 'bucketBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters here if we have custom objects
    // Hive.registerAdapter(BucketListItemAdapter());

    await Hive.openBox(_settingsBox);
    await Hive.openBox(_progressBox);
    await Hive.openBox(_bucketBox);
  }

  static Box get settingsBox => Hive.box(_settingsBox);
  static Box get progressBox => Hive.box(_progressBox);
  static Box get bucketBox => Hive.box(_bucketBox);
}
