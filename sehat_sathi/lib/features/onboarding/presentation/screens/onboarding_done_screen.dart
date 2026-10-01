import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/onboarding_catalog.dart';
import '../widgets/onboarding_scaffold.dart';

/// Placeholder destination reached after both steps complete. It echoes the
/// persisted choices so QA can verify the wiring before the home module
/// lands. All copy follows the persisted language live.
class OnboardingDoneScreen extends ConsumerWidget {
  const OnboardingDoneScreen({
    super.key,
    required this.languageId,
    required this.roleId,
  });

  final String languageId;
  final String roleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final String activeLanguageId = ref.watch(localeIdProvider);
    final String effectiveLanguageId =
        OnboardingCatalog.languageById(languageId) == null
            ? activeLanguageId
            : languageId;
    final language = OnboardingCatalog.languageById(effectiveLanguageId);
    final role = OnboardingCatalog.roleById(roleId);
    final int roleIndex = OnboardingCatalog.roles.indexWhere(
      (element) => element.id == (role?.id ?? roleId),
    );
    final String roleName = roleIndex >= 0
        ? strings.roles[roleIndex].title
        : (role?.title ?? roleId);
    return OnboardingScaffold(
      buttonLabel: strings.doneButton,
      footerCaption: strings.doneCaption,
      onContinue: () => context.push(AppRoutes.login),
      onBack: () => Navigator.of(context).maybePop(),
      children: <Widget>[
        OnboardingHeader(
          stepLabel: strings.doneEyebrow,
          title: strings.doneTitle,
          bilingualSubtitle: strings.doneSubtitle,
          description: strings.doneDescription,
        ),
        const SizedBox(height: AppSpacing.header),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${strings.languageLabel}: ${language?.nativeName ?? effectiveLanguageId}',
                style: AppTypography.cardTitle,
              ),
              const SizedBox(height: 4),
              Text(
                '${strings.roleLabel}: $roleName',
                style: AppTypography.bodyCopy,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
