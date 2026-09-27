import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/dashboard_detail.dart';
import '../widgets/dashboard_titlebar.dart';

/// A single nearby facility (pharmacy / clinic / hospital).
class NearbyPlace {
  const NearbyPlace({
    required this.name,
    required this.address,
    required this.distance,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

  final String name;
  final String address;
  final String distance;
  final String status;
  final IconData icon;
  final Color iconColor;
}

final List<NearbyPlace> _nearbyPlaces = <NearbyPlace>[
  const NearbyPlace(
    name: 'City Hospital',
    address: '123 Main Road, Gandhi Nagar',
    distance: '0.8 km',
    status: 'Open',
    icon: Icons.local_hospital_rounded,
    iconColor: Color(0xFF4A90D9),
  ),
  const NearbyPlace(
    name: 'MedPlus Pharmacy',
    address: '45 Sector 15, Aurangabad',
    distance: '1.2 km',
    status: 'Open',
    icon: Icons.local_pharmacy_rounded,
    iconColor: Color(0xFF7B5FD4),
  ),
  const NearbyPlace(
    name: 'Sunrise Clinic',
    address: '78 Station Road, near Bus Stand',
    distance: '2.1 km',
    status: 'Closed',
    icon: Icons.medical_services_rounded,
    iconColor: Color(0xFFE05C7A),
  ),
  const NearbyPlace(
    name: 'LifeCare Diagnostics',
    address: '33 Civil Lines, opposite Police Station',
    distance: '3.5 km',
    status: 'Open',
    icon: Icons.science_rounded,
    iconColor: Color(0xFF22C55E),
  ),
  const NearbyPlace(
    name: 'City Hospital Pharmacy',
    address: '101 Hospital Compound, Near Gate',
    distance: '0.5 km',
    status: 'Open',
    icon: Icons.local_pharmacy_rounded,
    iconColor: Color(0xFF7B5FD4),
  ),
];

/// Nearby hospitals / pharmacies / clinics page.
/// Shows a search bar and a vertical scrollable list of nearby places
/// with a slide-in animation for each card.
class NearbyPageScreen extends ConsumerWidget {
  const NearbyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Title bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DashboardTitleBar(
                title: strings.dashboardTileFindNearby,
                subtitle: strings.dashboardTileFindNearbySub,
                onBack: () => context.pop(),
              ),
            ),

            // ── Search bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                height: AppSizes.fieldHeight,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppRadii.fieldAll,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: TextField(
                  style: AppTypography.field,
                  decoration: InputDecoration(
                    hintText: 'Search pharmacies & clinics...',
                    hintStyle: AppTypography.fieldHint,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.muted,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Nearby places list ────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                controller: ScrollController(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _nearbyPlaces.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final NearbyPlace place = _nearbyPlaces[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + index * 120),
                    curve: Curves.easeOutBack,
                    builder: (BuildContext context, double value, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, 24 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: DashboardDetailCard(
                      title: place.name,
                      icon: place.icon,
                      children: <Widget>[
                        DashboardDetailRow(
                          label: 'Address / पत्ता',
                          value: place.address,
                        ),
                        DashboardDetailRow(
                          label: 'Distance / दूरी',
                          value: place.distance,
                        ),
                        DashboardDetailRow(
                          label: 'Status / स्थिती',
                          value: '',
                          trailing: StatusBadge(status: place.status),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
          boxShadow: AppColors.brandGlow,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Opening map...'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.ink,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(28),
            child: const Center(
              child: Icon(
                Icons.map_rounded,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
