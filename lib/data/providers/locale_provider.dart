import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final box = StorageService.progressBox;
    final languageCode = box.get('languageCode', defaultValue: 'en') as String;
    return Locale(languageCode);
  }

  void setLocale(Locale locale) {
    if (state == locale) return;
    state = locale;
    final box = StorageService.progressBox;
    box.put('languageCode', locale.languageCode);
  }

  bool get isHindi => state.languageCode == 'hi';

  void toggleLanguage() {
    setLocale(isHindi ? const Locale('en') : const Locale('hi'));
  }
}
