import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryPink = Color(0xFFE91E8C);
  static const Color deepPurple = Color(0xFF7B2D8B);
  static const Color darkViolet = Color(0xFF0F051D); // Even darker
  static const Color cardPurple = Color(0xFF1E1231);
  static const Color softPink = Color(0xFFFF6B9D);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color whiteText = Colors.white;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryPink,
      scaffoldBackgroundColor: darkViolet,
      colorScheme: const ColorScheme.dark(
        primary: primaryPink,
        secondary: deepPurple,
        tertiary: goldAccent,
        surface: cardPurple,
        surfaceContainerHigh: Color(0xFF2D1B4E),
      ),
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: whiteText,
        ),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: whiteText,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: whiteText,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryPink,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: whiteText,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 18,
        color: whiteText.withValues(alpha: 0.9),
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 16,
        color: whiteText.withValues(alpha: 0.8),
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: goldAccent,
      ),
    );
  }
}
