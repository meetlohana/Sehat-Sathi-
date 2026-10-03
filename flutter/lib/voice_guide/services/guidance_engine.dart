import '../voice_texts.dart';

/// Step-by-step guidance: speaks ONE instruction at a time and advances when
/// the screen reports the patient finished a step (see controller.reportStep).
class GuidanceEngine {
  /// Flow id -> ordered step ids.
  static const Map<String, List<String>> flows = {
    'appointment': [
      'doctor_selection',
      'date_selection',
      'time_selection',
      'confirm',
      'done',
    ],
  };

  String? _flow;
  String? _lastPrompted;

  bool get active => _flow != null;
  String? get activeFlow => _flow;

  /// Starts a flow and returns the FIRST instruction only.
  String start(String flow, String lang) {
    _flow = flow;
    _lastPrompted = flows[flow]!.first;
    return VoiceTexts.get('step_$_lastPrompted', lang);
  }

  void stop() {
    _flow = null;
    _lastPrompted = null;
  }

  /// Screen says "patient is now on [step]". Returns text to speak, or null
  /// (guide not active / step unknown / already spoken).
  String? onStep(String step, String lang) {
    final flow = _flow;
    if (flow == null || !flows[flow]!.contains(step) || step == _lastPrompted) {
      return null;
    }
    _lastPrompted = step;
    final text = VoiceTexts.get('step_$step', lang);
    if (step == flows[flow]!.last) stop();
    return text;
  }

  /// "Ab kya karna hai?" - instruction for the current step, if known.
  String? promptFor(String? step, String lang) {
    if (step == null) return null;
    final t = VoiceTexts.get('step_$step', lang);
    return t.isEmpty ? null : t;
  }

  /// "Yahan kya hai?" - what the current screen is for.
  String explainScreen(String screen, String lang) {
    final t = VoiceTexts.get('screen_$screen', lang);
    return t.isEmpty ? VoiceTexts.get('screen_unknown', lang) : t;
  }
}
