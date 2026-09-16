import 'package:flutter/material.dart';

/// Colour tokens sampled pixel-by-pixel from the approved Sehat Sathi
/// onboarding references (`image/Screenshot 2026-09-14 014826.png` and
/// `image/Screenshot 2026-09-14 014943.png`).
abstract final class AppColors {
  /// Page background.
  static const Color background = Color(0xFFFFFFFF);

  /// Card, sheet and popover surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Primary text.
  static const Color ink = Color(0xFF0F172A);

  /// Secondary body copy.
  static const Color body = Color(0xFF64748B);

  /// Muted captions and hints.
  static const Color muted = Color(0xFF94A3B8);

  /// Brand blue used for accents, iconography and badges.
  static const Color brand = Color(0xFF669FD9);

  /// Darker end of the primary gradient.
  static const Color brandDark = Color(0xFF5F99D6);

  /// Lighter end of the primary gradient.
  static const Color brandLight = Color(0xFF7CB0E5);

  /// Hairline border on cards and fields.
  static const Color border = Color(0xFFE6EBF2);

  /// Slightly stronger border used by tinted surfaces.
  static const Color borderStrong = Color(0xFFE2E8F0);

  /// Tint applied to the body of a selected card.
  static const Color selectedTint = Color(0xFFF5F9FD);

  /// Neutral fill for icon chips and the search field.
  static const Color tile = Color(0xFFF5F8FC);

  /// Pill background for the language / role badge.
  static const Color badge = Color(0xFFEAF2FB);

  /// Footer panel background.
  static const Color footer = Color(0xFFF8FAFC);

  /// Text and icons placed on a brand-coloured surface.
  static const Color white = Color(0xFFFFFFFF);

  /// Outline drawn by an unselected radio indicator.
  static const Color indicator = Color(0xFFCBD5E1);

  /// Elevation used by the selected card.
  static const List<BoxShadow> selectedCardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x1F669FD9), blurRadius: 16, offset: Offset(0, 6)),
  ];

  /// Primary call-to-action gradient.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[brandDark, brandLight],
  );

  /// Soft blue glow rendered underneath the primary button.
  static const List<BoxShadow> brandGlow = <BoxShadow>[
    BoxShadow(color: Color(0x2E669FD9), blurRadius: 18, offset: Offset(0, 8)),
  ];

  /// Elevation used by the selectable cards.
  static const List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x0F0F172A), blurRadius: 12, offset: Offset(0, 4)),
  ];
}