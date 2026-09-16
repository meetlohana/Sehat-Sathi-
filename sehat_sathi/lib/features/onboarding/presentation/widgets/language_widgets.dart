import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/onboarding_models.dart';
import '../widgets/onboarding_chrome.dart';

/// Search field from step 1: rounded outline with a leading search glyph and
/// a localised hint.
class LanguageSearchField extends StatelessWidget {
  const LanguageSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: AppTypography.field,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.fieldHint.copyWith(fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.muted,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 46,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadii.fieldAll,
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppRadii.fieldAll,
            borderSide: BorderSide(color: AppColors.brand, width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// Selectable language row from step 1.
class LanguageCard extends StatelessWidget {
  const LanguageCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            children: <Widget>[
              Container(
                width: AppSizes.leadingTile,
                height: AppSizes.leadingTile,
                decoration: BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  option.monogram,
                  style: AppTypography.tileMonogram,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            option.nativeName,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (option.tag != null) ...<Widget>[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.badge,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.brand.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              option.tag!,
                              style: AppTypography.badge.copyWith(
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.englishName,
                      style: AppTypography.transliteration,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SelectIndicator(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}
