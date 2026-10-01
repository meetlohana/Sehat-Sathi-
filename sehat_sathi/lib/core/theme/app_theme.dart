import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Material theme assembled from the sampled Sehat Sathi design tokens.
abstract final class AppTheme {
  static ThemeData get light {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.brand,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.badge,
      onPrimaryContainer: AppColors.ink,
      secondary: AppColors.brandLight,
      onSecondary: AppColors.white,
      error: Color(0xFFDC2626),
      onError: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
      textTheme: AppTypography.textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.screenTitle,
      ),
      iconTheme: const IconThemeData(color: AppColors.brand, size: 22),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}