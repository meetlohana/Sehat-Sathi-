import 'package:flutter/material.dart';
import 'controllers/voice_guide_controller.dart';
import 'handlers/voice_intent_handler.dart';
import 'models/voice_intent.dart';
import 'models/voice_state.dart';
import 'services/guidance_engine.dart';
import 'services/speech_service.dart';
import 'services/tts_service.dart';
import 'services/voice_api_service.dart';
import 'services/voice_local_store.dart';
import 'services/voice_navigation_service.dart';
import 'widgets/voice_guide_overlay.dart';

export 'controllers/voice_guide_controller.dart';
export 'models/screen_context.dart';
export 'models/voice_intent.dart';
export 'models/voice_state.dart';
export 'services/voice_navigation_service.dart' show VoiceRoutes, VoiceNavigationService;
export 'widgets/voice_guide_button.dart';

/// One-stop facade. The ONLY import your app needs:
///   import 'voice_guide/voice_guide.dart';
class VoiceGuide {
  VoiceGuide._();

  static late VoiceGuideController controller;
  static late VoiceRouteObserver routeObserver;
  static bool _initialised = false;

  /// Call once in main() before runApp().
  static void init({
    required GlobalKey<NavigatorState> navigatorKey,
    VoiceRoutes routes = const VoiceRoutes(),
    Map<VoiceAction, VoidCallback> navigationOverrides = const {},
    String? apiBaseUrl, // else --dart-define=VOICE_API_BASE_URL
    Future<String?> Function()? tokenProvider, // your JWT
    Future<String?> Function()? patientIdProvider,
  }) {
    final guidance = GuidanceEngine();
    final nav = VoiceNavigationService(
        navigatorKey: navigatorKey, routes: routes, overrides: navigationOverrides);
    controller = VoiceGuideController(
      speech: SpeechService(),
      tts: TtsService(),
      api: VoiceApiService(baseUrl: apiBaseUrl, tokenProvider: tokenProvider),
      handler: VoiceIntentHandler(navigation: nav, guidance: guidance),
      guidance: guidance,
      store: VoiceLocalStore(),
      patientIdProvider: patientIdProvider,
    )..loadPrefs();
    routeObserver = VoiceRouteObserver(routes: routes, onScreen: controller.setScreen);
    _initialised = true;
  }

  /// Opens the Voice Guide overlay (and starts listening).
  static Future<void> show(BuildContext context) {
    assert(_initialised, 'Call VoiceGuide.init() in main() first.');
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierLabel: 'Voice Guide',
      pageBuilder: (_, __, ___) => VoiceGuideOverlay(controller: controller),
    ).whenComplete(() {
      // Only stop the mic if still listening; never cut off speech after navigation.
      if (controller.state == VoiceState.listening) controller.cancel();
    });
  }

  /// Speaks the welcome message ("Namaste. Main Sehat Sathi Voice Guide hoon...").
  static Future<void> greet() => controller.greet();

  /// Screens report progress: VoiceGuide.reportStep('date_selection');
  static Future<void> reportStep(String step) => controller.reportStep(step);

  /// Ask the patient to confirm an important action (spoken + buttons).
  static Future<void> confirm(String text, VoidCallback onYes) =>
      controller.askConfirmation(text, onYes);
}
