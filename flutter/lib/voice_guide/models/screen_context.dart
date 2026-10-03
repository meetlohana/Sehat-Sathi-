/// Stable screen ids used by the voice module (NOT your route names).
class VoiceScreens {
  static const home = 'home';
  static const appointment = 'appointment';
  static const appointments = 'appointments';
  static const records = 'records';
  static const referral = 'referral';
  static const medicines = 'medicines';
  static const consultation = 'consultation';
  static const emergency = 'emergency';
  static const unknown = 'unknown';
}

/// Where the patient currently is: {"screen": "appointment", "step": "doctor_selection"}
class ScreenContext {
  const ScreenContext({required this.screen, this.step});
  final String screen;
  final String? step;

  Map<String, dynamic> toJson() => {'screen': screen, if (step != null) 'step': step};
}
