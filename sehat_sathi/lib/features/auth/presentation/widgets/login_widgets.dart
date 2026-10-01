import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/widgets/onboarding_chrome.dart';
import '../../../onboarding/presentation/widgets/onboarding_scaffold.dart';

/// Top chrome of the login page: circular back chevron on the left and the
/// `मराठी / EN` language pill on the right.
class LoginTopBar extends StatelessWidget {
  const LoginTopBar({
    super.key,
    required this.languageLabel,
    this.onBack,
    this.onLanguageTap,
  });

  final String languageLabel;
  final VoidCallback? onBack;
  final VoidCallback? onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        OnboardingBackButton(onPressed: onBack),
        const Spacer(),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onLanguageTap,
            borderRadius: AppRadii.chipAll,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.badge,
                borderRadius: AppRadii.chipAll,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(languageLabel, style: AppTypography.cardBadge),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: AppColors.brand,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Brand portal pill shown above the headline.
class LoginPortalBadge extends StatelessWidget {
  const LoginPortalBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.badge,
        borderRadius: AppRadii.chipAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.circle, size: 7, color: AppColors.brand),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.badge),
        ],
      ),
    );
  }
}

/// Headline block: badge + title + bilingual subtitle + description.
class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.badgeLabel,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final String badgeLabel;
  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LoginPortalBadge(label: badgeLabel),
        const SizedBox(height: AppSpacing.md),
        Text(title, style: AppTypography.screenTitle),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTypography.bilingualSubtitle),
        const SizedBox(height: 6),
        Text(description, style: AppTypography.bodyCopy),
      ],
    );
  }
}

/// `मोबाईल OTP (Phone)` / `ABHA / Health ID` segmented method chooser.
class LoginMethodTabs extends StatelessWidget {
  const LoginMethodTabs({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _MethodTab(
            icon: Icons.smartphone_rounded,
            label: labels[0],
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MethodTab(
            icon: Icons.shield_outlined,
            label: labels[1],
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }
}

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.white : AppColors.tile,
      borderRadius: AppRadii.chipAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.chipAll,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: AppRadii.chipAll,
            border: selected
                ? Border.all(color: AppColors.brand, width: 1.2)
                : Border.all(color: Colors.transparent),
            boxShadow: selected ? AppColors.cardShadow : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.brand : AppColors.body,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.ink : AppColors.body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selected-role summary card (`PATIENT • रुग्ण`, changeable).
class SelectedRoleCard extends StatelessWidget {
  const SelectedRoleCard({
    super.key,
    required this.roleTitle,
    required this.rolePill,
    required this.stepLine,
    required this.selectedLabel,
    required this.changeLabel,
    this.onChange,
  });

  final String roleTitle;
  final String rolePill;
  final String stepLine;
  final String selectedLabel;
  final String changeLabel;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.tile,
        borderRadius: AppRadii.fieldAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: AppSizes.leadingTile,
            height: AppSizes.leadingTile,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.tile),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 22,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        roleTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontFamilyFallback: AppTypography.fontFamilyFallback,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('• $rolePill', style: AppTypography.cardBadge),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  stepLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                selectedLabel,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onChange,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      changeLabel,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section label with optional trailing action (e.g. the resend link).
class LoginFieldLabel extends StatelessWidget {
  const LoginFieldLabel({
    super.key,
    required this.label,
    required this.trailingLabel,
    this.onTrailingTap,
  });

  final String label;
  final String trailingLabel;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontFamilyFallback: AppTypography.fontFamilyFallback,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTrailingTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                trailingLabel,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// `+91` prefixed mobile number field.
class PhoneField extends StatelessWidget {
  const PhoneField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.fieldAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          const Text('🇮🇳', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          const Text(
            '+91',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontFamilyFallback: AppTypography.fontFamilyFallback,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: AppSizes.hairline,
            height: 22,
            color: AppColors.borderStrong,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: AppTypography.field,
              cursorColor: AppColors.brand,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The six OTP entry boxes; filled boxes draw the brand border.
class OtpBoxes extends StatelessWidget {
  const OtpBoxes({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(6, (int i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == 5 ? 0 : AppSpacing.sm),
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppRadii.fieldAll,
              border: Border.all(
                color: controllers[i].text.isNotEmpty
                    ? AppColors.brand
                    : AppColors.borderStrong,
                width: controllers[i].text.isNotEmpty ? 1.4 : 1,
              ),
            ),
            child: TextField(
              controller: controllers[i],
              focusNode: focusNodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontFamilyFallback: AppTypography.fontFamilyFallback,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
              cursorColor: AppColors.brand,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '·',
                hintStyle: TextStyle(color: AppColors.muted),
              ),
              onChanged: (String value) => onChanged(i, value),
            ),
          ),
        );
      }),
    );
  }
}

/// Remember-me checkbox with the forgot-password link on the right.
class RememberRow extends StatelessWidget {
  const RememberRow({
    super.key,
    required this.label,
    required this.forgotLabel,
    required this.value,
    required this.onChanged,
    this.onForgotTap,
  });

  final String label;
  final String forgotLabel;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onForgotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.brand : AppColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.brand : AppColors.indicator,
                width: 1.4,
              ),
            ),
            child: value
                ? const Icon(Icons.check_rounded, size: 14, color: AppColors.white)
                : null,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontFamilyFallback: AppTypography.fontFamilyFallback,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.body,
          ),
        ),
        const Spacer(),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onForgotTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                forgotLabel,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ASHA worker / PHC staff partnership info card.
class AshaInfoCard extends StatelessWidget {
  const AshaInfoCard({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.tile,
        borderRadius: AppRadii.fieldAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 17,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `256-Bit Encrypted • ABDM HIPAA Standards` trust line.
class TrustRow extends StatelessWidget {
  const TrustRow({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.lock_outline_rounded, size: 13, color: AppColors.muted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontFamilyFallback: AppTypography.fontFamilyFallback,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

/// Sticky footer panel: gradient CTA, register caption with link and the
/// home-indicator bar — matching the onboarding footer exactly.
class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
    required this.buttonLabel,
    required this.captionPrefix,
    required this.captionLink,
    required this.onContinue,
    this.isBusy = false,
    this.onRegisterTap,
  });

  final String buttonLabel;
  final String captionPrefix;
  final String captionLink;
  final VoidCallback onContinue;
  final bool isBusy;
  final VoidCallback? onRegisterTap;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.footer,
        border: Border(top: BorderSide(color: AppColors.border)),
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
          Stack(
            children: <Widget>[
              ContinueButton(
                label: buttonLabel,
                onPressed: isBusy ? () {} : onContinue,
              ),
              if (isBusy)
                const Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: captionPrefix,
              style: AppTypography.footerCaption,
              children: <InlineSpan>[
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: onRegisterTap,
                    child: Text(
                      captionLink,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brand,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
    );
  }
}
