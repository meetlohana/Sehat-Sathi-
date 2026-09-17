import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/dashboard_titlebar.dart';

/// A single notification item shown in the notifications dropdown/page.
class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;
}

/// 10 dummy notifications covering appointments, records, reminders and more.
final List<NotificationItem> dummyNotifications = <NotificationItem>[
  const NotificationItem(
    title: 'Appointment Reminder',
    message: 'You have an appointment with Dr. Sarah Jenkins tomorrow at 10:30 AM',
    time: 'Just now',
    icon: Icons.calendar_today_rounded,
    iconColor: Color(0xFF4A90D9),
  ),
  const NotificationItem(
    title: 'Prescription Ready',
    message: 'Your prescription has been uploaded by Dr. Sharma. Tap to view.',
    time: '2 min ago',
    icon: Icons.description_rounded,
    iconColor: Color(0xFF7B5FD4),
    isRead: true,
  ),
  const NotificationItem(
    title: 'Lab Test Results',
    message: 'Your CBC test results are available. All values are within normal range.',
    time: '1 hour ago',
    icon: Icons.science_rounded,
    iconColor: Color(0xFF22C55E),
  ),
  const NotificationItem(
    title: 'Medicine Reminder',
    message: 'Time to take your morning medication: 2 Daily Refills - Paracetamol',
    time: '2 hours ago',
    icon: Icons.medication_rounded,
    iconColor: Color(0xFFE05C7A),
    isRead: true,
  ),
  const NotificationItem(
    title: 'Appointment Confirmed',
    message: 'Your appointment with Dr. Sarah Jenkins has been confirmed for 10:30 AM',
    time: '3 hours ago',
    icon: Icons.confirmation_num_rounded,
    iconColor: Color(0xFF669FD9),
    isRead: true,
  ),
  const NotificationItem(
    title: 'Health Record Updated',
    message: 'Your blood pressure reading has been added to your health records',
    time: '5 hours ago',
    icon: Icons.favorite_rounded,
    iconColor: Color(0xFFE05C7A),
  ),
  const NotificationItem(
    title: 'Medicine Refill Alert',
    message: 'You have 3 days left of your current prescription. Refill now?',
    time: '1 day ago',
    icon: Icons.warning_rounded,
    iconColor: Color(0xFFD97706),
    isRead: true,
  ),
  const NotificationItem(
    title: 'Doctor Consultation',
    message: 'Dr. Sarah Jenkins sent you a follow-up message. Tap to read.',
    time: '1 day ago',
    icon: Icons.video_call_rounded,
    iconColor: Color(0xFF4A90D9),
  ),
  const NotificationItem(
    title: 'Hospital Update',
    message: 'City Hospital is now offering weekend outpatient services',
    time: '2 days ago',
    icon: Icons.local_hospital_rounded,
    iconColor: Color(0xFF22C55E),
    isRead: true,
  ),
  const NotificationItem(
    title: 'Sehat Sathi Update',
    message: 'New features added: QR code sharing, health record upload, and more!',
    time: '3 days ago',
    icon: Icons.notifications_active_rounded,
    iconColor: AppColors.brand,
    isRead: true,
  ),
];

/// Notifications page shown when the user taps the notification bell
/// on the dashboard. Features a slide-down animation from the top.
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Title bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DashboardTitleBar(
                title: 'Notifications / सूचनांक',
                subtitle: '${dummyNotifications.length} unread notifications',
                onBack: () => context.pop(),
              ),
            ),

            // ── Notification list with slide-down animation ──────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: dummyNotifications.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  final NotificationItem notification = dummyNotifications[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + index * 100),
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
                    child: _NotificationCard(notification: notification),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card widget for a single notification.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final Color bg = notification.isRead
        ? AppColors.white
        : AppColors.selectedTint;
    final Color borderColor = notification.isRead
        ? AppColors.border
        : AppColors.brand;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: borderColor, width: notification.isRead ? 1 : 1.5),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification.iconColor.withValues(alpha: 0.12),
              borderRadius: AppRadii.chipAll,
            ),
            child: Icon(
              notification.icon,
              size: 20,
              color: notification.iconColor,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: AppColors.body,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  notification.time,
                  style: AppTypography.transliteration.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
