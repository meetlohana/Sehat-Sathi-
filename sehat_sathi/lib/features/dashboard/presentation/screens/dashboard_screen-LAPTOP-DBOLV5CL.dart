import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/data/user_health_repository.dart';
import '../providers/dashboard_providers.dart';

/// Home Page (Dashboard) — matches image/Home_Page.png exactly.
///
/// Layout (top → bottom):
///   1. Top bar: "Sehat Sathi" logo text + notification bell with red dot + "ME" avatar
///   2. Subtitle: "How are you feeling today?"
///   3. 2×3 grid of quick-action tiles (white cards with icon + label + sub-label)
///   4. "TODAY'S APPOINTMENT" card (blue pill, time, doctor details, Join button)
///   5. Bottom nav bar: Home / Care / Health / Schedule / Profile
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DashboardUser> userAsync = ref.watch(dashboardUserProvider);
    final AppStrings strings = ref.watch(appStringsProvider);

    return userAsync.when(
      loading: () => const _Loading(),
      error: (Object error, StackTrace stack) => _Error(
        strings: strings,
        onRetry: () => ref.read(dashboardUserProvider.notifier).refresh(),
        onLogout: () async {
          await ref.read(dashboardUserProvider.notifier).logout();
          if (context.mounted) context.go(AppRoutes.login);
        },
      ),
      data: (DashboardUser user) => _HomeContent(
        user: user,
        strings: strings,
        onLogout: () async {
          await ref.read(dashboardUserProvider.notifier).logout();
          if (context.mounted) context.go(AppRoutes.login);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading / Error states
// ─────────────────────────────────────────────────────────────────────────────
class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFEEF3FB),
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.brand,
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.strings, required this.onRetry, required this.onLogout});
  final AppStrings strings;
  final VoidCallback onRetry;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.brand),
              const SizedBox(height: 16),
              Text(
                strings.dashboardSessionNotice,
                style: AppTypography.screenTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                strings.dashboardLoadError,
                style: AppTypography.bodyCopy,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                ),
                child: Text(strings.dashboardRetryAction),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onLogout,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Text(strings.dashboardBackToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Home Content
// ─────────────────────────────────────────────────────────────────────────────
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.user, required this.strings, required this.onLogout});
  final DashboardUser user;
  final AppStrings strings;
  final VoidCallback onLogout;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  int _selectedNav = 0;

  List<_NavItem> _buildNavItems(AppStrings strings) {
    return <_NavItem>[
      _NavItem(icon: Icons.home_rounded, label: strings.dashboardNavHome),
      _NavItem(icon: Icons.healing_rounded, label: strings.dashboardNavCare),
      _NavItem(icon: Icons.favorite_rounded, label: strings.dashboardNavHealth),
      _NavItem(icon: Icons.calendar_today_rounded, label: strings.dashboardNavSchedule),
      _NavItem(icon: Icons.person_outline_rounded, label: strings.dashboardNavProfile),
    ];
  }

  List<_ActionTile> _buildTiles(AppStrings strings) {
    return <_ActionTile>[
      _ActionTile(
        icon: Icons.add_circle_outline_rounded,
        iconColor: const Color(0xFF4A90D9),
        label: strings.dashboardTileGetCare,
        sub: strings.dashboardTileGetCareSub,
      ),
      _ActionTile(
        icon: Icons.favorite_rounded,
        iconColor: const Color(0xFFE05C7A),
        label: strings.dashboardTileMyHealth,
        sub: strings.dashboardTileMyHealthSub,
      ),
      _ActionTile(
        icon: Icons.description_outlined,
        iconColor: const Color(0xFF4A90D9),
        label: strings.dashboardTileMyReferral,
        sub: strings.dashboardTileMyReferralSub,
      ),
      _ActionTile(
        icon: Icons.science_rounded,
        iconColor: const Color(0xFF7B5FD4),
        label: strings.dashboardTileMedicines,
        sub: strings.dashboardTileMedicinesSub,
      ),
      _ActionTile(
        icon: Icons.calendar_month_rounded,
        iconColor: const Color(0xFF4A90D9),
        label: strings.dashboardTileAppointment,
        sub: strings.dashboardTileAppointmentSub,
      ),
      _ActionTile(
        icon: Icons.location_on_rounded,
        iconColor: const Color(0xFF4A90D9),
        label: strings.dashboardTileFindNearby,
        sub: strings.dashboardTileFindNearbySub,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = widget.strings;
    final List<_NavItem> navItems = _buildNavItems(strings);
    final List<_ActionTile> tiles = _buildTiles(strings);
    final String initials = widget.user.fullName.isNotEmpty
        ? widget.user.fullName.substring(0, 2).toUpperCase()
        : 'ME';

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Top bar
                    _buildTopBar(initials),
                    const SizedBox(height: 4),
                    Text(
                      strings.dashboardHowFeeling,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 13.5,
                        color: AppColors.body,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 2×3 action grid
                    _buildActionGrid(tiles, strings),
                    const SizedBox(height: 18),

                    // Appointments section (today + upcoming + previous)
                    _buildAppointmentsSection(widget.user, strings),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Bottom nav bar ────────────────────────────────────────────
            _buildBottomNav(navItems),
          ],
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar(String initials) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Sehat ',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                TextSpan(
                  text: 'Sathi',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Notification bell with red dot
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(AppRoutes.notifications),
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.ink,
                    size: 22,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE05C7A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // AI Assistant button
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: () => context.push(AppRoutes.chat),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
                boxShadow: AppColors.brandGlow,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // ME avatar (tap → profile settings)
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: () => context.push(AppRoutes.settings),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── 2×3 action grid ────────────────────────────────────────────────────────
  Widget _buildActionGrid(List<_ActionTile> tiles, AppStrings strings) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
        children: tiles
          .map(
            (_ActionTile tile) => _ActionCard(
              tile: tile,
              onTap: () {
                if (tile.label == strings.dashboardTileGetCare) {
                  context.push(AppRoutes.chat);
                } else if (tile.label == strings.dashboardTileMyHealth) {
                  context.push(AppRoutes.healthRecords);
                } else if (tile.label == strings.dashboardTileFindNearby) {
                  context.push(AppRoutes.nearby);
                } else {
                  _showSnack('${tile.label}${strings.dashboardSnackSuffix}');
                }
              },
            ),
          )
          .toList(),
    );
  }

  // ── Appointments section ─────────────────────────────────────────────────────
  Widget _buildAppointmentsSection(DashboardUser user, AppStrings strings) {
    final List<AppointmentRecord> upcoming = user.appointments
        .where((AppointmentRecord a) => a.status == 'Scheduled')
        .toList();
    final List<AppointmentRecord> previous = user.appointments
        .where((AppointmentRecord a) => a.status == 'Completed')
        .toList();

    final List<Widget> columnChildren = <Widget>[];

    // ── Today's / upcoming appointment detail card (first upcoming) ──
    if (upcoming.isNotEmpty) {
      columnChildren.add(
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (BuildContext context, double value, Widget? child) {
            return Transform.translate(
              offset: Offset(0, -24 * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: _appointmentDetailCard(
            appointment: upcoming.first,
            strings: strings,
            onJoin: () => _showSnack(strings.dashboardJoining),
          ),
        ),
      );
      columnChildren.add(const SizedBox(height: 20));

      // ── Remaining upcoming appointments ──
      if (upcoming.length > 1) {
        columnChildren.add(_sectionHeader(
          label: strings.dashboardUpcomingAppointments,
          color: AppColors.brand,
          delayMs: 200,
        ));
        columnChildren.add(const SizedBox(height: 8));
        for (int i = 1; i < upcoming.length; i++) {
          columnChildren.add(_appointmentListTile(
            appointment: upcoming[i],
            isUpcoming: true,
            delayMs: 300 + i * 100,
          ));
          columnChildren.add(const SizedBox(height: 8));
        }
        columnChildren.add(const SizedBox(height: 12));
      }

      // ── Previous appointments ──
      if (previous.isNotEmpty) {
        columnChildren.add(_sectionHeader(
          label: strings.dashboardPreviousAppointments,
          color: AppColors.body,
          delayMs: 400,
        ));
        columnChildren.add(const SizedBox(height: 8));
        for (int i = 0; i < previous.length; i++) {
          columnChildren.add(_appointmentListTile(
            appointment: previous[i],
            isUpcoming: false,
            delayMs: 500 + i * 100,
          ));
          columnChildren.add(const SizedBox(height: 8));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }

  // ── Appointment detail card (for today's / next appointment) ──────────────────
  Widget _appointmentDetailCard({
    required AppointmentRecord appointment,
    required AppStrings strings,
    required VoidCallback onJoin,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row
          Row(
            children: <Widget>[
              // Green dot + "TODAY'S APPOINTMENT"
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                strings.dashboardTodayAppointment,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              // Time pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.timeLabel,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brand,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Doctor info + Join button
          Row(
            children: <Widget>[
              // Doctor avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tile,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 24,
                  color: AppColors.brand,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appointment.title,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.subtitle,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 12.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Join button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppColors.brandGlow,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onJoin,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            strings.dashboardJoinButton,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontFamilyFallback: AppTypography.fontFamilyFallback,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 14, color: AppColors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Appointment list tile (for upcoming & previous lists) ────────────────────
  Widget _appointmentListTile({
    required AppointmentRecord appointment,
    required bool isUpcoming,
    required int delayMs,
  }) {
    final Color statusColor = isUpcoming ? AppColors.brand : AppColors.body;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delayMs ~/ 2),
      curve: Curves.easeOutBack,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.translate(
          offset: Offset(0, -20 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadii.cardAll,
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      appointment.title,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                appointment.subtitle,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 12.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Text(
                    appointment.dateLabel,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontFamilyFallback: AppTypography.fontFamilyFallback,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.body,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    appointment.timeLabel,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontFamilyFallback: AppTypography.fontFamilyFallback,
                      fontSize: 12,
                      color: AppColors.body,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section header widget ────────────────────────────────────────────────────
  Widget _sectionHeader({
    required String label,
    required Color color,
    required int delayMs,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delayMs),
      curve: Curves.easeOutBack,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.translate(
          offset: Offset(0, -20 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontFamilyFallback: AppTypography.fontFamilyFallback,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }

  // ── Bottom navigation bar ──────────────────────────────────────────────────
  Widget _buildBottomNav(List<_NavItem> navItems) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x0F0F172A), blurRadius: 12, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(
              navItems.length,
              (int index) {
                final bool active = _selectedNav == index;
                return GestureDetector(
                  onTap: () {
                    if (index == 4) {
                      // Profile → logout option
                      _showProfileSheet();
                    } else {
                      setState(() => _selectedNav = index);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        navItems[index].icon,
                        size: 24,
                        color: active ? AppColors.brand : AppColors.muted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        navItems[index].label,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontFamilyFallback: AppTypography.fontFamilyFallback,
                          fontSize: 10.5,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                          color: active ? AppColors.brand : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.user.fullName, style: AppTypography.screenTitle),
              const SizedBox(height: 4),
              Text('+91 ${widget.user.mobileNumber}', style: AppTypography.bodyCopy),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout_rounded),
                label: Text(widget.strings.dashboardLogoutAction),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onLogout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action tile data
// ─────────────────────────────────────────────────────────────────────────────
class _ActionTile {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sub,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sub;
}

// ─────────────────────────────────────────────────────────────────────────────
// Action card widget — white card with icon, bold label, muted sub-label
// ─────────────────────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.tile, required this.onTap});
  final _ActionTile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: tile.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(tile.icon, size: 18, color: tile.iconColor),
              ),
              const SizedBox(height: 8),
              Text(
                tile.label,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tile.sub,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontSize: 11,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav item data
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
