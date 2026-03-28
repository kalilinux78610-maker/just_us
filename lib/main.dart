import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_us/firebase_options.dart';

import 'data/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: JustUsApp()));
}

class JustUsApp extends ConsumerWidget {
  const JustUsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Just Us',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      locale: locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
