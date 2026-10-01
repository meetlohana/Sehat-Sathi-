import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/referral_models.dart';
import '../providers/referral_providers.dart';
import '../widgets/dashboard_titlebar.dart';

class ReferralDetailsScreen extends ConsumerWidget {
  const ReferralDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ActiveReferral?> activeReferralAsync = ref.watch(activeReferralProvider);
    final AsyncValue<List<ArchiveReferral>> archiveAsync = ref.watch(referralArchiveProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF3FB),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // ── Title bar ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: DashboardTitleBar(
                  title: 'My Referral',
                  subtitle: '1 Specialist Active',
                  onBack: () => context.pop(),
                ),
              ),

              // ── Tab bar ─────────────────────────────────────────────────────
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Material(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                  child: TabBar(
                    padding: const EdgeInsets.all(4),
                    indicator: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: AppRadii.chipAll,
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.body,
                    labelStyle: AppTypography.buttonLabel.copyWith(fontSize: 13),
                    unselectedLabelStyle: AppTypography.cardBadge.copyWith(color: AppColors.body),
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: AppColors.border,
                    tabs: const <Widget>[
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('ACTIVE'),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('ARCHIVE'),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ── Tab views ───────────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    // ── Active Referral ───────────────────────────────────────
                    activeReferralAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.brand),
                      ),
                      error: (Object e, StackTrace s) => _ErrorState(
                        message: 'Failed to load referrals',
                        onRetry: () => ref.refresh(activeReferralProvider.future),
                      ),
                      data: (ActiveReferral? referral) {
                        if (referral == null) {
                          return _EmptyState(
                            icon: Icons.description_outlined,
                            title: 'No Active Referrals',
                            message: 'You have no active referrals at the moment.',
                            actionLabel: 'Request Referral',
                            onAction: () {},
                          );
                        }
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _ActiveReferralCard(referral: referral),
                              const SizedBox(height: 24),
                              // Timeline
                              Text(
                                'Referral Timeline',
                                style: AppTypography.stepLabel.copyWith(fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              _ReferralTimeline(timeline: referral.timeline),
                            ],
                          ),
                        );
                      },
                    ),

                    // ── Archive ────────────────────────────────────────────────
                    archiveAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.brand),
                      ),
                      error: (Object e, StackTrace s) => _ErrorState(
                        message: 'Failed to load archive',
                        onRetry: () => ref.refresh(referralArchiveProvider.future),
                      ),
                      data: (List<ArchiveReferral> referrals) {
                        if (referrals.isEmpty) {
                          return _EmptyState(
                            icon: Icons.folder_off_rounded,
                            title: 'No Referral History',
                            message: 'You have no past referrals.',
                            showAction: false,
                          );
                        }
                        return Column(
                          children: <Widget>[
                            // Search & filter
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              child: Column(
                                children: <Widget>[
                                  // Search bar
                                  Container(
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
                                        hintText: 'Search by hospital, doctor, or ID...',
                                        hintStyle: AppTypography.fieldHint,
                                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        // Filter chips would be added here
                      ],
                    ),
                  ),
                                ],
                              ),
                            ),
                            // Referral list
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                itemCount: referrals.length,
                                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
                                itemBuilder: (BuildContext context, int index) {
                                  final ArchiveReferral referral = referrals[index];
                                  return _ArchiveReferralCard(referral: referral);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// Active Referral Card
// ══════════════════════════════════════════════════════════════════
class _ActiveReferralCard extends StatelessWidget {
  const _ActiveReferralCard({required this.referral});
  final ActiveReferral referral;

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = referral.priority == ReferralPriority.urgent;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(
          color: isUrgent ? const Color(0xFFDC2626) : AppColors.brand,
          width: 2,
        ),
        boxShadow: isUrgent
            ? [
                BoxShadow(color: const Color(0xFFDC2626).withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 8)),
              ]
            : AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header: Status badge + priority badge
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: referral.status.bgColor,
                  borderRadius: AppRadii.chipAll,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(referral.status.icon, size: 14, color: referral.status.color),
                    const SizedBox(width: 6),
                    Text(referral.status.label, style: AppTypography.badge.copyWith(color: referral.status.color)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: referral.priority.bgColor,
                  borderRadius: AppRadii.chipAll,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.priority_high_rounded, size: 14, color: referral.priority.color),
                    const SizedBox(width: 6),
                    Text(referral.priority.label, style: AppTypography.badge.copyWith(color: referral.priority.color)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Specialist & hospital
          Text(referral.specialistName, style: AppTypography.cardTitle),
          const SizedBox(height: 2),
          Text(
            referral.specialistSpecialty,
            style: AppTypography.cardSubtitle.copyWith(color: AppColors.body),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(Icons.local_hospital_rounded, size: 14, color: AppColors.body),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  referral.hospitalName,
                  style: AppTypography.bodyCopy.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Icon(Icons.location_on_rounded, size: 14, color: AppColors.muted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  referral.hospitalAddress,
                  style: AppTypography.cardSubtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Referral details
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Referral Date', style: AppTypography.stepLabel),
                    Text(
                      _formatDate(referral.referralDate),
                      style: AppTypography.bodyCopy,
                    ),
                  ],
                ),
              ),
              if (referral.appointmentDate != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Appointment', style: AppTypography.stepLabel),
                      Text(
                        '${_formatDate(referral.appointmentDate!)} • ${referral.appointmentTime ?? ''}',
                        style: AppTypography.bodyCopy,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          Text('Reason', style: AppTypography.stepLabel),
          Text(referral.reason, style: AppTypography.bodyCopy),
          const SizedBox(height: 16),

          // Documents
          if (referral.documents.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Documents', style: AppTypography.stepLabel),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: referral.documents.map((doc) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.tile,
                        borderRadius: AppRadii.chipAll,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.description_rounded, size: 16, color: AppColors.brand),
                          const SizedBox(width: 6),
                          Text(doc.name, style: AppTypography.cardBadge.copyWith(color: AppColors.body)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

          // Actions
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              if (referral.hospitalContact != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${referral.hospitalContact}')),
                      );
                    },
                    icon: const Icon(Icons.call_rounded, size: 18),
                    label: const Text('Call Hospital'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                    ),
                  ),
                ),
              if (referral.hospitalContact != null) const SizedBox(width: 12),
              if (referral.status != ReferralStatus.completed && referral.status != ReferralStatus.cancelled)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cancel referral')),
                      );
                    },
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ══════════════════════════════════════════════════════════════════
// Referral Timeline
// ══════════════════════════════════════════════════════════════════
class _ReferralTimeline extends StatelessWidget {
  const _ReferralTimeline({required this.timeline});
  final List<ReferralTimelineEvent> timeline;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timeline.length,
      separatorBuilder: (BuildContext context, int index) => Container(
        width: 2,
        height: 24,
        margin: const EdgeInsets.only(left: 13),
        color: AppColors.border,
      ),
      itemBuilder: (BuildContext context, int index) {
        final ReferralTimelineEvent event = timeline[index];
        final bool isCurrent = event.isCurrent;
        final bool isCompleted = timeline.sublist(0, index + 1).every((e) => !e.isCurrent);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Circle + connecting dot
            Column(
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.brand : (isCompleted ? const Color(0xFF22C55E) : AppColors.border),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Icon(
                    event.status.icon,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
                if (index < timeline.length - 1) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 2,
                    height: 28,
                    color: isCurrent ? AppColors.brand : AppColors.border,
                  ),
                ],
              ],
            ),
            const SizedBox(width: 12),
            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.title,
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 14,
                      color: isCurrent ? AppColors.brand : AppColors.ink,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: AppTypography.cardSubtitle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(event.timestamp),
                    style: AppTypography.footerCaption.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final String am = dt.hour < 12 ? 'AM' : 'PM';
    final int hour12 = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    return '${dt.day} ${months[dt.month - 1]}, $hour12:${dt.minute.toString().padLeft(2, '0')} $am';
  }
}

