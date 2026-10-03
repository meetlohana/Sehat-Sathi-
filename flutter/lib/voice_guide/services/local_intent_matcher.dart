import '../models/voice_intent.dart';
import '../voice_texts.dart';

class _Rule {
  const _Rule(this.intent, this.action, this.textKey, this.phrases,
      {this.dataHints = const []});
  final String intent;
  final VoiceAction action;
  final String textKey;
  final List<String> phrases;

  /// If any of these words also appear, the question is about the patient's
  /// own data -> try the backend first (falls back to just opening the screen).
  final List<String> dataHints;
}

/// Fast, offline, rule-based intent matching (English / Hindi / Hinglish /
/// Devanagari). Handles simple commands WITHOUT any network or LLM call.
/// Order of rules matters: first match wins. Mirror of backend intent_service.py.
class LocalIntentMatcher {
  // ---- Safety lists (checked first) ----
  static const _serious = [
    'chest pain', 'seene mein dard', 'saans nahi', 'behosh', 'unconscious',
    'bahut khoon', 'heavy bleeding', 'सीने में दर्द', 'सांस नहीं', 'बेहोश',
  ];
  static const _medicalAdvice = [
    'diagnose', 'diagnosis', 'pneumonia', 'typhoid', 'malaria', 'dengue',
    'cancer', 'am i having', 'do i have', 'kaun si bimari', 'kaun si dawai',
    'kaunsi dawai', 'dawai band', 'dawa band', 'dose', 'kitni goli',
    'prescribe', 'stop my medicine', 'stop taking', 'दवाई बंद',
  ];

  static const List<_Rule> _rules = [
    _Rule('EMERGENCY', VoiceAction.openEmergency, 'open_emergency', [
      'emergency', 'emergncy', 'ambulance', 'turant madad', 'bachao', 'accident',
      'इमरजेंसी', 'एमरजेंसी', 'आपातकाल', 'एम्बुलेंस', 'बचाओ', 'दुर्घटना',
    ]),
    _Rule('REPEAT', VoiceAction.repeat, 'nothing_to_repeat', [
      'dobara', 'dobara sunao', 'phir se', 'fir se', 'repeat', 'repeat that',
      'say again', 'दोबारा', 'फिर से',
    ]),
    _Rule('NEXT_STEP', VoiceAction.nextStep, 'screen_unknown', [
      'ab kya karna hai', 'ab kya karu', 'ab kya karun', 'aage kya',
      'what next', 'what now', 'next step', 'what do i do now',
      'अब क्या करना है', 'अब क्या करूं', 'आगे क्या',
    ]),
    _Rule('EXPLAIN_SCREEN', VoiceAction.explainScreen, 'screen_unknown', [
      'yahan kya hai', 'ye kya hai', 'is screen par kya', 'what is here',
      'what is this screen', 'where am i', 'main kahan hoon',
      'main kya kar sakta hoon', 'main kya kar sakti hoon',
      'kya kar sakta hoon', 'what can i do here', 'what can i do',
      'यहां क्या है', 'यहाँ क्या है', 'मैं क्या कर सकता हूं', 'मैं क्या कर सकती हूं',
    ]),
    _Rule('START_GUIDE', VoiceAction.startGuide, 'guide_app_start', [
      'app use karna nahi aata', 'use karna nahi aata', 'nahi aata', 'nahi aati',
      'samajh nahi aa raha', 'sikhao', 'sikha do', 'kaise use karu',
      'kaise use kare', 'teach me', 'how to use', 'how do i use', 'guide me',
      'help me use', 'इस्तेमाल करना नहीं आता', 'चलाना नहीं आता', 'नहीं आता',
      'सिखाओ', 'कैसे चलाऊं',
    ]),
    _Rule('GO_BACK', VoiceAction.goBack, 'go_back', [
      'back', 'back jao', 'peeche', 'peeche jao', 'wapas', 'wapas jao',
      'go back', 'previous', 'पीछे', 'वापस', 'पीछे जाओ',
    ]),
    _Rule('HELP', VoiceAction.openHelp, 'help_text', [
      'help', 'help chahiye', 'madad', 'sahayata', 'मदद', 'सहायता', 'हेल्प',
    ]),
    _Rule('START_CONSULTATION', VoiceAction.startConsultation, 'start_consultation', [
      'doctor se baat', 'doctor se baat karni', 'baat karni hai',
      'teleconsultation', 'teleconsult', 'consultation', 'video call',
      'call doctor', 'talk to doctor', 'talk to a doctor', 'speak to doctor',
      'doctor se call', 'डॉक्टर से बात', 'वीडियो कॉल', 'परामर्श',
    ]),
    _Rule('MY_APPOINTMENTS', VoiceAction.openAppointments, 'open_appointments', [
      'meri appointment', 'meri appointments', 'my appointment',
      'my appointments', 'appointment kab', 'next appointment',
      'upcoming appointment', 'appointment status', 'appointment dekhni',
      'appointment dikhao', 'मेरी अपॉइंटमेंट', 'अपॉइंटमेंट कब',
    ], dataHints: ['kab', 'when', 'next', 'agli', 'कब']),
    _Rule('BOOK_APPOINTMENT', VoiceAction.openAppointment, 'open_appointment', [
      'appointment', 'appointments', 'apointment', 'book', 'booking',
      'doctor se milna', 'doctor se mil', 'doctor ko dikhana',
      'doctor ki appointment', 'doctor appointment', 'see a doctor',
      'meet a doctor', 'meet doctor', 'अपॉइंटमेंट', 'अपॉइन्टमेंट',
      'डॉक्टर से मिलना', 'डॉक्टर से मिल',
    ]),
    _Rule('OPEN_HEALTH_RECORD', VoiceAction.openRecords, 'open_records', [
      'report', 'reports', 'record', 'records', 'health record',
      'health records', 'medical record', 'jaanch', 'test result',
      'test results', 'रिपोर्ट', 'रिपोर्ट्स', 'रिकॉर्ड', 'जांच',
    ]),
    _Rule('OPEN_REFERRAL', VoiceAction.openReferral, 'open_referral', [
      'referral', 'referrals', 'refer', 'रेफरल', 'रेफर',
    ], dataHints: ['status', 'sthiti', 'स्थिति']),
    _Rule('MY_MEDICINES', VoiceAction.openMedicines, 'open_medicines', [
      'medicine', 'medicines', 'dawai', 'dawa', 'dawaiyan', 'davai',
      'tablet', 'tablets', 'दवाई', 'दवा', 'दवाइयां', 'दवाइयाँ', 'गोली',
    ], dataHints: ['kya', 'what', 'which', 'kaun']),
    _Rule('OPEN_HOME', VoiceAction.openHome, 'open_home', [
      'home', 'home page', 'ghar', 'main page', 'होम', 'घर',
    ]),
  ];

