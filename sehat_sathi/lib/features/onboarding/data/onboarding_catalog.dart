import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';

/// Static content of the two-step onboarding flow, transcribed from the
/// approved references (`image/Screenshot 2026-09-14 014826.png` and
/// `image/Screenshot 2026-09-14 014943.png`).
abstract final class OnboardingCatalog {
  /// Language pre-selected in the step 1 reference.
  static const String defaultLanguageId = 'mr';

  /// Role pre-selected in the step 2 reference.
  static const String defaultRoleId = 'patient';

  /// Step 1 languages, in reference order.
  static const List<LanguageOption> languages = <LanguageOption>[
    LanguageOption(
      id: 'mr',
      nativeName: 'मराठी',
      englishName: 'Marathi',
      monogram: 'म',
      tag: 'REGIONAL',
    ),
    LanguageOption(
      id: 'hi',
      nativeName: 'हिन्दी',
      englishName: 'Hindi',
      monogram: 'हि',
    ),
    LanguageOption(
      id: 'en',
      nativeName: 'English',
      englishName: 'English',
      monogram: 'EN',
    ),
  ];

  /// Step 2 roles, in reference order. Icons mirror the reference glyphs: a
  /// single person for patients, a crowd for ASHA workers, a clinic building
  /// for PHCs and an institution for district hospitals.
  static const List<RoleOption> roles = <RoleOption>[
    RoleOption(
      id: 'patient',
      title: 'PATIENT',
      bilingualLabel: 'रुग्ण / मरीज',
      description: 'Access digital prescriptions, doctor appointments, lab '
          'results, and personal health records.',
      icon: Icons.person_outline_rounded,
    ),
    RoleOption(
      id: 'asha',
      title: 'ASHA WORKER',
      bilingualLabel: 'आशा सेविका',
      description: 'Field surveys, maternal-child tracking, village health '
          'visits, and immunization drives.',
      icon: Icons.groups_outlined,
    ),
    RoleOption(
      id: 'phc',
      title: 'PHC',
      bilingualLabel: 'प्राथमिक केंद्र',
      description: 'Primary Health Centre medical officers, daily OPD records, '
          'stock supply, and rural reporting.',
      icon: Icons.apartment_outlined,
    ),
    RoleOption(
      id: 'district-hospital',
      title: 'DISTRICT HOSPITAL',
      bilingualLabel: 'जिल्हा\nरुग्णालय',
      description: 'Tertiary care specialists, bed management, emergency '
          'triage, and referral coordination.',
      icon: Icons.account_balance_outlined,
    ),
  ];

  /// Resolves a persisted language code, or `null` when it is unknown.
  static LanguageOption? languageById(String? id) {
    if (id == null) {
      return null;
    }
    for (final LanguageOption option in languages) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
  }

  /// Resolves a persisted role id, or `null` when it is unknown.
  static RoleOption? roleById(String? id) {
    if (id == null) {
      return null;
    }
    for (final RoleOption option in roles) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
  }

  /// Languages matching [query], used by the step 1 search field.
  static List<LanguageOption> searchLanguages(String query) {
    return <LanguageOption>[
      for (final LanguageOption option in languages)
        if (option.matches(query)) option,
    ];
  }
}