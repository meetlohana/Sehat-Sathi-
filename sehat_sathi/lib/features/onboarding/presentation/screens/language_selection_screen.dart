import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../domain/onboarding_models.dart';
import '../providers/onboarding_providers.dart';
import '../widgets/language_widgets.dart';
import '../widgets/onboarding_scaffold.dart';

/// Step 1 of 2 — language selection, transcribed from the approved reference.
class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String query = ref.watch(languageQueryProvider);
    final String selectedId = ref.watch(localeIdProvider);
    final AppStrings strings = ref.watch(appStringsProvider);
    final List<LanguageOption> languages =
        ref.watch(filteredLanguagesProvider);

    String emptyText(String query) {
      switch (AppLocale.fromId(selectedId)) {
        case AppLocale.hindi:
          return '"$query" से कोई भाषा नहीं मिली।';
        case AppLocale.english:
          return 'No language matches "$query".';
        case AppLocale.marathi:
          return '"$query" साठी कोणतीही भाषा सापडली नाही.';
      }
    }

    return OnboardingScaffold(
      showBack: false,
      buttonLabel: strings.continueButton,
      footerCaption: strings.footerStep1,
      onContinue: () => context.push(AppRoutes.role),
      children: <Widget>[
        OnboardingHeader(
          stepLabel: strings.stepLabel1,
          title: strings.selectLanguageTitle,
          bilingualSubtitle: strings.selectLanguageSubtitle,
          description: strings.selectLanguageDescription,
        ),
        const SizedBox(height: AppSpacing.search),
        LanguageSearchField(
          controller: _searchController,
          hintText: strings.searchHint,
          onChanged: (String value) =>
              ref.read(languageQueryProvider.notifier).state = value,
        ),
        const SizedBox(height: AppSpacing.control),
        if (languages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              emptyText(query),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          for (int i = 0; i < languages.length; i++) ...<Widget>[
            LanguageCard(
              option: languages[i],
              selected: languages[i].id == selectedId,
              onTap: () =>
                  ref.read(localeIdProvider.notifier).select(languages[i].id),
            ),
            if (i != languages.length - 1)
              const SizedBox(height: AppSpacing.cardGap),
          ],
      ],
    );
  }
}
