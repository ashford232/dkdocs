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
  // DARK — NEUTRAL
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1C1C1C);
  static const darkSurfaceVariant = Color(0xFF262626);

  static const darkText = Color(0xFFF5F5F5);
  static const darkTextSecondary = Color(0xFFA3A3A3);
  static const darkTextMuted = Color(0xFF737373);

  static const darkBorder = Color(0xFF333333);
  static const darkDivider = Color(0xFF292929);

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
    scaffoldBackgroundColor:
        lightBackground, // Fixed: Using background instead of surface
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryLight,
      onPrimaryContainer: Colors.white,
      secondary: primaryLight,
      onSecondary: Colors.white,
      secondaryContainer: lightSurfaceVariant,
      onSecondaryContainer: primaryDark,
      tertiary: info, // Mapped info to tertiary for extra M3 flexibility
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFDBEAFE),
      onTertiaryContainer: Color(0xFF1E40AF),
      error: error,
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),
      surface: lightSurface,
      onSurface: lightText,
      surfaceContainerHighest: lightSurfaceVariant,
      onSurfaceVariant: lightTextSecondary,
      outline: lightBorder,
      outlineVariant: lightDivider,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: lightText,
      onInverseSurface: lightSurface,
      inversePrimary: primaryLight,
    ),
    dividerColor: lightDivider,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground, // Often matches scaffold to blend in
      foregroundColor: lightText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: lightSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      // Added a subtle border since elevation is 0
      shape: RoundedRectangleBorder(
        side: BorderSide(color: lightBorder),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );

  // DARK THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppFonts.inter,
    useMaterial3: true,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryLight,
      onPrimary: darkBackground,
      primaryContainer: primaryDark,
      onPrimaryContainer: primaryLight,
      secondary: primaryLight,
      onSecondary: darkBackground,
      secondaryContainer: darkSurfaceVariant,
      onSecondaryContainer: primaryLight,
      tertiary: info,
      onTertiary: Colors.white,
      tertiaryContainer: darkSurfaceVariant,
      onTertiaryContainer: Colors.white,
      error: Color(0xFFF87171),
      onError: darkBackground,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFCA5A5),
      surface: darkSurface,
      onSurface: darkText,
      surfaceContainerHighest: darkSurfaceVariant,
      onSurfaceVariant: darkTextSecondary,
      outline: darkBorder,
      outlineVariant: darkDivider,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: darkText,
      onInverseSurface: darkSurface,
      inversePrimary: primary,
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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: darkBorder),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
