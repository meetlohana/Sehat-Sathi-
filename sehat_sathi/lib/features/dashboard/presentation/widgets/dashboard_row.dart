import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// A dashboard content row matching `_row1.png` through `_row4.png` patterns.
class DashboardRow extends StatelessWidget {
  const DashboardRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.showChevron = true,
    this.onTap,
    this.backgroundColor = AppColors.white,
    this.leftLabel,
    this.rightLabel,
    this.isSelected = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final String? leftLabel;
  final String? rightLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadii.cardAll,
            border: Border.all(
              color: isSelected ? AppColors.brand : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? AppColors.selectedCardShadow : AppColors.cardShadow,
          ),
          child: Row(
            children: <Widget>[
              if (leftLabel != null) ...<Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    leftLabel!,
                    style: AppTypography.badge.copyWith(
                      fontSize: 9,
                      color: AppColors.brand,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Container(
                width: AppSizes.iconTile,
                height: AppSizes.iconTile,
                decoration: BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  icon,
                  size: AppSizes.cardIcon,
                  color: AppColors.brand,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 15,
                        color: isSelected ? AppColors.brand : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.cardSubtitle.copyWith(
                        color: AppColors.body,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (rightLabel != null) ...<Widget>[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.badge,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rightLabel!,
                    style: AppTypography.cardBadge.copyWith(
                      fontSize: 10.5,
                    ),
                  ),
                ),
              ],
              if (trailing != null) ...<Widget>[
                const SizedBox(width: 8),
                trailing!,
              ],
              if (showChevron) ...<Widget>[
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.muted,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
