/// Controlled WHITELIST of actions the voice module may perform.
/// Anything not listed here is rejected. The AI/backend can NEVER send
/// route names or code - only one of these wire values.
enum VoiceAction {
  openHome('OPEN_HOME'),
  openAppointment('OPEN_APPOINTMENT'),
  openAppointments('OPEN_APPOINTMENTS'),
  openRecords('OPEN_RECORDS'),
  openReferral('OPEN_REFERRAL'),
  openMedicines('OPEN_MEDICINES'),
  startConsultation('START_CONSULTATION'),
  openHelp('OPEN_HELP'),
  openEmergency('OPEN_EMERGENCY'),
  goBack('GO_BACK'),
  explainScreen('EXPLAIN_SCREEN'),
  nextStep('NEXT_STEP'),
  repeat('REPEAT'),
  startGuide('START_GUIDE'),
  // Backend-data variants: open the screen AND speak patient-specific text.
  showAppointment('SHOW_APPOINTMENT'),
  showMedicines('SHOW_MEDICINES'),
  showReferral('SHOW_REFERRAL'),
  speakOnly('SPEAK_ONLY');

  const VoiceAction(this.wire);
  final String wire;

  /// Returns null for unknown actions (caller must reject safely).
  static VoiceAction? fromWire(String? value) {
    for (final a in VoiceAction.values) {
      if (a.wire == value) return a;
    }
    return null;
  }

  /// Actions that change screen: the overlay closes before these run.
  bool get isNavigation => const {
        openHome, openAppointment, openAppointments, openRecords, openReferral,
        openMedicines, startConsultation, openEmergency, goBack, startGuide,
        showAppointment, showMedicines, showReferral,
      }.contains(this);
}

/// Structured result of understanding the patient's speech.
class VoiceIntent {
  const VoiceIntent({
    required this.intent,
    required this.action,
    required this.responseText,
    this.language = 'hi',
    this.requiresConfirmation = false,
    this.requiresBackendData = false,
    this.guideTopic,
  });

  final String intent; // e.g. OPEN_HEALTH_RECORD
  final VoiceAction action;
  final String responseText;
  final String language; // 'hi' | 'en'
  final bool requiresConfirmation;
  final bool requiresBackendData;
  final String? guideTopic; // 'app' | 'appointment'

  factory VoiceIntent.fromJson(Map<String, dynamic> j) {
    final action = VoiceAction.fromWire(j['action'] as String?);
    if (action == null) {
      throw const FormatException('Unknown action rejected');
    }
    return VoiceIntent(
      intent: (j['intent'] ?? 'UNKNOWN') as String,
      action: action,
      responseText: (j['response_text'] ?? '') as String,
      language: (j['language'] ?? 'hi') as String,
      requiresConfirmation: (j['requires_confirmation'] ?? false) as bool,
      requiresBackendData: (j['requires_backend_data'] ?? false) as bool,
      guideTopic: j['guide_topic'] as String?,
    );
  }
}
