import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SpicyBackground extends StatelessWidget {
  final Widget child;
  const SpicyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Background
        Container(color: AppTheme.darkViolet),

        // Blobs
        Positioned(
          top: -100,
          right: -50,
          child: _CircularBlob(
            size: 300,
            color: AppTheme.primaryPink.withValues(alpha: 0.15),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -100,
          child: _CircularBlob(
            size: 400,
            color: AppTheme.deepPurple.withValues(alpha: 0.2),
          ),
        ),

        // Glass Overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),

        // Content
        SafeArea(child: child),
      ],
    );
  }
}

class _CircularBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _CircularBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
