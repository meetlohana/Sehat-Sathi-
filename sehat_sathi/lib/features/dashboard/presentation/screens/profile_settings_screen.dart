import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/data/onboarding_catalog.dart';
import '../../../onboarding/domain/onboarding_models.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_titlebar.dart';

/// A single settings item shown in the profile/settings page.
class SettingsItem {
  const SettingsItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final String route;
}

/// Profile / settings page. Accessible by tapping the profile avatar
/// on the dashboard top bar. Features profile icon update, all app
/// settings with dropdown animation, and a Help section.
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _showHelpDropdown = false;

  List<SettingsItem> _buildSettings(AppStrings strings, String localeId) {
    final LanguageOption? lang = OnboardingCatalog.languageById(localeId);
    final String currentLanguage = lang?.englishName ?? 'English';

    return <SettingsItem>[
      SettingsItem(
        label: 'Edit Profile',
        icon: Icons.person_rounded,
        iconColor: AppColors.brand,
        route: '',
      ),
      SettingsItem(
        label: 'Language ($currentLanguage)',
        icon: Icons.language_rounded,
        iconColor: const Color(0xFF7B5FD4),
        route: '',
      ),
      SettingsItem(
        label: 'Notifications',
        icon: Icons.notifications_rounded,
        iconColor: const Color(0xFFE05C7A),
        route: '',
      ),
      SettingsItem(
        label: 'Privacy Policy',
        icon: Icons.privacy_tip_rounded,
        iconColor: const Color(0xFF22C55E),
        route: '',
      ),
      SettingsItem(
        label: 'Terms & Conditions',
        icon: Icons.document_scanner_rounded,
        iconColor: const Color(0xFF4A90D9),
        route: '',
      ),
      SettingsItem(
        label: 'Rate Us',
        icon: Icons.star_rounded,
        iconColor: const Color(0xFFFFA500),
        route: '',
      ),
      SettingsItem(
        label: 'Dark Mode',
        icon: Icons.dark_mode_rounded,
        iconColor: AppColors.body,
        route: '',
      ),
      SettingsItem(
        label: 'AI Assistant',
        icon: Icons.smart_toy_rounded,
        iconColor: const Color(0xFF06B6D1),
        route: AppRoutes.chat,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final String localeId = ref.watch(localeIdProvider);
    final AsyncValue<DashboardUser> userAsync = ref.watch(dashboardUserProvider);
    final List<SettingsItem> settings = _buildSettings(strings, localeId);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Title bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DashboardTitleBar(
                title: 'Settings / सेटिंग',
                subtitle: 'Profile & App Preferences',
                onBack: () => context.pop(),
              ),
            ),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // ── Profile icon card ──────────────────────────────────
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
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: AppRadii.cardAll,
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Column(
                          children: <Widget>[
                            // Profile icon/avatar
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: AppColors.brandGradient,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border, width: 3),
                                boxShadow: AppColors.brandGlow,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 42,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Update button
                            SizedBox(
                              height: AppSizes.buttonHeight * 0.52,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.tile,
                                  borderRadius: AppRadii.chipAll,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: AppRadii.chipAll,
                                  child: InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Profile icon updated!'),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: AppColors.ink,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    borderRadius: AppRadii.chipAll,
                                    child: const Center(
                                      child: Text(
                                        'Update Profile Icon',
                                        style: TextStyle(
                                          fontFamily: AppTypography.fontFamily,
                                          fontFamilyFallback: AppTypography.fontFamilyFallback,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.brand,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // User info
                            userAsync.when(
                              data: (DashboardUser user) => Column(
                                children: <Widget>[
                                  Text(
                                    user.fullName,
                                    style: AppTypography.cardTitle.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '+91 ${user.mobileNumber} • ${user.healthIdNumber}',
                                    style: AppTypography.bodyCopy.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                              loading: () => const SizedBox.shrink(),
                              error: (_, _) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Settings items ──────────────────────────────────────
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: settings.length,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final SettingsItem item = settings[index];
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
                          child: _SettingsTile(item: item),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── Help section with dropdown ──────────────────────────
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
                      child: _HelpSection(
                        expanded: _showHelpDropdown,
                        onToggle: () => setState(() => _showHelpDropdown = !_showHelpDropdown),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings tile with icon and label.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.item});

  final SettingsItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.cardAll,
        child: InkWell(
          onTap: () {
            if (item.route.isNotEmpty) {
              context.push(item.route);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.label} tapped'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.ink,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          borderRadius: AppRadii.cardAll,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.12),
                    borderRadius: AppRadii.chipAll,
                  ),
                  child: Icon(item.icon, size: 20, color: item.iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontFamilyFallback: AppTypography.fontFamilyFallback,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Help section with dropdown animation.
class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.expanded,
    required this.onToggle,
  });

  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: <Widget>[
          // Header (tappable to toggle)
          Material(
            color: Colors.transparent,
            borderRadius: AppRadii.cardAll,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadii.card),
                topRight: Radius.circular(AppRadii.card),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.brand.withValues(alpha: 0.12),
                        borderRadius: AppRadii.chipAll,
                      ),
                      child: const Icon(
                        Icons.help_rounded,
                        size: 20,
                        color: AppColors.brand,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Help & Support',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontFamilyFallback: AppTypography.fontFamilyFallback,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded content (with dropdown animation)
          AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                _helpItem('FAQs', Icons.question_answer_rounded),
                const SizedBox(height: 10),
                _helpItem('Contact Support', Icons.support_agent_rounded),
                const SizedBox(height: 10),
                _helpItem('Report an Issue', Icons.bug_report_rounded),
              ],
            ),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        ],
      ),
    );
  }

  Widget _helpItem(String label, IconData icon) {
    return Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.brand.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.brand),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTypography.bodyCopy.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
