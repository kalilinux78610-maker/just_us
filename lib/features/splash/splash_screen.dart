import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkViolet,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using an Icon for now, later we integrate Lottie
            const Icon(Icons.favorite, color: AppTheme.primaryPink, size: 100),
            const SizedBox(height: 20),
            Text('Just Us', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 10),
            Text(
              'A game for couples',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.softPink),
            ),
          ],
        ),
      ),
    );
  }
}
