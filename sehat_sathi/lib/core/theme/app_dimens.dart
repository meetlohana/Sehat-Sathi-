import 'package:flutter/painting.dart';

/// Spacing, radius and size tokens measured from the approved onboarding
/// reference screenshots.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;

  /// Horizontal page gutter used by both onboarding steps.
  static const double page = 20;

  /// Vertical gap between stacked form controls.
  static const double control = 12;

  /// Vertical gap between the header block and the first card.
  static const double header = 22;

  /// Vertical gap between stacked selectable cards.
  static const double cardGap = 12;

  /// Gap between the safe-area edge and the circular back button.
  static const double backTop = 4;

  /// Gap between the header block and the search field.
  static const double search = 14;

  /// Inner padding of the sticky footer panel.
  static const double footer = 20;
}

/// Corner radii of the recurring surfaces.
abstract final class AppRadii {
  static const double chip = 10;
  static const double tile = 14;
  static const double field = 16;
  static const double card = 18;
  static const double button = 18;
  static const double sheet = 24;

  static const BorderRadius chipAll = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius fieldAll = BorderRadius.all(Radius.circular(field));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonAll = BorderRadius.all(Radius.circular(button));
}

/// Fixed sizes for the recurring controls.
abstract final class AppSizes {
  /// Logical width of the reference design canvas.
  static const double canvasWidth = 390;

  /// Logical height of the reference design canvas.
  static const double canvasHeight = 844;

  static const double backButton = 44;
  static const double iconTile = 44;
  static const double radio = 22;
  static const double buttonHeight = 54;
  static const double fieldHeight = 52;
  static const double leadingTile = 46;
  static const double badgeHeight = 24;
  static const double cardMinHeight = 76;
  static const double cardIcon = 22;
  static const double hairline = 1;
}