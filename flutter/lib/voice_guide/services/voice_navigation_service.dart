import 'package:flutter/material.dart';
import '../models/screen_context.dart';
import '../models/voice_intent.dart';

/// Your app's route names. Change these to match your existing routes
/// (or override individual actions with [VoiceNavigationService.overrides]).
class VoiceRoutes {
  const VoiceRoutes({
    this.home = '/home',
    this.appointment = '/appointment',
    this.appointments = '/my-appointments',
    this.records = '/health-records',
    this.referral = '/referral',
    this.medicines = '/medicines',
    this.consultation = '/consultation',
    this.emergency = '/emergency',
  });

  final String home, appointment, appointments, records, referral,
      medicines, consultation, emergency;

  /// Route name -> voice screen id (used to auto-detect the current screen).
  Map<String, String> get screenByRoute => {
        home: VoiceScreens.home,
        appointment: VoiceScreens.appointment,
        appointments: VoiceScreens.appointments,
        records: VoiceScreens.records,
        referral: VoiceScreens.referral,
        medicines: VoiceScreens.medicines,
        consultation: VoiceScreens.consultation,
        emergency: VoiceScreens.emergency,
      };
}

/// Navigation ADAPTER. The ONLY place that touches your routes.
/// Only these fixed methods exist, so no arbitrary navigation is possible.
class VoiceNavigationService {
  VoiceNavigationService({
    required this.navigatorKey,
    this.routes = const VoiceRoutes(),
    this.overrides = const {},
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final VoiceRoutes routes;

  /// Optional custom navigation per action, e.g. if you use go_router:
  ///   {VoiceAction.openRecords: () => router.go('/records')}
  final Map<VoiceAction, VoidCallback> overrides;

  NavigatorState? get _nav => navigatorKey.currentState;

  void _go(VoiceAction a, String route) {
    final custom = overrides[a];
    if (custom != null) {
      custom();
      return;
    }
    _nav?.pushNamed(route);
  }

  void openHome() {
    final custom = overrides[VoiceAction.openHome];
    if (custom != null) return custom();
    _nav?.pushNamedAndRemoveUntil(routes.home, (r) => false);
  }

  void openAppointment() => _go(VoiceAction.openAppointment, routes.appointment);
  void openAppointments() => _go(VoiceAction.openAppointments, routes.appointments);
  void openHealthRecords() => _go(VoiceAction.openRecords, routes.records);
  void openReferral() => _go(VoiceAction.openReferral, routes.referral);
  void openMedicines() => _go(VoiceAction.openMedicines, routes.medicines);
  void openConsultation() => _go(VoiceAction.startConsultation, routes.consultation);
  void openEmergency() => _go(VoiceAction.openEmergency, routes.emergency);

  void goBack() {
    final custom = overrides[VoiceAction.goBack];
    if (custom != null) return custom();
    _nav?.maybePop();
  }
}

/// Add to MaterialApp(navigatorObservers: [VoiceGuide.routeObserver]) so the
/// voice module always knows the current screen (screen-aware guidance).
class VoiceRouteObserver extends NavigatorObserver {
  VoiceRouteObserver({required this.routes, required this.onScreen});
  final VoiceRoutes routes;
  final void Function(String screen) onScreen;

  void _report(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null) return;
    // Defer: observer callbacks fire during navigation.
    Future.microtask(() => onScreen(routes.screenByRoute[name] ?? VoiceScreens.unknown));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _report(route);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _report(previousRoute);
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _report(newRoute);
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => _report(previousRoute);
}
