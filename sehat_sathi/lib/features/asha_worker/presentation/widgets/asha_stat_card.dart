import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/asha_models.dart';

/// A single statistic card used in the ASHA Worker dashboard 2×2 grid.
///
/// Displays an icon tile, a bold number, a subtitle and a small
/// supporting line of text.
class AshaStatCard extends StatelessWidget {
  const AshaStatCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final AshaStatCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Icon tile
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  data.icon,
                  size: 18,
                  color: data.iconColor,
                ),
              ),
              const SizedBox(height: 10),

              // Bold number
              Text(
                data.number,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                data.subtitle,
                style: AppTypography.ashaStatSub,
              ),
              const SizedBox(height: 2),

              // Supporting text
              Text(
                data.supportingText,
                style: AppTypography.ashaStatSupporting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2×2 grid of four [AshaStatCard]s.
class AshaStatCardGrid extends StatelessWidget {
  const AshaStatCardGrid({
    super.key,
    required this.cards,
    this.onCardTap,
  });

  final List<AshaStatCardData> cards;
  final ValueChanged<int>? onCardTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: List<Widget>.generate(cards.length, (int index) {
        final AshaStatCardData data = cards[index];
        return AshaStatCard(
          data: data,
          onTap: onCardTap == null ? null : () => onCardTap!(index),
        );
      }),
    );
  }
}
