import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/i18n/i18n.dart';
import '../../data/onboarding_catalog.dart';
import '../../domain/onboarding_models.dart';

/// Search text typed into the step-1 search field.
final StateProvider<String> languageQueryProvider =
    StateProvider<String>((ref) => '');

/// Deprecated alias: the single source of truth is now `localeIdProvider`.
/// Kept so existing watchers keep compiling during migration.
final Provider<String> selectedLanguageProvider = Provider<String>((ref) {
  return ref.watch(localeIdProvider);
});

/// Role highlighted on step 2 — `patient`, like the reference.
final StateProvider<String> selectedRoleProvider =
    StateProvider<String>((ref) => OnboardingCatalog.defaultRoleId);

/// Languages filtered by [languageQueryProvider], preserving order.
final Provider<List<LanguageOption>> filteredLanguagesProvider =
    Provider<List<LanguageOption>>((ref) {
  final String query = ref.watch(languageQueryProvider);
  return OnboardingCatalog.searchLanguages(query);
});
