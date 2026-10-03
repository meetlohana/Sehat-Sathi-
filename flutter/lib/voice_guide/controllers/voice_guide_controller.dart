import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../handlers/voice_intent_handler.dart';
import '../models/screen_context.dart';
import '../models/voice_intent.dart';
import '../models/voice_state.dart';
import '../services/guidance_engine.dart';
import '../services/local_intent_matcher.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/voice_api_service.dart';
import '../services/voice_local_store.dart';
import '../voice_texts.dart';

/// Orchestrates: STT -> normalize -> intent -> validate -> action -> TTS.
class VoiceGuideController extends ChangeNotifier {
  VoiceGuideController({
    required this.speech,
    required this.tts,
    required this.api,
    required this.handler,
    required this.guidance,
    VoiceLocalStore? store,
    this.patientIdProvider,
  }) : _store = store;

  final SpeechService speech;
  final TtsService tts;
  final VoiceApiService api;
  final VoiceIntentHandler handler;
  final GuidanceEngine guidance;
  final VoiceLocalStore? _store;

  /// Optional: return the logged-in patient id (backend still re-checks it).
  final Future<String?> Function()? patientIdProvider;

  final LocalIntentMatcher _matcher = LocalIntentMatcher();

  // ---- Observable UI state ----
  VoiceState state = VoiceState.idle;
  String heard = '';
  String message = '';
  String language = 'hi'; // preferred UI/STT language
  String _replyLang = 'hi'; // language of the current exchange
  String? pendingConfirmText;
  ScreenContext screenContext = const ScreenContext(screen: VoiceScreens.unknown);

  /// Optional hook (VoiceGuideButton(onIntent: ...)). Return true if YOU
  /// handled the intent and the default handling should be skipped.
  FutureOr<bool> Function(VoiceIntent intent)? onIntent;

  /// Set by the overlay so it can close itself before navigation.
  VoidCallback? closeOverlay;

  bool _sttReady = false;
  bool _handled = false;
  bool _disposed = false;
  String _lastSpoken = '';
  VoidCallback? _pendingYes;

  String _t(String key) => VoiceTexts.get(key, _replyLang);
  String label(String key) => VoiceTexts.get(key, language); // UI labels

  // ------------------------------------------------------------------
  // Public API
  // ------------------------------------------------------------------

