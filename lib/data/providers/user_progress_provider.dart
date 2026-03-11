import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';

final userProgressProvider =
    NotifierProvider<UserProgressNotifier, UserProgress>(() {
      return UserProgressNotifier();
    });

class UserProgress {
  final int score;
  final int streakDays;
  final DateTime? lastPlayed;
  final List<String> unlockedStickerIds;

  UserProgress({
    required this.score,
    required this.streakDays,
    this.lastPlayed,
    this.unlockedStickerIds = const [],
  });

  UserProgress copyWith({
    int? score,
    int? streakDays,
    DateTime? lastPlayed,
    List<String>? unlockedStickerIds,
  }) {
    return UserProgress(
      score: score ?? this.score,
      streakDays: streakDays ?? this.streakDays,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      unlockedStickerIds: unlockedStickerIds ?? this.unlockedStickerIds,
    );
  }
}

class UserProgressNotifier extends Notifier<UserProgress> {
  @override
  UserProgress build() {
    return _loadProgress();
  }

  UserProgress _loadProgress() {
    final box = StorageService.progressBox;
    final score = box.get('score', defaultValue: 0) as int;
    final streakDays = box.get('streakDays', defaultValue: 0) as int;
    final lastPlayedStr = box.get('lastPlayed') as String?;
    final unlockedStickers = List<String>.from(
      box.get('unlockedStickers', defaultValue: <String>[]) as Iterable,
    );

    DateTime? lastPlayed;
    if (lastPlayedStr != null) {
      lastPlayed = DateTime.parse(lastPlayedStr);
    }

    // Streak logic check
    int activeStreak = streakDays;
    if (lastPlayed != null) {
      final now = DateTime.now();
      final difference = now.difference(lastPlayed).inDays;
      if (difference > 1) {
        // More than 1 day missed, reset streak
        activeStreak = 0;
      } else if (difference == 1) {
        // Continue streak, but we don't increment until they play a game today
      }
    }

    final progress = UserProgress(
      score: score,
      streakDays: activeStreak,
      lastPlayed: lastPlayed,
      unlockedStickerIds: unlockedStickers,
    );

    if (activeStreak != streakDays) {
      _saveProgress(progress);
    }

    return progress;
  }

  void addScore(int points) {
    state = state.copyWith(score: state.score + points);
    _saveProgress(state);
  }

  void unlockSticker(String stickerId) {
    if (!state.unlockedStickerIds.contains(stickerId)) {
      state = state.copyWith(
        unlockedStickerIds: [...state.unlockedStickerIds, stickerId],
      );
      _saveProgress(state);
    }
  }

  void recordPlayToday() {
    final now = DateTime.now();
    int newStreak = state.streakDays;

    if (state.lastPlayed != null) {
      final diff = now.difference(state.lastPlayed!).inDays;
      if (diff == 1) {
        newStreak += 1;
      } else if (diff > 1) {
        newStreak = 1; // Restarted streak
      }
    } else {
      newStreak = 1; // First time playing
    }

    state = state.copyWith(streakDays: newStreak, lastPlayed: now);
    _saveProgress(state);
  }

  void _saveProgress(UserProgress progress) {
    final box = StorageService.progressBox;
    box.put('score', progress.score);
    box.put('streakDays', progress.streakDays);
    box.put('unlockedStickers', progress.unlockedStickerIds);
    if (progress.lastPlayed != null) {
      box.put('lastPlayed', progress.lastPlayed!.toIso8601String());
    }
  }
}
