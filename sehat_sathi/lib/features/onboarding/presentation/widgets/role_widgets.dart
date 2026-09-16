import 'package:flutter/material.dart';

import '../../../../core/i18n/app_locale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/onboarding_models.dart';
import '../widgets/onboarding_chrome.dart';

/// Selectable access-role card from step 2. Text comes from [RoleCopy] so the
/// whole card flips language live; icons + order come from the catalog.
class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.option,
    required this.copy,
    required this.selected,
    required this.onTap,
  });

  final RoleOption option;
  final RoleCopy copy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool twoLineBadge = copy.pill.contains('\n');
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
              Container(
                width: AppSizes.iconTile,
                height: AppSizes.iconTile,
                decoration: const BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                ),
                child: Icon(
                  option.icon,
                  size: AppSizes.cardIcon,
                  color: AppColors.brand,
                ),
              ),
              const SizedBox(width: 12),
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
                            copy.title,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                            copy.pill,
                            style: AppTypography.cardBadge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      copy.description,
                      style: AppTypography.cardSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SelectIndicator(selected: selected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
