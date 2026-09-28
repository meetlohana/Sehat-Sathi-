import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/asha_models.dart';

/// A tappable quick-action button used in the "Quick Actions" section.
///
/// Three variants are supported via [AshaQuickActionData]:
/// - Blue background (Assist Patient)
/// - Green background (Complete Follow-up)
/// - White / light card (View New Referral)
class AshaQuickActionButton extends StatelessWidget {
  const AshaQuickActionButton({
    super.key,
    required this.data,
  });

  final AshaQuickActionData data;

  @override
  Widget build(BuildContext context) {
    final bool isSolid = data.backgroundColor != AppColors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: AppRadii.cardAll,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: data.backgroundColor,
            borderRadius: AppRadii.cardAll,
            border: Border.all(
              color: isSolid ? data.backgroundColor : AppColors.border,
              width: 1,
            ),
            boxShadow: isSolid ? AppColors.cardShadow : AppColors.cardShadow,
          ),
          child: Row(
            children: <Widget>[
              // Icon tile
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBgColor(data.iconColor, isSolid),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  data.icon,
                  size: 20,
                  color: data.iconColor,
                ),
              ),
              const SizedBox(width: 12),

              // Text block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      data.title,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: isSolid ? AppColors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback:
                            AppTypography.fontFamilyFallback,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        color:
                            isSolid ? AppColors.white.withValues(alpha: 0.85) : AppColors.body,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: isSolid ? AppColors.white : AppColors.body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Background color for the icon tile inside a button.
  Color _iconBgColor(Color iconColor, bool isSolid) {
    if (isSolid) {
      return iconColor.withValues(alpha: 0.2);
    }
    return iconColor.withValues(alpha: 0.1);
  }
}
