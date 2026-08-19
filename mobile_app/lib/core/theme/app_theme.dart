import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFF06B6D4);

  // ============================================================
  // BACKGROUND & SURFACE
  // ============================================================

  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E293B);

  // ============================================================
  // ACCENT & ALERTS
  // ============================================================

  static const Color accent = Color(0xFFF43F5E);
  static const Color sos = Color(0xFFEF4444);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ----------------------------------------------------------
    // BACKGROUND
    // ----------------------------------------------------------

    scaffoldBackgroundColor: background,

    // ----------------------------------------------------------
    // COLOR SCHEME
    // ----------------------------------------------------------

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: accent,

      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onError: Colors.white,
    ),

    // ----------------------------------------------------------
    // GLOBAL TEXT THEME
    // ----------------------------------------------------------

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: textPrimary,
      ),

      bodyMedium: TextStyle(
        color: textPrimary,
      ),

      bodySmall: TextStyle(
        color: textSecondary,
      ),

      titleLarge: TextStyle(
        color: textPrimary,
      ),

      titleMedium: TextStyle(
        color: textPrimary,
      ),

      titleSmall: TextStyle(
        color: textSecondary,
      ),

      headlineLarge: TextStyle(
        color: textPrimary,
      ),

      headlineMedium: TextStyle(
        color: textPrimary,
      ),

      headlineSmall: TextStyle(
        color: textPrimary,
      ),

      labelLarge: TextStyle(
        color: textPrimary,
      ),

      labelMedium: TextStyle(
        color: textSecondary,
      ),

      labelSmall: TextStyle(
        color: textMuted,
      ),
    ),

    // ----------------------------------------------------------
    // APP BAR
    // ----------------------------------------------------------

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
    ),

    // ----------------------------------------------------------
    // CARD
    // ----------------------------------------------------------

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),

    // ==========================================================
    // TEXT FIELDS
    // ==========================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: surface,

      // --------------------------------------------------------
      // TEXT INSIDE TEXT FIELD
      // --------------------------------------------------------

      // This controls the hint.
      hintStyle: const TextStyle(
        color: textMuted,
        fontSize: 14,
      ),

      // This controls the label.
      labelStyle: const TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),

      // --------------------------------------------------------
      // ICONS
      // --------------------------------------------------------

      prefixIconColor: secondary,

      suffixIconColor: textSecondary,

      // --------------------------------------------------------
      // NORMAL BORDER
      // --------------------------------------------------------

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),

      // --------------------------------------------------------
      // ENABLED BORDER
      // --------------------------------------------------------

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),

      // --------------------------------------------------------
      // FOCUSED BORDER
      // --------------------------------------------------------

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: primary,
          width: 2,
        ),
      ),

      // --------------------------------------------------------
      // ERROR BORDER
      // --------------------------------------------------------

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: accent,
          width: 1,
        ),
      ),

      // --------------------------------------------------------
      // FOCUSED ERROR BORDER
      // --------------------------------------------------------

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: accent,
          width: 2,
        ),
      ),
    ),

    // ==========================================================
    // BUTTONS
    // ==========================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,

        elevation: 0,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ),

    // ==========================================================
    // TEXT BUTTON
    // ==========================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondary,
      ),
    ),

    // ==========================================================
    // NAVIGATION BAR
    // ==========================================================

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primary,

      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          color: textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ==========================================================
    // DIVIDER
    // ==========================================================

    dividerTheme: const DividerThemeData(
      color: Colors.white12,
      thickness: 1,
    ),

    // ==========================================================
    // TEXT SELECTION
    // ==========================================================

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: secondary,
      selectionColor: Color(0x5506B6D4),
      selectionHandleColor: secondary,
    ),
  );
}