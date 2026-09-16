import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Header card displaying logged-in user information.
/// Matches the `_header.png` reference pattern: user avatar, name, role badge,
/// and mobile number in a compact card at the top of the dashboard.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.fullName,
    required this.role,
    required this.mobileNumber,
    required this.healthIdNumber,
  });

  final String fullName;
  final String role;
  final String mobileNumber;
  final String healthIdNumber;

  @override
  Widget build(BuildContext context) {
    final bool isPatient = role == 'patient';
    final String roleDisplay = isPatient ? 'रुग्ण / Patient' : 'वैद्यकीय कार्यकर्ता / Medical Staff';
    final String roleBadge = isPatient ? 'PATIENT' : 'STAFF';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: <Widget>[
          // Avatar circle
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 14),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  fullName,
                  style: AppTypography.cardTitle.copyWith(fontSize: 17),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.badge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$roleBadge • $roleDisplay',
                    style: AppTypography.cardBadge.copyWith(
                      fontSize: 10,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.phone_android_outlined,
                      size: 14,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+91 $mobileNumber',
                      style: AppTypography.bodyCopy.copyWith(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.fingerprint_outlined,
                      size: 14,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      healthIdNumber,
                      style: AppTypography.bodyCopy.copyWith(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // More options icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.brand,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
