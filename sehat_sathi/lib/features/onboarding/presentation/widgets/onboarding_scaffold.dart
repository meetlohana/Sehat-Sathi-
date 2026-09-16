import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import 'onboarding_chrome.dart';

/// Eyebrow + headline + bilingual subtitle + supporting copy.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.bilingualSubtitle,
    required this.description,
  });

  final String stepLabel;
  final String title;
  final String bilingualSubtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(stepLabel, style: AppTypography.stepLabel),
        const SizedBox(height: 4),
        Text(title, style: AppTypography.screenTitle),
        const SizedBox(height: 4),
        Text(bilingualSubtitle, style: AppTypography.bilingualSubtitle),
        const SizedBox(height: 6),
        Text(description, style: AppTypography.bodyCopy),
      ],
    );
  }
}

/// Shared page chrome: scrollable body plus a sticky footer panel that holds
/// the gradient CTA, the caption underneath it and the home indicator bar.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.children,
    required this.buttonLabel,
    required this.footerCaption,
    required this.onContinue,
    this.showBack = true,
    this.onBack,
  });

  final List<Widget> children;
  final String buttonLabel;
  final String footerCaption;
  final VoidCallback onContinue;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.sm,
                  AppSpacing.page,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OnboardingBackButton(onPressed: onBack),
                      ),
                    if (showBack) const SizedBox(height: 12),
                    ...children,
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.footer,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.footer,
                AppSpacing.lg,
                AppSpacing.footer,
                10 + bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ContinueButton(label: buttonLabel, onPressed: onContinue),
                  const SizedBox(height: 10),
                  Text(
                    footerCaption,
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

/// Full-width gradient CTA with a trailing arrow, as in both references.
class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: AppRadii.buttonAll,
        boxShadow: AppColors.brandGlow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.buttonAll,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadii.buttonAll,
          child: SizedBox(
            height: AppSizes.buttonHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    label,
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
    );
  }
}
