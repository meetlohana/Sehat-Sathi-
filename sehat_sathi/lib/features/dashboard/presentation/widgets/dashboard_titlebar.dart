import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Title bar matching `_titlebar.png` reference pattern.
/// Shows screen title with optional back navigation and a progress indicator.
class DashboardTitleBar extends StatelessWidget {
  const DashboardTitleBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.onBack,
    this.stepLabel,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final String? stepLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showBack) ...<Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              borderRadius: BorderRadius.circular(AppSizes.backButton),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(color: AppColors.borderStrong),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (stepLabel != null) ...<Widget>[
          Text(stepLabel!, style: AppTypography.stepLabel),
          const SizedBox(height: 4),
        ],
        Text(title, style: AppTypography.screenTitle),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: AppTypography.bilingualSubtitle,
          ),
        ],
      ],
    );
  }
}

/// Sticky bottom bar matching the onboarding footer pattern.
/// Shows continue button, caption, and home indicator bar.
class DashboardFooter extends StatelessWidget {
  const DashboardFooter({
    super.key,
    required this.buttonLabel,
    required this.caption,
    required this.onContinue,
    this.showIndicator = true,
  });

  final String buttonLabel;
  final String caption;
  final VoidCallback onContinue;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
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
                onTap: onContinue,
                borderRadius: AppRadii.buttonAll,
                child: SizedBox(
                  height: AppSizes.buttonHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          buttonLabel,
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
            caption,
            style: AppTypography.footerCaption,
            textAlign: TextAlign.center,
          ),
          if (showIndicator) ...<Widget>[
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
        ],
      ),
    );
  }
}
