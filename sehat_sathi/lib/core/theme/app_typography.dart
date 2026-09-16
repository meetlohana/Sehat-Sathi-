import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type tokens measured from the approved onboarding reference screenshots.
///
/// Inter is the primary family and Noto Sans Devanagari is bundled as the
/// fallback so bilingual Latin + Devanagari strings render offline without
/// any runtime font download.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  static const List<String> fontFamilyFallback = <String>[
    'NotoSansDevanagari',
  ];

  /// 22 / w700 — screen headline (`Select Language`).
  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.24,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );

  /// 13 / w600 — brand-blue bilingual line under the headline.
  static const TextStyle bilingualSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.brand,
  );

  /// 12 / w700 — `STEP 1 OF 2` eyebrow label.
  static const TextStyle stepLabel = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.brand,
  );

  /// 16 / w700 — selectable card title.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.1,
    color: AppColors.ink,
  );

  /// 12.5 / w400 — selectable card supporting text (clamped to two lines).
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.body,
  );

  /// 10.5 / w700 — uppercase pill badge inside cards and headers.
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 10.5,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: 0.6,
    color: AppColors.brand,
  );

  /// 15 / w500 — search field value.
  static const TextStyle field = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.ink,
  );

  /// 15 / w500 — search field placeholder.
  static const TextStyle fieldHint = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.muted,
  );

  /// 16 / w700 — primary gradient button label.
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.white,
  );

  /// 12 / w400 — footer caption.
  static const TextStyle footerCaption = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.muted,
  );

  /// 13 / w400 — header paragraph under the bilingual subtitle.
  static const TextStyle bodyCopy = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.body,
  );

  /// 15 / w600 — monogram inside a language card's leading tile.
  static const TextStyle tileMonogram = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.ink,
  );

  /// 11.5 / w400 — Latin transliteration under a native language name.
  static const TextStyle transliteration = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.muted,
  );

  /// 12 / w600 — Marathi / Hindi pill rendered next to a role title.
  static const TextStyle cardBadge = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.brand,
  );

  /// Baseline Material text theme so default widgets inherit the brand fonts.
  static const TextTheme textTheme = TextTheme(
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 16,
      height: 1.3,
      color: AppColors.ink,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 14,
      height: 1.3,
      color: AppColors.ink,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 12,
      height: 1.3,
      color: AppColors.body,
    ),
    titleMedium: cardTitle,
    labelLarge: buttonLabel,
  );
}