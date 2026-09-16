import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Detail card matching `_detail.png` reference pattern.
/// Shows a labeled detail section with icon, title, and expandable content.
class DashboardDetailCard extends StatelessWidget {
  const DashboardDetailCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.showIndicator = true,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool showIndicator;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header row
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.brand.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: AppColors.brand,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (showIndicator)
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: AppColors.muted,
                    ),
                ],
              ),
              // Divider
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: AppColors.border,
              ),
              const SizedBox(height: 12),
              // Content rows
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// A single detail row within a DashboardDetailCard.
class DashboardDetailRow extends StatelessWidget {
  const DashboardDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.trailing,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: AppTypography.footerCaption.copyWith(
                color: AppColors.muted,
              ),
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 8),
            trailing!,
          ] else ...<Widget>[
            const SizedBox(width: 8),
            Expanded(
              flex: 7,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: valueStyle ?? AppTypography.bodyCopy,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Status badge for health records (e.g., "Completed", "Pending").
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.showBorder = true,
  });

  final String status;
  final bool showBorder;

  Color get _color {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
      case 'normal':
        return const Color(0xFF16A34A);
      case 'pending':
      case 'awaiting':
        return const Color(0xFFD97706);
      case 'cancelled':
      case 'expired':
        return const Color(0xFFDC2626);
      default:
        return AppColors.brand;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: showBorder ? Border.all(color: _color.withValues(alpha: 0.3)) : null,
      ),
      child: Text(
        status,
        style: AppTypography.cardBadge.copyWith(
          fontSize: 10,
          color: _color,
        ),
      ),
    );
  }
}
