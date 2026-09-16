import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/data/onboarding_catalog.dart';
import 'app_locale.dart';
import 'app_strings.dart';
import 'locale_persistence.dart';

/// Single source of truth for the active locale id (`mr` / `hi` / `en`).
///
/// Persisted with [LocalePersistence] so a relaunch restores the choice, and
/// watched by [appLocaleProvider] / [appStringsProvider] so every screen
/// re-renders live the moment a language card is tapped.
/// Set by [main] before `runApp` so the notifier seeds from disk without a
/// provider override (which needs the internal `Override` type).
abstract final class LocaleBoot {
  static String? savedId;
}

class LocaleIdNotifier extends Notifier<String> {
  LocaleIdNotifier([String? initial]) : _initial = initial;

  final String? _initial;

  @override
  String build() => AppLocale.fromId(
        _initial ?? LocaleBoot.savedId ?? OnboardingCatalog.defaultLanguageId,
      ).id;

  void select(String id) {
    state = AppLocale.fromId(id).id;
    LocalePersistence.saveLocaleId(state);
  }
}

final NotifierProvider<LocaleIdNotifier, String> localeIdProvider =
    NotifierProvider<LocaleIdNotifier, String>(LocaleIdNotifier.new);

/// Active [Locale] applied to [MaterialApp.locale].
final Provider<Locale> appLocaleProvider = Provider<Locale>((ref) {
  return Locale(ref.watch(localeIdProvider));
});

/// Localised copy for the watched language. Every onboarding screen watches
/// this, so tapping a card flips all text in the same frame.
final Provider<AppStrings> appStringsProvider = Provider<AppStrings>((ref) {
  return AppStrings.ofId(ref.watch(localeIdProvider));
});
