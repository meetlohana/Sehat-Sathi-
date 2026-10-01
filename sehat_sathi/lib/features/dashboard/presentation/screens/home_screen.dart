import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../asha_worker/presentation/screens/asha_dashboard_screen.dart';
import '../providers/dashboard_providers.dart';
import 'dashboard_screen.dart';

/// Role-aware home screen.
///
/// Watches [dashboardUserProvider] and dispatches to the correct
/// dashboard based on the user's role:
///   - `patient` / any non-asha role  → [PatientDashboardContent]
///   - `asha`                          → [AshaDashboardScreen]
///
/// Handles loading and error states identically to the original
/// [DashboardScreen], then delegates the data state to the
/// role-specific content widget.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DashboardUser> userAsync =
        ref.watch(dashboardUserProvider);

    return userAsync.when(
      loading: () => const _HomeLoading(),
      error: (Object error, StackTrace stackTrace) => _HomeError(
        onRetry: () => ref.read(dashboardUserProvider.notifier).refresh(),
        onLogout: () async {
          await ref.read(dashboardUserProvider.notifier).logout();
          if (context.mounted) context.go(AppRoutes.login);
        },
      ),
      data: (DashboardUser user) => user.isAsha
          ? const AshaDashboardScreen()
          : PatientDashboardContent(
              user: user,
              onLogout: () async {
                await ref.read(dashboardUserProvider.notifier).logout();
                if (context.mounted) context.go(AppRoutes.login);
              },
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading state
// ─────────────────────────────────────────────────────────────────────────────
class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry, required this.onLogout});

  final VoidCallback onRetry;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Session Notice',
                style: AppTypography.screenTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Could not load your dashboard. Please retry.',
                style: AppTypography.bodyCopy,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.buttonAll,
                  ),
                ),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onLogout,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.buttonAll,
                  ),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
