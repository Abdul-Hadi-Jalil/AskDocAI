import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get light {
    final colors =
        ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppConstants.primaryColor,
          onPrimary: Colors.white,
          secondary: AppConstants.secondaryColor,
          onSecondary: Colors.white,
          surface: Colors.white,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: AppConstants.backgroundColor,
          surfaceContainerHigh: AppConstants.surfaceTint,
          primaryContainer: AppConstants.surfaceTint,
          onPrimaryContainer: AppConstants.primaryColor,
          outline: AppConstants.borderColor,
          onSurface: AppConstants.textColor,
          onSurfaceVariant: AppConstants.subtitleColor,
        );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: shape.copyWith(side: BorderSide(color: colors.outline)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: shape,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.outline),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.backgroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.secondary, width: 2),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.secondary,
      ),
      dividerTheme: DividerThemeData(color: colors.outline),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.primary,
        contentTextStyle: TextStyle(color: colors.onPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
