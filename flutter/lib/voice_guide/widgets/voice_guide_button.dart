import 'dart:async';
import 'package:flutter/material.dart';
import '../models/voice_intent.dart';
import '../voice_guide.dart';

/// Big floating button. Drop it into any Scaffold:
///   floatingActionButton: const VoiceGuideButton(),
class VoiceGuideButton extends StatelessWidget {
  const VoiceGuideButton({super.key, this.onIntent});

  /// Optional: inspect/handle the intent yourself. Return true to skip the
  /// default handling.
  final FutureOr<bool> Function(VoiceIntent intent)? onIntent;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'voice_guide_fab',
      icon: const Icon(Icons.mic, size: 34),
      label: Text(VoiceGuide.controller.label('fab_label'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      onPressed: () {
        if (onIntent != null) VoiceGuide.controller.onIntent = onIntent;
        VoiceGuide.show(context);
      },
    );
  }
}
