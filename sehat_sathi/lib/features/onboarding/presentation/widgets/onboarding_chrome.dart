import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// Circular outline back chevron used at the top-left of both steps.
class OnboardingBackButton extends StatelessWidget {
  const OnboardingBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
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
    );
  }
}

/// Right-hand radio indicator: filled blue circle with a white check when
/// selected, hairline outline circle otherwise.
class SelectIndicator extends StatelessWidget {
  const SelectIndicator({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        width: AppSizes.radio,
        height: AppSizes.radio,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.brandGradient,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 14,
          color: AppColors.white,
        ),
      );
    }
    return Container(
      width: AppSizes.radio,
      height: AppSizes.radio,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.indicator, width: 1.5),
      ),
    );
  }
}