  Future<void> loadPrefs() async {
    final saved = await _store?.get('lang');
    if (saved == 'hi' || saved == 'en') {
      language = saved!;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String lang) async {
    language = lang;
    await _store?.set('lang', lang);
    _safeNotify();
  }

  /// Screens/observer call this so guidance is screen-aware.
  void setScreen(String screen) {
    if (screenContext.screen == screen) return;
    if (guidance.active && screen != VoiceScreens.appointment) guidance.stop();
    screenContext = ScreenContext(screen: screen);
    _safeNotify();
  }

  /// Screens call this when the patient reaches a step, e.g.
  /// reportStep('date_selection'). If a guide is active, the next
  /// instruction is spoken (one at a time).
  Future<void> reportStep(String step) async {
    screenContext = ScreenContext(screen: screenContext.screen, step: step);
    _replyLang = language;
    final prompt = guidance.onStep(step, language);
    if (prompt != null && state != VoiceState.listening) {
      await _say(prompt, lang: language);
      _set(VoiceState.idle);
    }
  }

  Future<void> greet() async {
    _replyLang = language;
    await _say(_t('greeting'));
    _set(VoiceState.idle);
  }

  Future<void> startListening() async {
    if (state == VoiceState.listening) return;
    await tts.stop();
    _handled = false;
    heard = '';
    _replyLang = language;
    _sttReady = _sttReady ||
        await speech.init(onError: _onSttError, onStatus: _onSttStatus);
    if (!_sttReady) {
      await _fail('error_mic');
      return;
    }
    _log('voice_started');
    _set(VoiceState.listening, msg: _t('listening'));
    await speech.listen(
      locale: language == 'hi' ? 'hi_IN' : 'en_IN',
      onResult: _onSttResult,
    );
  }

  Future<void> stopListening() async {
    await speech.stop();
  }

  /// Cancel everything (overlay closed / Cancel pressed).
  Future<void> cancel() async {
    _handled = true;
    await speech.cancel();
    await tts.stop();
    _pendingYes = null;
    pendingConfirmText = null;
    _set(VoiceState.idle, msg: '');
  }

  /// "🔊 Dobara sunayein"
  Future<void> repeat() async {
    _replyLang = language;
    if (_lastSpoken.isEmpty) {
      await _say(_t('nothing_to_repeat'));
    } else {
      await _say(_lastSpoken);
    }
    _set(VoiceState.idle);
  }

  /// Typed/test entry point and the main pipeline.
  Future<void> processText(String raw) async {
    _log('voice_recognized'); // NOTE: the text itself is never logged
    _set(VoiceState.processing, msg: VoiceTexts.get('processing', language));

    final text = LocalIntentMatcher.normalize(raw);
    _replyLang = LocalIntentMatcher.detectLanguage(text, preferred: language);
    _set(VoiceState.understanding, msg: _t('processing'));

    final local = _matcher.match(text, _replyLang);
    VoiceIntent? result;

    if (local != null && !local.requiresBackendData) {
      result = local; // fast path: no network
    } else {
      final online = await _isOnline();
      if (online && api.isConfigured) {
        try {
          result = await api.classify(
            text: raw,
            language: _replyLang,
            context: screenContext,
            patientId: await patientIdProvider?.call(),
          );
        } on VoiceApiAuthException {
          if (local == null) return _fail('error_login');
          result = local; // not logged in: just open the screen
          await _say(_t('error_login'));
        } catch (_) {
          if (local == null) return _fail('error_backend');
          result = local; // backend down: open the screen anyway
        }
      } else if (local != null) {
        // Offline + wants live data: open the screen, explain the limit.
        result = local;
        await _say(_t('offline_data'));
      } else {
        return _fail('offline', offline: true);
      }
    }
    await _dispatch(result);
  }

  /// Screens can ask for spoken+visual confirmation of important actions:
  ///   VoiceGuide.controller.askConfirmation('Appointment confirm kar doon?', _book);
  Future<void> askConfirmation(String text, VoidCallback onYes) async {
    _pendingYes = onYes;
    pendingConfirmText = text;
    _set(VoiceState.confirming, msg: text);
    await _say(text, keepState: true);
    _set(VoiceState.confirming, msg: text);
  }

  Future<void> confirm(bool yes) async {
    final cb = _pendingYes;
    _pendingYes = null;
    pendingConfirmText = null;
    if (yes && cb != null) {
      cb();
    } else {
      await _say(_t('cancelled'));
    }
    _set(VoiceState.idle);
  }

  // ------------------------------------------------------------------
  // Internals
  // ------------------------------------------------------------------

  Future<void> _dispatch(VoiceIntent intent, {bool confirmed = false}) async {
    _log('intent_detected', intent.intent);

    // Optional app-level hook.
    final hook = onIntent;
    if (hook != null && await hook(intent)) return;

    // Whitelist is enforced by the VoiceAction enum (unknown -> rejected in
    // VoiceIntent.fromJson / never constructed).

    if (intent.requiresConfirmation && !confirmed) {
      await askConfirmation(intent.responseText,
          () => _dispatch(intent, confirmed: true));
      return;
    }
    if (intent.action == VoiceAction.repeat) return repeat();

    _set(VoiceState.navigating, msg: intent.responseText);

    // Close the overlay BEFORE navigating so we never pop the wrong route.
    if (intent.action.isNavigation && closeOverlay != null) {
      closeOverlay!();
      closeOverlay = null;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    final result = await handler.handle(intent, screenContext, _replyLang);
    _log('navigation_executed', intent.action.wire);

    await _say(intent.responseText);
    if (result.followUp != null && result.followUp!.isNotEmpty) {
      await _say(result.followUp!);
    }
    _set(VoiceState.idle);
  }

  Future<void> _say(String text, {String? lang, bool keepState = false}) async {
    if (text.isEmpty) return;
    _lastSpoken = text;
    if (!keepState) _set(VoiceState.speaking, msg: text);
    await tts.speak(text, lang ?? _replyLang);
  }

  Future<void> _fail(String key, {bool offline = false}) async {
    _log('voice_error', key);
    _set(offline ? VoiceState.offline : VoiceState.error, msg: _t(key));
    await _say(_t(key), keepState: true);
  }

  Future<bool> _isOnline() async {
    try {
      final r = await Connectivity().checkConnectivity();
      return !r.contains(ConnectivityResult.none);
    } catch (_) {
      return true;
    }
  }

  void _onSttResult(String text, bool isFinal) {
    heard = text;
    _safeNotify();
    if (isFinal && !_handled && text.trim().isNotEmpty) {
      _handled = true;
      processText(text);
    }
  }

  void _onSttStatus(String status) {
    if ((status == 'done' || status == 'notListening') &&
        state == VoiceState.listening &&
        !_handled) {
      // Give a late final result a moment to arrive.
      Future<void>.delayed(const Duration(milliseconds: 700), () {
        if (_handled || state != VoiceState.listening) return;
        _handled = true;
        if (heard.trim().isNotEmpty) {
          processText(heard);
        } else {
          _fail('error_not_understood');
        }
      });
    }
  }

  void _onSttError(String code) {
    if (_handled) return;
    _handled = true;
    _fail(code == 'error_permission' ? 'error_mic' : 'error_not_understood');
  }

  void _set(VoiceState s, {String? msg}) {
    state = s;
    if (msg != null) message = msg;
    _safeNotify();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  /// Safe dev logs: event names only. Never text, tokens or health data.
  void _log(String event, [String? detail]) {
    if (kDebugMode) debugPrint('[VoiceGuide] $event${detail != null ? ' $detail' : ''}');
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
