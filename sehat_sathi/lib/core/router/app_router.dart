import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/login_success_screen.dart';
import '../../features/dashboard/presentation/screens/appointment_booking_screen.dart';
import '../../features/dashboard/presentation/screens/appointment_confirmation_screen.dart';
import '../../features/dashboard/presentation/screens/chat_bot_screen.dart';
import '../../features/dashboard/presentation/screens/health_records_screen.dart';
import '../../features/dashboard/presentation/screens/home_screen.dart';
import '../../features/dashboard/presentation/screens/medicines_screen.dart';
import '../../features/dashboard/presentation/screens/nearby_page_screen.dart';
import '../../features/dashboard/presentation/screens/referral_details_screen.dart';
import '../../features/onboarding/presentation/screens/language_selection_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_done_screen.dart';
import '../../features/onboarding/presentation/screens/role_selection_screen.dart';
/// Application routes.
///
/// Flow: language -> role -> onboarding done -> login -> home (dashboard).
abstract final class AppRoutes {
  static const String language = '/onboarding/language';
  static const String role = '/onboarding/role';
  static const String done = '/onboarding/done';
  static const String login = '/auth/login';
  static const String loginSuccess = '/auth/success';
  static const String home = '/home';
  static const String chatBot = '/chat-bot';
  static const String healthRecords = '/health-records';
  static const String nearby = '/nearby';
  static const String referralDetails = '/referral-details';
  static const String medicines = '/medicines';
  static const String appointmentBooking = '/appointment-booking';
  static const String appointmentConfirmation = '/appointment-confirmation';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.language,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.language,
        name: 'language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.role,
        name: 'role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.done,
        name: 'done',
        builder: (context, state) {
          final String languageId =
              state.uri.queryParameters['language'] ?? 'mr';
          final String roleId =
              state.uri.queryParameters['role'] ?? 'patient';
          return OnboardingDoneScreen(
            languageId: languageId,
            roleId: roleId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginSuccess,
        name: 'loginSuccess',
        builder: (context, state) {
          final String mobile = state.uri.queryParameters['mobile'] ?? '';
          return LoginSuccessScreen(mobileNumber: mobile);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatBot,
        name: 'chatBot',
        builder: (context, state) => const ChatBotScreen(),
      ),
      GoRoute(
        path: AppRoutes.healthRecords,
        name: 'healthRecords',
        builder: (context, state) => const HealthRecordsScreen(),
      ),
      GoRoute(
        path: AppRoutes.nearby,
        name: 'nearby',
        builder: (context, state) => const NearbyPageScreen(),
      ),
      GoRoute(
        path: AppRoutes.referralDetails,
        name: 'referralDetails',
        builder: (context, state) => const ReferralDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicines,
        name: 'medicines',
        builder: (context, state) => const MedicinesScreen(),
      ),
      GoRoute(
        path: AppRoutes.appointmentBooking,
        name: 'appointmentBooking',
        builder: (context, state) => const AppointmentBookingScreen(),
      ),
      GoRoute(
        path: AppRoutes.appointmentConfirmation,
        name: 'appointmentConfirmation',
        builder: (context, state) => const AppointmentConfirmationScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        redirect: (context, state) => AppRoutes.home,
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRoutes.language,
      ),
    ],
  );
}
