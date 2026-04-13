import 'package:easypedv3/models/chat_message.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/pro_feature_gate.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// AI Chat assistant screen with conversational interface.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _disclaimerChecked = false;

  static const _quickSuggestions = <String>[
    'Dose de paracetamol pediátrica',
    'Sinais vitais recém-nascido',
    'Diagnóstico diferencial de febre',
  ];

  @override
  void initState() {
    super.initState();
    // Log screen_view analytics event.
    FirebaseAnalytics.instance.logScreenView(screenName: 'ai_chat');
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Disclaimer dialog (first-use only, persisted) ──────────────────

  void _checkDisclaimer() {
    if (_disclaimerChecked) return;
    _disclaimerChecked = true;

    final accepted = ref.read(aiDisclaimerAcceptedProvider);
    if (!accepted) {
      Future.delayed(Duration.zero, _showDisclaimerDialog);
    }
  }

  Future<void> _showDisclaimerDialog() async {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.smart_toy, size: 48, color: colorScheme.primary),
          title: Text(
            'Assistente IA - Aviso',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          content: const Text(
            'O assistente de IA fornece informação exclusivamente para fins '
            'educacionais. As respostas geradas por inteligência artificial '
            'podem conter erros. Toda a informação deve ser validada pelo '
            'médico responsável.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FilledButton(
              onPressed: () {
                ref.read(aiDisclaimerAcceptedProvider.notifier).accept();
                Navigator.of(ctx).pop();
              },
              child: const Text('Li e Concordo'),
            ),
          ],
        );
      },
    );
  }

  // ── Send message ───────────────────────────────────────────────────

  Future<void> _sendMessage([String? prefilled]) async {
    final text = (prefilled ?? _textController.text).trim();
    if (text.isEmpty) return;

    _textController.clear();

    // Log analytics event.
    FirebaseAnalytics.instance.logEvent(name: 'ai_chat_message_sent');

    // Add user message.
    ref.read(chatMessagesProvider.notifier).addMessage(
          ChatMessage(role: MessageRole.user, text: text),
        );

    _scrollToBottom();

    // Start loading.
    ref.read(chatLoadingProvider.notifier).state = true;

    // Get AI response.
    final service = ref.read(aiChatServiceProvider);
    final response = await service.sendMessage(text);

    // Add AI response.
    ref.read(chatMessagesProvider.notifier).addMessage(
          ChatMessage(role: MessageRole.assistant, text: response),
        );

    // Stop loading.
    ref.read(chatLoadingProvider.notifier).state = false;

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

  void _clearChat() {
    ref.read(chatMessagesProvider.notifier).clearMessages();
    ref.read(aiChatServiceProvider).startNewChat();
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Assistente IA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Nova conversa',
            onPressed: _clearChat,
          ),
        ],
      ),
      body: ProFeatureGate(
        featureName: 'Assistente IA',
        featureKey: 'ai_chat',
        child: _AiChatBody(
          checkDisclaimer: _checkDisclaimer,
          textController: _textController,
          scrollController: _scrollController,
          quickSuggestions: _quickSuggestions,
          onSend: _sendMessage,
        ),
      ),
    );
  }
}

// ── AI Chat body (shown only for Pro users) ──────────────────────────

class _AiChatBody extends ConsumerWidget {
  const _AiChatBody({
    required this.checkDisclaimer,
    required this.textController,
    required this.scrollController,
    required this.quickSuggestions,
    required this.onSend,
  });

  final VoidCallback checkDisclaimer;
  final TextEditingController textController;
  final ScrollController scrollController;
  final List<String> quickSuggestions;
  final void Function([String?]) onSend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkDisclaimer();

    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(chatLoadingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Persistent disclaimer banner ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: colorScheme.primary.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'As respostas são para fins educacionais e devem ser '
                  'validadas pelo médico.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),

        // ── Messages or empty state ──
        Expanded(
          child: messages.isEmpty
              ? _EmptyState(
                  suggestions: quickSuggestions,
                  onSuggestionTap: (suggestion) {
                    onSend(suggestion);
                  },
                )
              : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isLoading) {
                      return const _TypingIndicator();
                    }
                    return _ChatBubble(message: messages[index]);
                  },
                ),
        ),

        // ── Input area ──
        const Divider(height: 1),
        _InputArea(
          controller: textController,
          isLoading: isLoading,
          onSend: () => onSend(),
        ),
      ],
    );
  }
}

// ── Chat Bubble ──────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final colorScheme = Theme.of(context).colorScheme;
    final timeFormat = DateFormat('HH:mm');

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        isUser ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              timeFormat.format(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: isUser
                        ? colorScheme.onPrimary.withValues(alpha: 0.7)
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Typing Indicator ─────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final delay = i * 0.33;
                final animationProgress =
                    ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
                final opacity =
                    0.3 + 0.7 * (1.0 - (2.0 * animationProgress - 1.0).abs());
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

// ── Input Area ───────────────────────────────────────────────────────

class _InputArea extends StatelessWidget {
  const _InputArea({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: 'Escreva a sua pergunta...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                maxLines: 4,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.send),
              onPressed: isLoading ? null : onSend,
              tooltip: 'Enviar',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: 72,
              color: colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(
              'Assistente de Pediatria',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faça uma pergunta sobre pediatria ou\nescolha uma sugestão abaixo.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions.map((text) {
                return ActionChip(
                  avatar: Icon(Icons.lightbulb_outline,
                      size: 18, color: colorScheme.primary),
                  label: Text(text),
                  onPressed: () => onSuggestionTap(text),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