// ══════════════════════════════════════════════════════════════════
// Archive Referral Card
// ══════════════════════════════════════════════════════════════════
class _ArchiveReferralCard extends StatelessWidget {
  const _ArchiveReferralCard({required this.referral});
  final ArchiveReferral referral;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing details for ${referral.referralId}')),
          );
        },
        borderRadius: AppRadii.cardAll,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadii.cardAll,
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Row(
                children: <Widget>[
                  Text(
                    referral.specialistName,
                    style: AppTypography.cardTitle,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: referral.status.bgColor,
                      borderRadius: AppRadii.chipAll,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(referral.status.icon, size: 12, color: referral.status.color),
                        const SizedBox(width: 6),
                        Text(referral.status.label, style: AppTypography.badge.copyWith(color: referral.status.color)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                referral.specialty,
                style: AppTypography.cardSubtitle.copyWith(color: AppColors.body),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Icon(Icons.local_hospital_rounded, size: 14, color: AppColors.body),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      referral.hospitalName,
                      style: AppTypography.bodyCopy.copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildDateColumn(
                      'REFERRAL DATE',
                      _formatDate(referral.referralDate),
                    ),
                  ),
                  if (referral.completionDate != null)
                    Expanded(
                      child: _buildDateColumn(
                        'COMPLETED',
                        _formatDate(referral.completionDate!),
                      ),
                    ),
                ],
              ),
              if (referral.hasReport) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading report for ${referral.referralId}')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 16, color: AppColors.brand),
                    label: Text(
                      'View Report',
                      style: AppTypography.cardBadge,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTypography.stepLabel),
        Text(value, style: AppTypography.bodyCopy),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ══════════════════════════════════════════════════════════════════
// Shared Components
// ══════════════════════════════════════════════════════════════════
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(message, style: AppTypography.bodyCopy),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.showAction = true,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 64, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.screenTitle),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTypography.bodyCopy,
            textAlign: TextAlign.center,
          ),
          if (showAction && actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}