  static const _hindiMarkers = [
    'mujhe', 'meri', 'mera', 'mere', 'hai', 'hain', 'karna', 'karni', 'dikhao',
    'jao', 'dekhni', 'dekhna', 'chahiye', 'kab', 'kya', 'nahi', 'aata', 'se',
    'ko', 'ki', 'ka', 'ab', 'yahan', 'baat', 'milna', 'dawai', 'madad',
  ];
  static const _englishMarkers = [
    'i', 'want', 'my', 'show', 'the', 'to', 'please', 'book', 'open', 'what',
    'how', 'can', 'go', 'me', 'need',
  ];

  /// lowercase, strip punctuation, pad with spaces for whole-word matching.
  static String normalize(String input) {
    var s = input.toLowerCase();
    s = s.replaceAll(RegExp(r'[^\u0900-\u097Fa-z0-9\s]'), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return ' $s ';
  }

  /// 'hi' for Hindi/Hinglish, 'en' for English. Ambiguous -> [preferred].
  static String detectLanguage(String normalized, {String preferred = 'hi'}) {
    if (RegExp(r'[\u0900-\u097F]').hasMatch(normalized)) return 'hi';
    final words = normalized.trim().split(' ');
    final hi = words.where(_hindiMarkers.contains).length;
    final en = words.where(_englishMarkers.contains).length;
    if (hi > en) return 'hi';
    if (en > hi) return 'en';
    return preferred;
  }

  static bool _has(String text, List<String> phrases) =>
      phrases.any((p) => text.contains(' ${p.toLowerCase()} '));

  /// Returns null when no local rule matches (caller may ask the backend).
  VoiceIntent? match(String normalized, String lang) {
    if (_has(normalized, _serious)) {
      return VoiceIntent(
          intent: 'EMERGENCY', action: VoiceAction.openEmergency, language: lang,
          responseText: VoiceTexts.get('serious_symptom', lang));
    }
    if (_has(normalized, _medicalAdvice)) {
      return VoiceIntent(
          intent: 'MEDICAL_QUESTION', action: VoiceAction.speakOnly, language: lang,
          responseText: VoiceTexts.get('medical_refusal', lang));
    }
    for (final r in _rules) {
      if (!_has(normalized, r.phrases)) continue;
      final data = r.dataHints.isNotEmpty && _has(normalized, r.dataHints);
      return VoiceIntent(
        intent: r.intent,
        action: r.action,
        language: lang,
        responseText: VoiceTexts.get(r.textKey, lang),
        requiresBackendData: data,
        guideTopic: r.action == VoiceAction.startGuide
            ? (normalized.contains('appointment') || normalized.contains('अपॉइंटमेंट')
                ? 'appointment'
                : 'app')
            : null,
      );
    }
    return null;
  }
}
