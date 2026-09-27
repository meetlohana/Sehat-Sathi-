import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_strings.dart';
import '../../../../core/i18n/locale_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/dashboard_titlebar.dart';

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isTyping = false,
  });

  final String text;
  final bool isUser;
  final bool isTyping;
}

class SymptomOption {
  const SymptomOption({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

final List<ChatMessage> _initialMessages = <ChatMessage>[
  const ChatMessage(
    isUser: false,
    text: 'Hello! I am your AI Health Assistant. How can I help you today?',
  ),
];

final List<String> _suggestions = <String>[
  'Book an appointment',
  'Check prescription status',
  'Find nearest clinic',
  'Lab test results',
];

class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ConsumerState<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends ConsumerState<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = List<ChatMessage>.from(_initialMessages);
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = ref.watch(appStringsProvider);

    final List<SymptomOption> symptoms = <SymptomOption>[
      SymptomOption(label: strings.chatSymptomFever, icon: Icons.thermostat_rounded),
      SymptomOption(label: strings.chatSymptomCough, icon: Icons.sick_rounded),
      SymptomOption(label: strings.chatSymptomLegPain, icon: Icons.directions_walk_rounded),
      SymptomOption(label: strings.chatSymptomThroatPain, icon: Icons.medical_services_rounded),
      SymptomOption(label: strings.chatSymptomOthers, icon: Icons.more_horiz_rounded),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Top bar ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DashboardTitleBar(
                title: strings.dashboardTitle,
                subtitle: 'AI Health Assistant',
                onBack: () => context.pop(),
              ),
            ),

            // ── Symptom chips ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List<Widget>.generate(symptoms.length, (int index) {
                    final SymptomOption symptom = symptoms[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < symptoms.length - 1 ? 12 : 0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _controller.text = symptom.label;
                            _sendMessage();
                          },
                          borderRadius: AppRadii.chipAll,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.tile,
                              borderRadius: AppRadii.chipAll,
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  symptom.icon,
                                  size: 20,
                                  color: AppColors.brand,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  symptom.label,
                                  style: AppTypography.cardBadge.copyWith(
                                    color: AppColors.body,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // ── Chat message list ──────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final ChatMessage message = _messages[index];
                  return _ChatBubble(message: message);
                },
              ),
            ),

            // ── Quick suggestion chips ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.footer,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((String suggestion) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _controller.text = suggestion;
                        _sendMessage();
                      },
                      borderRadius: AppRadii.chipAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: AppRadii.chipAll,
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Text(
                          suggestion,
                          style: AppTypography.cardBadge.copyWith(color: AppColors.body),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── Input field ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10 + 8),
              decoration: const BoxDecoration(
                color: AppColors.footer,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: AppSizes.fieldHeight,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppRadii.fieldAll,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        style: AppTypography.field,
                        maxLines: 4,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Type your health question...',
                          hintStyle: AppTypography.fieldHint,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: AppSizes.fieldHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: AppRadii.chipAll,
                      boxShadow: AppColors.brandGlow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppRadii.chipAll,
                      child: InkWell(
                        onTap: _sendMessage,
                        borderRadius: AppRadii.chipAll,
                        child: const Center(
                          child: Icon(
                            Icons.send_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    final Alignment alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final Color bg = isUser ? AppColors.brand : AppColors.white;
    final Color textColor = isUser ? AppColors.white : AppColors.ink;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: Border.all(color: isUser ? AppColors.brand : AppColors.border, width: 1),
          boxShadow: AppColors.cardShadow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: isUser
            ? Text(
                message.text,
                style: AppTypography.bodyCopy.copyWith(color: textColor),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medical_services_rounded,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message.text,
                      style: AppTypography.bodyCopy.copyWith(color: textColor),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
