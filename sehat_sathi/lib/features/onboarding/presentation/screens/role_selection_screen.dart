import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_locale.dart';
import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/onboarding_catalog.dart';
import '../providers/onboarding_providers.dart';

/// Step 2 of 2 – Select Your Role.
/// Matches image/select your role.png exactly.
/// All text comes from [AppStrings] so it flips language live;
/// icons and IDs come from [OnboardingCatalog.roles].
class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String selectedId = ref.watch(selectedRoleProvider);
    final String languageId = ref.watch(localeIdProvider);
    final AppStrings strings = ref.watch(appStringsProvider);
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // ── Back button ──────────────────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _BackButton(onPressed: () => context.pop()),
                    ),
                    const SizedBox(height: 16),

                    // ── Header block ─────────────────────────────────────────
                    Text(
                      strings.selectRoleHeader,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.24,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.selectRoleSubtitle,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brand,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.selectRoleDescription,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                        color: AppColors.body,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Role cards ───────────────────────────────────────────
                    ...List<Widget>.generate(
                      OnboardingCatalog.roles.length,
                      (int index) {
                        final role = OnboardingCatalog.roles[index];
                        final RoleCopy copy = strings.roles[index];
                        final bool isSelected = selectedId == role.id;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < OnboardingCatalog.roles.length - 1
                                ? 12
                                : 0,
                          ),
                          child: _RoleCard(
                            id: role.id,
                            icon: role.icon,
                            title: copy.title,
                            pill: copy.pill,
                            description: copy.description,
                            selected: isSelected,
                            onTap: () => ref
                                .read(selectedRoleProvider.notifier)
                                .state = role.id,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── Sticky footer ────────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: AppColors.footer,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                10 + bottomInset,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Gradient continue button
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: AppRadii.buttonAll,
                      boxShadow: AppColors.brandGlow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppRadii.buttonAll,
                      child: InkWell(
                        onTap: () => context.push(
                          '${AppRoutes.done}?language=$languageId&role=$selectedId',
                        ),
                        borderRadius: AppRadii.buttonAll,
                        child: SizedBox(
                          height: 54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  strings.continueButton,
                                  style: AppTypography.buttonLabel,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    strings.footerStep2,
                    style: AppTypography.footerCaption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.indicator.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Back button
// ─────────────────────────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 24,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Role card — matches the reference exactly
// ─────────────────────────────────────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.id,
    required this.icon,
    required this.title,
    required this.pill,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final String title;
  final String pill;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool twoLineBadge = pill.contains('\n');
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.selectedTint : AppColors.white,
            borderRadius: AppRadii.cardAll,
            border: Border.all(
              color: selected ? AppColors.brand : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow:
                selected ? AppColors.selectedCardShadow : AppColors.cardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icon tile
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                ),
                child: Icon(icon, size: 22, color: AppColors.brand),
              ),
              const SizedBox(width: 12),
              // Text block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: twoLineBadge
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontFamilyFallback: AppTypography.fontFamilyFallback,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Bilingual pill badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.badge,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pill,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontFamilyFallback: AppTypography.fontFamilyFallback,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brand,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        color: AppColors.body,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Radio indicator
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.brand : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.brand : AppColors.indicator,
                      width: selected ? 0 : 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded, size: 14, color: AppColors.white)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
