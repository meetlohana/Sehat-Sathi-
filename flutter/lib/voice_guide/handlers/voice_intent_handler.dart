import '../models/screen_context.dart';
import '../models/voice_intent.dart';
import '../services/guidance_engine.dart';
import '../services/voice_navigation_service.dart';
import '../voice_texts.dart';

class HandlerResult {
  const HandlerResult({this.followUp});

  /// Optional second sentence to speak after the main response.
  final String? followUp;
}

/// Central, whitelisted action dispatcher. The `switch` is exhaustive over
/// [VoiceAction]; there is no code path that accepts a route name or code.
class VoiceIntentHandler {
  VoiceIntentHandler({required this.navigation, required this.guidance});

  final VoiceNavigationService navigation;
  final GuidanceEngine guidance;

  Future<HandlerResult> handle(
      VoiceIntent intent, ScreenContext ctx, String lang) async {
    switch (intent.action) {
      case VoiceAction.openHome:
        guidance.stop();
        navigation.openHome();
        return const HandlerResult();

      case VoiceAction.openAppointment:
        // Navigate, then start guided booking: first instruction only.
        navigation.openAppointment();
        return HandlerResult(followUp: guidance.start('appointment', lang));

      case VoiceAction.openAppointments:
      case VoiceAction.showAppointment:
        navigation.openAppointments();
        return HandlerResult(followUp: _screenIntro(intent, VoiceScreens.appointments, lang));

      case VoiceAction.openRecords:
        navigation.openHealthRecords();
        return HandlerResult(followUp: guidance.explainScreen(VoiceScreens.records, lang));

      case VoiceAction.openReferral:
      case VoiceAction.showReferral:
        navigation.openReferral();
        return HandlerResult(followUp: _screenIntro(intent, VoiceScreens.referral, lang));

      case VoiceAction.openMedicines:
      case VoiceAction.showMedicines:
        navigation.openMedicines();
        return HandlerResult(followUp: _screenIntro(intent, VoiceScreens.medicines, lang));

      case VoiceAction.startConsultation:
        navigation.openConsultation();
        return HandlerResult(followUp: guidance.explainScreen(VoiceScreens.consultation, lang));

      case VoiceAction.openEmergency:
        // Opens the EXISTING emergency workflow. No medical decisions here.
        guidance.stop();
        navigation.openEmergency();
        return const HandlerResult();

      case VoiceAction.goBack:
        navigation.goBack();
        return const HandlerResult();

      case VoiceAction.startGuide:
        if (intent.guideTopic == 'appointment') {
          navigation.openAppointment();
          return HandlerResult(followUp: guidance.start('appointment', lang));
        }
        navigation.openHome();
        return HandlerResult(followUp: VoiceTexts.get('guide_app_followup', lang));

      case VoiceAction.openHelp:
        // Response text already lists the commands; no navigation.
        return const HandlerResult();

      case VoiceAction.explainScreen:
        return HandlerResult(followUp: guidance.explainScreen(ctx.screen, lang));

      case VoiceAction.nextStep:
        return HandlerResult(
            followUp: guidance.promptFor(ctx.step, lang) ??
                guidance.explainScreen(ctx.screen, lang));

      case VoiceAction.repeat: // handled by the controller
      case VoiceAction.speakOnly:
        return const HandlerResult();
    }
  }

  /// For backend-data answers the response text already holds the facts, so
  /// don't add a generic intro on top.
  String? _screenIntro(VoiceIntent i, String screen, String lang) =>
      i.requiresBackendData ? null : guidance.explainScreen(screen, lang);
}
