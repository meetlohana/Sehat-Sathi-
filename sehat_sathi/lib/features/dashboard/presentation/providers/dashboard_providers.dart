import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/i18n/locale_persistence.dart';
import '../../../auth/data/user_health_repository.dart';

/// Holds the current logged-in user's information and clinical data for the dashboard.
class DashboardUser {
  const DashboardUser({
    required this.mobileNumber,
    required this.fullName,
    required this.role,
    required this.language,
    required this.healthIdNumber,
    this.gender = 'Male / पुरुष',
    this.email = 'ram.sharma@example.com',
    this.address = 'Gandhi Nagar, Aurangabad, Maharashtra 431001',
    this.loginCount = 1,
    this.pgConnected = true,
    this.mongoConnected = true,
    this.appointments = const <AppointmentRecord>[],
    this.healthRecords = const <ClinicalItemRecord>[],
    this.labResults = const <ClinicalItemRecord>[],
    this.prescriptions = const <ClinicalItemRecord>[],
  });

  final String mobileNumber;
  final String fullName;
  final String role;
  final String language;
  final String healthIdNumber;
  final String gender;
  final String email;
  final String address;
  final int loginCount;
  final bool pgConnected;
  final bool mongoConnected;

  final List<AppointmentRecord> appointments;
  final List<ClinicalItemRecord> healthRecords;
  final List<ClinicalItemRecord> labResults;
  final List<ClinicalItemRecord> prescriptions;

  bool get isPatient => role == 'patient';
  bool get isAsha => role == 'asha';
  bool get isPhc => role == 'phc';
  bool get isDistrictHospital => role == 'district-hospital';

  factory DashboardUser.fromProfile(PatientHealthProfile profile) {
    return DashboardUser(
      mobileNumber: profile.mobileNumber,
      fullName: profile.fullName,
      role: profile.role,
      language: profile.language,
      healthIdNumber: profile.healthIdNumber,
      gender: profile.gender,
      email: profile.email,
      address: profile.address,
      loginCount: profile.loginCount,
      pgConnected: profile.pgConnected,
      mongoConnected: profile.mongoConnected,
      appointments: profile.appointments,
      healthRecords: profile.healthRecords,
      labResults: profile.labResults,
      prescriptions: profile.prescriptions,
    );
  }

  factory DashboardUser.dummy() {
    return DashboardUser.fromProfile(PatientHealthProfile.dummy());
  }
}

/// Loads and holds the currently logged-in user's profile and clinical records for the dashboard.
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardUser>> {
  DashboardNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  final Ref ref;
  final UserHealthRepository _repository = UserHealthRepository();

  Future<void> _loadUser() async {
    try {
      // 1. Ensure dummy data is seeded in background
      unawaited(_repository.seedDummyUser().catchError((Object e) {
        debugPrint('Background seed notice: $e');
      }));

      // 2. Load stored session mobile or fallback to dummy user
      final String? savedMobile = await LocalePersistence.loadRememberMobile();
      final String targetMobile = (savedMobile != null && savedMobile.isNotEmpty)
          ? savedMobile
          : UserHealthRepository.dummyMobile;

      final PatientHealthProfile profile =
          await _repository.getPatientProfile(targetMobile);

      if (!ref.mounted) return;
      state = AsyncValue.data(DashboardUser.fromProfile(profile));
    } catch (error) {
      if (!ref.mounted) return;
      // Graceful fallback to dummy user so dashboard always renders smoothly
      state = AsyncValue.data(DashboardUser.dummy());
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadUser();
  }

  Future<void> logout() async {
    await LocalePersistence.saveRememberMobile('');
  }
}

/// Provides the current dashboard user state.
final dashboardUserProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardUser>>((ref) {
  return DashboardNotifier(ref);
});
