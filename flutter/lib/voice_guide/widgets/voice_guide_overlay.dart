import 'package:flutter/material.dart';
import '../controllers/voice_guide_controller.dart';
import '../models/voice_state.dart';

/// Full-screen, rural-friendly voice UI: giant mic, giant text, few buttons.
/// Uses the host app's Theme colours.
class VoiceGuideOverlay extends StatefulWidget {
  const VoiceGuideOverlay({super.key, required this.controller});
  final VoiceGuideController controller;

  @override
  State<VoiceGuideOverlay> createState() => _VoiceGuideOverlayState();
}

class _VoiceGuideOverlayState extends State<VoiceGuideOverlay> {
  VoiceGuideController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    c.closeOverlay = _close;
    // Start listening as soon as the overlay opens.
    WidgetsBinding.instance.addPostFrameCallback((_) => c.startListening());
  }

  void _close() {
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void dispose() {
    c.closeOverlay = null;
    super.dispose();
  }

  String _stateLabel() {
    switch (c.state) {
      case VoiceState.listening:
        return ''; // the message below already says "Listening..."
      case VoiceState.processing:
      case VoiceState.understanding:
        return c.label('processing');
      case VoiceState.confirming:
        return '';
      case VoiceState.idle:
        return c.label('tap_to_speak');
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: c,
          builder: (context, _) {
            final listening = c.state == VoiceState.listening;
            final isError = c.state == VoiceState.error || c.state == VoiceState.offline;
            final micColor = isError ? cs.error : (listening ? cs.primary : cs.secondary);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text('Sehat Sathi',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: cs.primary)),
                  Text('Voice Guide', style: TextStyle(fontSize: 20, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(_stateLabel(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: cs.onSurface)),
                          if (c.heard.isNotEmpty && listening) ...[
                            const SizedBox(height: 12),
                            Text('"${c.heard}"',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: cs.onSurface)),
                          ],
                          const SizedBox(height: 16),
                          if (c.message.isNotEmpty)
                            Text(c.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24, height: 1.4, color: isError ? cs.error : cs.onSurface)),
                        ],
                      ),
                    ),
                  ),
                  if (c.state == VoiceState.confirming)
                    Row(children: [
                      Expanded(child: _bigButton(c.label('btn_yes'), cs.primary, cs.onPrimary, () => c.confirm(true))),
                      const SizedBox(width: 12),
                      Expanded(child: _bigButton(c.label('btn_no'), cs.error, cs.onError, () => c.confirm(false))),
                    ])
                  else
                    Semantics(
                      button: true,
                      label: 'Microphone',
                      child: GestureDetector(
                        onTap: listening ? c.stopListening : c.startListening,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: listening ? 168 : 148,
                          height: listening ? 168 : 148,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
                          child: Icon(listening ? Icons.hearing : Icons.mic,
                              size: 80, color: cs.onPrimary),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: c.repeat,
                      child: Text(c.label('btn_repeat'), style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    TextButton(
                      onPressed: () => c.setLanguage(c.language == 'hi' ? 'en' : 'hi'),
                      child: Text(c.language == 'hi' ? 'हिंदी → English' : 'English → हिंदी',
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        await c.cancel();
                        _close();
                      },
                      child: Text(c.label('btn_cancel'), style: const TextStyle(fontSize: 22)),
                    ),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bigButton(String text, Color bg, Color fg, VoidCallback onTap) => SizedBox(
        height: 72,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: fg),
          onPressed: onTap,
          child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      );
}
