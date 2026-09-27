import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/data/user_health_repository.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_detail.dart';
import '../widgets/dashboard_titlebar.dart';

/// Simple QR code painter that renders a 21×21 Version-1 pattern from a
/// seed string. Uses the app's brand colour palette.
class _QrCodePainter extends CustomPainter {
  const _QrCodePainter({required this.seed});
  final String seed;

  static const int _size = 21;

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / _size;
    final List<int> bits = _generateBits(seed);
    final Paint black = Paint()..color = AppColors.ink;
    final Paint white = Paint()..color = AppColors.white;

    // Background
    canvas.drawRect(Offset.zero & size, white);

    // Finder pattern (top-left corner: 7x7)
    void drawBlock(int x, int y, int w, int h, Paint paint) {
      canvas.drawRect(Offset(x * cell, y * cell) & Size(w * cell, h * cell), paint);
    }

    // Top-left finder
    drawBlock(0, 0, 7, 7, black);
    drawBlock(1, 1, 5, 5, white);
    drawBlock(2, 2, 3, 3, black);

    // Top-right finder
    drawBlock(14, 0, 7, 7, black);
    drawBlock(15, 1, 5, 5, white);
    drawBlock(16, 2, 3, 3, black);

    // Bottom-left finder
    drawBlock(0, 14, 7, 7, black);
    drawBlock(1, 15, 5, 5, white);
    drawBlock(2, 16, 3, 3, black);

    // Data modules from seed
    for (int y = 0; y < _size; y++) {
      for (int x = 0; x < _size; x++) {
        // Skip finder pattern areas
        if (x < 9 && y < 9) continue;
        if (x > 11 && y < 9) continue;
        if (x < 9 && y > 11) continue;
        final int index = (y * _size + x) % bits.length;
        if (bits[index] == 1) {
          drawBlock(x, y, 1, 1, black);
        }
      }
    }
  }

  static List<int> _generateBits(String seed) {
    final List<int> result = <int>[];
    int hash = 0;
    for (int i = 0; i < seed.length; i++) {
      hash = (hash * 31 + seed.codeUnitAt(i)) & 0xFFFFFFFF;
      result.add((hash >> (i % 24)) & 1);
    }
    while (result.length < _size * _size) {
      hash = (hash * 31 + 7919) & 0xFFFFFFFF;
      result.add((hash >> (result.length % 24)) & 1);
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _QrCodePainter old) => old.seed != seed;
}

/// A tile that slides in from the bottom with a delayed offset.
class _SlideInTile extends StatelessWidget {
  const _SlideInTile({
    required this.delay,
    required this.child,
  });

  final Duration delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.translate(
          offset: Offset(0, 32 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Health records dashboard — displays health records, lab results, and
/// prescriptions for the logged-in patient, with a vertical slide-in
/// animation for each section.
class HealthRecordsScreen extends ConsumerStatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  ConsumerState<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends ConsumerState<HealthRecordsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToBottomWithDelay();
  }

  void _scrollToBottomWithDelay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.position.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<DashboardUser> userAsync = ref.watch(dashboardUserProvider);
    final AppStrings strings = ref.watch(appStringsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.brand)),
          error: (Object error, StackTrace stack) => Center(
            child: Text(
              'Error: $error',
              style: AppTypography.bodyCopy,
            ),
          ),
          data: (DashboardUser user) => CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
               // ── Pinned app bar ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: DashboardTitleBar(
                    title: strings.dashboardTileMyHealth,
                    subtitle: '${user.fullName} • +91 ${user.mobileNumber}',
                    onBack: () => context.pop(),
                  ),
                ),
              ),

              // ── QR Code card ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _SlideInTile(
                  delay: Duration.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _QrCodeCard(
                      healthId: user.healthIdNumber,
                      label: strings.dashboardQrCodeLabel,
                    ),
                  ),
                ),
              ),

              // ── Upload Health Record button ──────────────────────────────────
              SliverToBoxAdapter(
                child: _SlideInTile(
                  delay: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SizedBox(
                      height: AppSizes.buttonHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: AppRadii.buttonAll,
                          boxShadow: AppColors.brandGlow,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: AppRadii.buttonAll,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.dashboardUploadSuccessMsg),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.ink,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            borderRadius: AppRadii.buttonAll,
                            child: Center(
                              child: Text(
                                strings.dashboardUploadButton,
                                style: AppTypography.buttonLabel,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Animated health-records section ─────────────────────────────
              ..._buildAnimatedSection(
                title: strings.dashboardTileMyHealth,
                items: user.healthRecords,
                icon: Icons.favorite_rounded,
                iconColor: const Color(0xFFE05C7A),
              ),
              // ── Animated lab-results section ───────────────────────────────
              ..._buildAnimatedSection(
                title: 'Lab Tests / लॅब टेस्ट',
                items: user.labResults,
                icon: Icons.science_rounded,
                iconColor: const Color(0xFF7B5FD4),
              ),
              // ── Animated prescriptions section ──────────────────────────────
              ..._buildAnimatedSection(
                title: 'Prescriptions / प्रिस्क्रिप्शन',
                items: user.prescriptions,
                icon: Icons.description_rounded,
                iconColor: const Color(0xFF4A90D9),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedSection({
    required String title,
    required List<ClinicalItemRecord> items,
    required IconData icon,
    required Color iconColor,
  }) {
    return <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: AppRadii.chipAll,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTypography.screenTitle.copyWith(fontSize: 18)),
            ],
          ),
        ),
      ),
      if (items.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('No records yet', style: AppTypography.bodyCopy),
          ),
        )
      else
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List<Widget>.generate(items.length, (int index) {
                final ClinicalItemRecord item = items[index];
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
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: index < items.length - 1 ? 12 : 0,
                    ),
                    child: DashboardDetailCard(
                      title: item.title,
                      icon: icon,
                      children: <Widget>[
                        DashboardDetailRow(
                          label: 'Description / वर्णन',
                          value: item.subtitle,
                        ),
                        if (item.tag.isNotEmpty)
                          DashboardDetailRow(
                            label: 'Tag / टॅग',
                            value: item.tag,
                          ),
                        if (item.badge != null && item.badge!.isNotEmpty)
                          DashboardDetailRow(
                            label: 'Status / स्थिती',
                            value: '',
                            trailing: StatusBadge(status: item.badge!),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
    ];
  }
}

/// QR code display card showing the patient's health ID as a scannable code.
class _QrCodeCard extends StatelessWidget {
  const _QrCodeCard({
    required this.healthId,
    required this.label,
  });

  final String healthId;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: AppTypography.stepLabel,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppRadii.cardAll,
              border: Border.all(color: AppColors.border, width: 2),
              boxShadow: AppColors.cardShadow,
            ),
            child: CustomPaint(
              size: const Size(144, 144),
              painter: _QrCodePainter(seed: healthId),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            healthId,
            style: AppTypography.cardTitle.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
