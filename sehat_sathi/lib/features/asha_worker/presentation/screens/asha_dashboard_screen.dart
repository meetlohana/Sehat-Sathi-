import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/asha_models.dart';
import '../widgets/asha_bottom_nav_bar.dart';
import '../widgets/asha_emergency_card.dart';
import '../widgets/asha_focus_card.dart';
import '../widgets/asha_header.dart';
import '../widgets/asha_quick_action_button.dart';
import '../widgets/asha_search_bar.dart';
import '../widgets/asha_stat_card.dart';

/// ASHA Worker Home / Dashboard screen.
///
/// Layout (top → bottom), matching the reference image exactly:
///   1. Top header — greeting + location / bell + more + profile
///   2. Search bar — full-width, rounded
///   3. Today's Focus — compact field-schedule card
///   4. Online Status — small sync indicator
///   5. Four statistics cards in a 2×2 grid
///   6. Emergency Alert card (light red)
///   7. Quick Actions — three stacked buttons
///   8. Bottom navigation bar (Home • Patients • Tasks • Referrals • Profile)
class AshaDashboardScreen extends StatefulWidget {
  const AshaDashboardScreen({super.key});

  @override
  State<AshaDashboardScreen> createState() => _AshaDashboardScreenState();
}

class _AshaDashboardScreenState extends State<AshaDashboardScreen> {
  int _selectedNav = 0;

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            // ── Scrollable content ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 1. Header
                    const AshaDashboardHeader(
                      greeting: AshaDashboardCatalog.greeting,
                      location: AshaDashboardCatalog.location,
                    ),
                    const SizedBox(height: 16),

                    // 2. Search bar
                    const AshaSearchBar(),
                    const SizedBox(height: 20),

                    // 3. Today's Focus + Field Schedule card
                    AshaFocusScheduleCard(
                      title: AshaDashboardCatalog.scheduleTitle,
                      location: AshaDashboardCatalog.scheduleLocation,
                      onTap: () => _showSnack('Field Schedule tapped'),
                    ),
                    const SizedBox(height: 12),

                    // 4. Online Status
                    const AshaOnlineStatus(),
                    const SizedBox(height: 20),

                    // 5. Statistics cards (2×2 grid)
                    AshaStatCardGrid(
                      cards: AshaDashboardCatalog.statCards,
                      onCardTap: (int index) {
                        final AshaStatCardData card =
                            AshaDashboardCatalog.statCards[index];
                        _showSnack('${card.title} tapped');
                      },
                    ),
                    const SizedBox(height: 20),

                    // 6. Emergency Alert card
                    AshaEmergencyAlertCard(
                      alertCount: 2,
                      onTap: () => _showSnack('Emergency Alerts tapped'),
                    ),
                    const SizedBox(height: 24),

                    // 7. Quick Actions
                    const _QuickActionsSection(),
                  ],
                ),
              ),
            ),

            // 8. Bottom navigation bar
            AshaBottomNavBar(
              items: AshaDashboardCatalog.navItems,
              selectedIndex: _selectedNav,
              onTap: (int index) {
                if (index == 4) {
                  // Profile
                  _showSnack('Profile tapped');
                } else {
                  setState(() => _selectedNav = index);
                  _showSnack('${AshaDashboardCatalog.navItems[index].label} tapped');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Section wrapper for the three quick-action buttons.
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Section heading
        const Text(
          'Quick Actions',
          style: AppTypography.ashaSectionHeading,
        ),
        const SizedBox(height: 4),
        // Subtitle
        const Text(
          'Tap to initiate fast field entries',
          style: AppTypography.ashaSectionSub,
        ),
        const SizedBox(height: 16),
        // Three stacked action buttons
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AshaDashboardCatalog.quickActions.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 12),
          itemBuilder: (BuildContext context, int index) {
            final AshaQuickActionData data =
                AshaDashboardCatalog.quickActions[index];
            return AshaQuickActionButton(
              data: data.copyWith(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${data.title} tapped'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.textPrimary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
