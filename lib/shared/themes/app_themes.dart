import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:flutter/material.dart';

class AppThemes {
  // BRAND
  static const primary = Color(0xFF0F766E);
  static const primaryLight = Color(0xFF14B8A6);
  static const primaryDark = Color(0xFF115E59);

  // LIGHT
  static const lightBackground = Color(0xFFF7F9F9);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0F3F3);

  static const lightText = Color(0xFF1F2933);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightTextMuted = Color(0xFF94A3B8);

  static const lightBorder = Color(0xFFD9E1E1);
  static const lightDivider = Color(0xFFE7ECEC);

  // DARK
  static const darkBackground = Color(0xFF101817);
  static const darkSurface = Color(0xFF182120);
  static const darkSurfaceVariant = Color(0xFF222D2C);

  static const darkText = Color(0xFFE7F0EF);
  static const darkTextSecondary = Color(0xFFA5B5B3);
  static const darkTextMuted = Color(0xFF71827F);

  static const darkBorder = Color(0xFF344240);
  static const darkDivider = Color(0xFF293634);

  // STATUS
  static const success = Color(0xFF16803C);
  static const warning = Color(0xFFD97706);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF2563EB);

  // LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFonts.inter,
    useMaterial3: true,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: primaryLight,
      onSecondary: Colors.white,
      surface: lightSurface,
      onSurface: lightText,
      surfaceContainerHighest: lightSurfaceVariant,
      error: error,
      onError: Colors.white,
    ),
    dividerColor: lightDivider,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: lightSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
  );

  // DARK THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppFonts.inter,
    useMaterial3: true,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryLight,
      onPrimary: Colors.white,
      secondary: primaryLight,
      onSecondary: Colors.white,
      surface: darkSurface,
      onSurface: darkText,
      surfaceContainerHighest: darkSurfaceVariant,
      error: Color(0xFFF87171),
      onError: Colors.white,
    ),
    dividerColor: darkDivider,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: darkSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
  );
}
