import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF1A1A2E);
  static const accent = Color(0xFF00D4AA);
  static const card = Color(0xFF16213E);
  static const surface = Color(0xFF0F3460);
  static const danger = Color(0xFFE94560);

  static final List<Color> medicineColors = [
    const Color(0xFF00D4AA),
    const Color(0xFFFF6B6B),
    const Color(0xFFFFD93D),
    const Color(0xFF6BCB77),
    const Color(0xFF4D96FF),
    const Color(0xFFFF922B),
    const Color(0xFFCC5DE8),
    const Color(0xFF20C997),
  ];

  static final List<String> medicineIcons = [
    '💊', '💉', '🩺', '🧴', '🫀', '🧠', '👁️', '🦷',
  ];

  static final List<String> units = [
    'حبة', 'كبسولة', 'مل', 'قطرة', 'ملعقة', 'جرام',
  ];

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primary,
        primaryColor: accent,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          surface: card,
          error: danger,
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.dark().textTheme,
        ),
        cardTheme: CardThemeData(
          color: card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          elevation: 0,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
}
