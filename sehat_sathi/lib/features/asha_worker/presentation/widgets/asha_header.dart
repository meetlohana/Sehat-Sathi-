import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Top header for the ASHA Worker dashboard.
///
/// Left side: greeting ("Good Morning, Sunita") with a smaller
/// location subtitle ("Ward 4 • Mohalla • Sub-Center 04").
/// Right side: notification bell, more-options icon, and a circular
/// profile avatar.
class AshaDashboardHeader extends StatelessWidget {
  const AshaDashboardHeader({
    super.key,
    required this.greeting,
    required this.location,
    this.onNotificationTap,
    this.onMoreTap,
    this.onProfileTap,
  });

  final String greeting;
  final String location;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ── Left: greeting + location ──────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                greeting,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                location,
                style: AppTypography.ashaGreetingSub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // ── Right: icons ───────────────────────────────────────────
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _HeaderIconButton(
              icon: Icons.notifications_none_rounded,
              onTap: onNotificationTap,
            ),
            const SizedBox(width: 6),
            _HeaderIconButton(
              icon: Icons.more_vert_rounded,
              onTap: onMoreTap,
            ),
            const SizedBox(width: 6),
            // Circular profile avatar
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 22,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Reusable circular icon button used in the header.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Icon(
            icon,
            size: 22,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
