import 'package:flutter/material.dart';
import 'package:verily_ui/src/theme/app_spacing.dart';

/// Defines the application's visual theme, supporting light and dark modes.
class AppTheme {
  AppTheme._();

  // --- Colors (Consider moving to app_colors.dart if extensive) ---
  // Using Material 3 conventions (seed color generates scheme)
  static const _primarySeedColor = Colors.blue; // Base color for the theme
  // Define specific overrides if needed
  static const _lightSurface = Color(0xFFFDFDFD); // Slightly off-white
  static const _lightBackground = Color(0xFFF3F4F6); // Light gray background
  static const _darkSurface = Color(0xFF1E1E1E); // Dark gray surface
  static const _darkBackground = Color(0xFF121212); // Very dark background

  // --- Text Style Helper ---
  static const String _fontFamily = 'Inter'; // Example: Using Inter font

  static TextTheme _buildTextTheme(TextTheme base) {
    // Customize base text theme if needed, apply font family
    return base
        .copyWith(
          // Example: Adjust bodyMedium size or weight
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 15.0),
          // Add other customizations as needed
        )
        .apply(
          fontFamily: _fontFamily,
          // Adjust display/body colors for contrast if scheme generation isn't perfect
          // displayColor: base.displayMedium?.color, // Example
          // bodyColor: base.bodyMedium?.color, // Example
        );
  }

  // --- Button Style Helper ---
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        elevation: 1.0, // Subtle elevation
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppSpacing.sm), // Use spacing constant
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600, // Semi-bold
          fontSize: 15,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  // --- Input Decoration Helper ---
  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide.none, // Clean borderless look
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle:
          TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
    );
  }

  // --- Card Theme Helper ---
  static CardTheme _cardTheme(ColorScheme colorScheme) {
    return CardTheme(
      elevation: 2.0, // Slightly more elevation for cards
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            AppSpacing.md), // Slightly larger radius for cards
      ),
      color: colorScheme.surface, // Use surface color
    );
  }

  // --- AppBar Theme Helper ---
  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
        elevation: 0, // Flat app bar
        centerTitle: false, // Typically false for wider screens
        backgroundColor: colorScheme.surface, // Match surface
        foregroundColor: colorScheme.onSurface, // Ensure contrast
        surfaceTintColor: Colors.transparent, // Avoid tinting on scroll
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ));
  }

  // --- Light Theme ---
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primarySeedColor,
      brightness: Brightness.light,
      // Override generated colors if needed
      surface: _lightSurface,
      background: _lightBackground,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(baseTheme.textTheme).apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Add other component themes (dialog, etc.)
    );
  }

  // --- Dark Theme ---
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primarySeedColor,
      brightness: Brightness.dark,
      // Override generated colors if needed
      surface: _darkSurface,
      background: _darkBackground,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(baseTheme.textTheme).apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Add other component themes (dialog, etc.)
    );
  }
}
