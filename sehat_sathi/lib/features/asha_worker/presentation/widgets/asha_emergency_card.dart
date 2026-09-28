import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Light-red emergency alert card shown after the statistics grid.
///
/// Contains a header row ("Emergency Alerts" + red badge), an alert
/// item description, and a prominent red button.
class AshaEmergencyAlertCard extends StatelessWidget {
  const AshaEmergencyAlertCard({
    super.key,
    this.alertCount = 2,
    this.alertText = const <String>[
      'Ka... Sharma (Severe respiratory distress) & '
          'Ramesh K. (High glucose)',
    ],
    this.onTap,
  });

  final int alertCount;
  final List<String> alertText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emergencyLight,
        borderRadius: AppRadii.cardAll,
        border: Border.all(
          color: AppColors.emergencyRed.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row: "Emergency Alerts" + badge
          Row(
            children: <Widget>[
              const Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: AppColors.emergencyRed,
              ),
              const SizedBox(width: 8),
              const Text(
                'Emergency Alerts',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              // Red badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emergencyRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$alertCount Alerts',
                  style: AppTypography.badge.copyWith(
                    fontSize: 10,
                    color: AppColors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Alert item text
          Text(
            alertText.join('\n'),
            style: AppTypography.ashaEmergencyText,
          ),
          const SizedBox(height: 12),

          // Prominent red button
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              borderRadius: AppRadii.buttonAll,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadii.buttonAll,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: const BoxDecoration(
                    color: AppColors.emergencyRed,
                    borderRadius: AppRadii.buttonAll,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 18,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'View Emergency Alerts ($alertCount)',
                        style: AppTypography.buttonLabel.copyWith(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
