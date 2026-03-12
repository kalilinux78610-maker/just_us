import 'package:go_router/go_router.dart';
import '../../data/models/truth_or_dare_item.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/truth_or_dare/truth_or_dare_screen.dart';
import '../../features/spin_wheel/spin_wheel_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/bucket_list/bucket_list_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/truth_or_dare/dare_browser_screen.dart';
import '../../features/truth_or_dare/position_generator_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'truth-or-dare',
          builder: (context, state) {
            final categoryName = state.uri.queryParameters['category'];
            TodCategory? category;
            if (categoryName != null) {
              try {
                category = TodCategory.values.firstWhere(
                  (e) => e.name == categoryName,
                );
              } catch (_) {
                category = null;
              }
            }
            return TruthOrDareScreen(initialCategory: category);
          },
        ),
        GoRoute(
          path: 'dare-browser',
          builder: (context, state) => const DareBrowserScreen(),
        ),
        GoRoute(
          path: 'spin-wheel',
          builder: (context, state) => const SpinWheelScreen(),
        ),
        GoRoute(path: 'quiz', builder: (context, state) => const QuizScreen()),
        GoRoute(
          path: 'bucket-list',
          builder: (context, state) => const BucketListScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'position-generator',
          builder: (context, state) => const PositionGeneratorScreen(),
        ),
      ],
    ),
  ],
);
