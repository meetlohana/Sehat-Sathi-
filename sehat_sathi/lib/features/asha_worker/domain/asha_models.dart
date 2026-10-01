import 'package:flutter/material.dart';

/// A single statistic card shown in the 2×2 grid.
class AshaStatCardData {
  const AshaStatCardData({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.supportingText,
    required this.icon,
    required this.iconColor,
  });

  final String number;
  final String title;
  final String subtitle;
  final String supportingText;
  final IconData icon;
  final Color iconColor;
}

/// A quick-action button shown in the Quick Actions section.
class AshaQuickActionData {
  const AshaQuickActionData({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  AshaQuickActionData copyWith({
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor,
    String? title,
    String? subtitle,
    VoidCallback? onTap,
  }) =>
      AshaQuickActionData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        icon: icon ?? this.icon,
        iconColor: iconColor ?? this.iconColor,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        onTap: onTap ?? this.onTap,
      );
}

/// A bottom-navigation item for the ASHA dashboard.
class AshaNavItem {
  const AshaNavItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

/// Static content for the ASHA dashboard.
abstract final class AshaDashboardCatalog {
  /// Greeting shown at the top of the header.
  static const String greeting = 'Good Morning, Sunita';

  /// Location subtitle shown under the greeting.
  static const String location = 'Ward 4 • Mohalla • Sub-Center 04';

  /// Search placeholder.
  static const String searchHint = 'Search patients, tasks, ABHA ID...';

  /// Section label above the schedule card.
  static const String focusLabel = "Today's Focus";

  /// Title on the field-schedule card.
  static const String scheduleTitle = 'Field Schedule & Review';

  /// Location / time text inside the schedule card.
  static const String scheduleLocation =
      'Sub-Center 04, Ward 4 / 10:00 AM – 4:00 PM';

  /// The four stat cards, in grid order.
  static const List<AshaStatCardData> statCards = <AshaStatCardData>[
    AshaStatCardData(
      number: '5 Tasks',
      title: 'Today\'s Tasks',
      subtitle: 'Today\'s Tasks',
      supportingText: '3 completed • 2 pending',
      icon: Icons.check_box_rounded,
      iconColor: Color(0xFF0057D9),
    ),
    AshaStatCardData(
      number: '8 Patients',
      title: 'Patients to Assist',
      subtitle: 'Patients to Assist',
      supportingText: '4 high priority today',
      icon: Icons.person_outline_rounded,
      iconColor: Color(0xFF0057D9),
    ),
    AshaStatCardData(
      number: '3 Follow-ups',
      title: 'Follow-ups Due',
      subtitle: 'Follow-ups Due',
      supportingText: 'Maternal & NCD checks',
      icon: Icons.refresh_rounded,
      iconColor: Color(0xFF008A5A),
    ),
    AshaStatCardData(
      number: '2 Pending',
      title: 'Referrals Pending',
      subtitle: 'Referrals Pending',
      supportingText: 'District Hospital OPD',
      icon: Icons.description_outlined,
      iconColor: Color(0xFFD92D20),
    ),
  ];

  /// The three quick-action buttons, in stack order.
  static const List<AshaQuickActionData> quickActions = <AshaQuickActionData>[
    AshaQuickActionData(
      backgroundColor: Color(0xFF0057D9),
      icon: Icons.person_add_alt_1_rounded,
      iconColor: Colors.white,
      title: 'Assist Patient',
      subtitle: 'Start clinical consultation & triage',
    ),
    AshaQuickActionData(
      backgroundColor: Color(0xFF008A5A),
      icon: Icons.task_alt_rounded,
      iconColor: Colors.white,
      title: 'Complete Follow-up',
      subtitle: 'Record assessment & vitals',
    ),
    AshaQuickActionData(
      backgroundColor: Colors.white,
      icon: Icons.description_outlined,
      iconColor: Color(0xFF0057D9),
      title: 'View New Referral',
      subtitle: 'Check hospital admission slips',
    ),
  ];

  /// The five bottom-navigation items, in order.
  static const List<AshaNavItem> navItems = <AshaNavItem>[
    AshaNavItem(icon: Icons.home_rounded, label: 'Home'),
    AshaNavItem(icon: Icons.people_alt_outlined, label: 'Patients'),
    AshaNavItem(icon: Icons.check_circle_outline_rounded, label: 'Tasks'),
    AshaNavItem(icon: Icons.description_outlined, label: 'Referrals'),
    AshaNavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  /// Emergency alert text shown inside the alert card.
  static const String emergencyAlertText =
      'Ka... Sharma (Severe respiratory distress) & Ramesh K. (High glucose)';

  /// Button label inside the emergency card.
  static const String emergencyButton = 'View Emergency Alerts (2)';
}
