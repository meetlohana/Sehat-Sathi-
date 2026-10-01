import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';


/// ABHA / Health ID login tab body.
/// Matches image/Health.ID.png exactly:
/// – Selected role card (PATIENT)
/// – ABHA Number field
/// – Security PIN field
/// – "नवीन ABHA तयार करा?" and "पिन विसरलात?" links
/// – ASHA / PHC info card
/// – 256-bit encrypted trust row
/// – "ABHA सह लॉगिन करा" gradient footer button
class AbhaHealthIdCard extends ConsumerStatefulWidget {
  const AbhaHealthIdCard({super.key, required this.mobileNumber});
  final String mobileNumber;

  @override
  ConsumerState<AbhaHealthIdCard> createState() => _AbhaHealthIdCardState();
}

class _AbhaHealthIdCardState extends ConsumerState<AbhaHealthIdCard> {
  final TextEditingController _abhaController = TextEditingController(
    text: '',
  );
  final TextEditingController _pinController = TextEditingController();
  bool _showPin = false;

  @override
  void dispose() {
    _abhaController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = ref.watch(appStringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // ── Selected Role card ────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.selectedTint,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.brand, width: 1.5),
            boxShadow: AppColors.selectedCardShadow,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                ),
                child: const Icon(Icons.person_outline_rounded,
                    size: 22, color: AppColors.brand),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          strings.loginRoleTitle,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontFamilyFallback: AppTypography.fontFamilyFallback,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        const SizedBox(width: 6),
                        Text(
                          strings.loginRolePill,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontFamilyFallback: AppTypography.fontFamilyFallback,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.brand,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _SmallBadge(label: strings.loginSelectedRoleBadge),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.loginStepLine,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  strings.loginChangeLabel,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brand,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── ABHA Number field ─────────────────────────────────────────────
        _FieldLabel(label: strings.abhaNumberLabel),
        const SizedBox(height: 6),
        _AbhaTextField(
          controller: _abhaController,
          hintText: strings.abhaNumberHint,
        ),
        const SizedBox(height: 4),
        Text(
          strings.abhaVerifiedLabel,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontFamilyFallback: AppTypography.fontFamilyFallback,
            fontSize: 10.5,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 18),

        // ── Security PIN field ────────────────────────────────────────────
        _FieldLabel(label: strings.abhaPinLabel),
        const SizedBox(height: 6),
        _PinTextField(
          controller: _pinController,
          obscure: !_showPin,
          onToggle: () => setState(() => _showPin = !_showPin),
          showLabel: strings.abhaShowLabel,
          hideLabel: strings.abhaHideLabel,
        ),
        const SizedBox(height: 10),

        // ── नवीन ABHA / पिन विसरलात? ─────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Text(
                strings.abhaCreateNew,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.brand,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                strings.abhaForgotPin,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.brand,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── ASHA / PHC info card ──────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.tile,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.brand),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      strings.abhaAsaTitle,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.abhaAsaDesc,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 11.5,
                        color: AppColors.body,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Trust row ─────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.muted),
            const SizedBox(width: 6),
            Text(
              strings.loginTrustRow,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontFamilyFallback: AppTypography.fontFamilyFallback,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontFamilyFallback: AppTypography.fontFamilyFallback,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF16A34A),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontFamilyFallback: AppTypography.fontFamilyFallback,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }
}

class _AbhaTextField extends StatelessWidget {
  const _AbhaTextField({required this.controller, required this.hintText});
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.fieldAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontFamilyFallback: AppTypography.fontFamilyFallback,
          fontSize: 14,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontFamilyFallback: AppTypography.fontFamilyFallback,
            fontSize: 13,
            color: AppColors.muted,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _PinTextField extends StatelessWidget {
  const _PinTextField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.showLabel,
    required this.hideLabel,
  });
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String showLabel;
  final String hideLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.fieldAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontFamilyFallback: AppTypography.fontFamilyFallback,
                fontSize: 14,
                color: AppColors.ink,
                letterSpacing: 4,
              ),
              decoration: const InputDecoration(
                hintText: '••••••••',
                hintStyle: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 14,
                  color: AppColors.muted,
                  letterSpacing: 2,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                obscure ? showLabel : hideLabel,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
