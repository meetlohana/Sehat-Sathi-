import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/screen_context.dart';
import '../models/voice_intent.dart';

class VoiceApiException implements Exception {
  VoiceApiException(this.message);
  final String message;
  @override
  String toString() => 'VoiceApiException: $message';
}

/// Thrown on HTTP 401/403 (not logged in / not allowed).
class VoiceApiAuthException extends VoiceApiException {
  VoiceApiAuthException() : super('auth');
}

/// Talks to the FastAPI service. Base URL comes from a build-time variable:
///   flutter run --dart-define=VOICE_API_BASE_URL=https://api.example.com
class VoiceApiService {
  VoiceApiService({
    String? baseUrl,
    this.tokenProvider,
    http.Client? client,
  })  : baseUrl = baseUrl ??
            const String.fromEnvironment('VOICE_API_BASE_URL',
                defaultValue: 'http://10.0.2.2:8000'), // Android emulator -> host PC
        _client = client ?? http.Client();

  final String baseUrl;

  /// Return your app's current JWT (or null if not logged in).
  final Future<String?> Function()? tokenProvider;
  final http.Client _client;

  bool get isConfigured => baseUrl.isNotEmpty;

  Future<VoiceIntent> classify({
    required String text,
    required String language,
    required ScreenContext context,
    String? patientId,
  }) async {
    final token = await tokenProvider?.call();
    final res = await _client
        .post(
          Uri.parse('$baseUrl/api/voice/intent'),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'text': text,
            'language': language,
            'screen': context.screen,
            if (context.step != null) 'step': context.step,
            if (patientId != null) 'patient_id': patientId,
          }),
        )
        .timeout(const Duration(seconds: 8));

    if (res.statusCode == 401 || res.statusCode == 403) {
      throw VoiceApiAuthException();
    }
    if (res.statusCode != 200) {
      throw VoiceApiException('HTTP ${res.statusCode}');
    }
    return VoiceIntent.fromJson(
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>);
  }
}
