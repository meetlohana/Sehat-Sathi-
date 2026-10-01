import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/asha_models.dart';

/// Fixed bottom navigation bar for the ASHA Worker dashboard.
///
/// Five items: Home (selected by default), Patients, Tasks,
/// Referrals, Profile.  Uses blue for the active icon/label
/// and neutral gray for inactive items.
class AshaBottomNavBar extends StatelessWidget {
  const AshaBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onTap,
  });

  final List<AshaNavItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(items.length, (int index) {
              final bool active = selectedIndex == index;
              final AshaNavItem item = items[index];
              return GestureDetector(
                onTap: onTap == null ? null : () => onTap!(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      item.icon,
                      size: 24,
                      color: active
                          ? AppColors.primaryBlue
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: AppTypography.ashaNavLabel.copyWith(
                        color: active
                            ? AppColors.primaryBlue
                            : AppColors.textSecondary,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
