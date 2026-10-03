import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Thin wrapper around speech_to_text. No audio is stored by this module.
class SpeechService {
  final stt.SpeechToText _stt = stt.SpeechToText();
  bool _ready = false;

  /// Returns false if the microphone/speech permission is denied or unavailable.
  Future<bool> init({
    required void Function(String errorCode) onError,
    required void Function(String status) onStatus,
  }) async {
    if (_ready) return true;
    _ready = await _stt.initialize(
      onError: (e) => onError(e.errorMsg),
      onStatus: onStatus,
    );
    return _ready;
  }

  bool get isListening => _stt.isListening;

  /// [locale] examples: 'hi_IN', 'en_IN'.
  Future<void> listen({
    required String locale,
    required void Function(String text, bool isFinal) onResult,
  }) async {
    await _stt.listen(
      localeId: locale,
      listenFor: const Duration(seconds: 20),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
      onResult: (r) => onResult(r.recognizedWords, r.finalResult),
    );
  }

  Future<void> stop() => _stt.stop();
  Future<void> cancel() => _stt.cancel();
}
