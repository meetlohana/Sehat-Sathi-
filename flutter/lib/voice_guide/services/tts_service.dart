import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-speech. Slow, clear speech rate for elderly / low-literacy users.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _configured = false;

  Future<void> _configure() async {
    if (_configured) return;
    await _tts.awaitSpeakCompletion(true); // so we can speak ONE step at a time
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _configured = true;
  }

  /// [lang] is 'hi' or 'en'.
  Future<void> speak(String text, String lang) async {
    if (text.trim().isEmpty) return;
    await _configure();
    await _tts.setLanguage(lang == 'hi' ? 'hi-IN' : 'en-IN');
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
