import 'package:flutter/material.dart';

/// A language offered on the first onboarding step.
@immutable
class LanguageOption {
  const LanguageOption({
    required this.id,
    required this.nativeName,
    required this.englishName,
    required this.monogram,
    this.tag,
  });

  /// BCP-47 code. Persisted in preferences and applied as the app locale.
  final String id;

  /// Name written in the language's own script.
  final String nativeName;

  /// Latin transliteration rendered under [nativeName].
  final String englishName;

  /// Glyph shown inside the leading tile (`म`, `हि`, `EN`).
  final String monogram;

  /// Optional pill rendered next to the title. The reference only tags the
  /// default regional language with `REGIONAL`.
  final String? tag;

  /// Locale applied to the application once this language is chosen.
  Locale get locale => Locale(id);

  /// True when [query] matches the code, the native name or the
  /// transliteration. An empty query matches everything.
  bool matches(String query) {
    final String needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return true;
    }
    return id.toLowerCase().contains(needle) ||
        nativeName.toLowerCase().contains(needle) ||
        englishName.toLowerCase().contains(needle);
  }

  @override
  bool operator ==(Object other) => other is LanguageOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// An access role offered on the second onboarding step.
@immutable
class RoleOption {
  const RoleOption({
    required this.id,
    required this.title,
    required this.bilingualLabel,
    required this.description,
    required this.icon,
  });

  /// Stable identifier persisted in preferences.
  final String id;

  /// Latin heading rendered in caps (`PATIENT`, `ASHA WORKER`, ...).
  final String title;

  /// Marathi / Hindi label rendered inside a pill next to [title]. The district
  /// hospital label carries a line break because the reference wraps it onto
  /// two lines.
  final String bilingualLabel;

  /// Supporting copy clamped to two lines under the heading.
  final String description;

  /// Glyph shown inside the leading tile.
  final IconData icon;

  @override
  bool operator ==(Object other) => other is RoleOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}