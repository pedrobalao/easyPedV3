import 'package:easypedv3/models/chat_message.dart';
import 'package:easypedv3/services/ai_chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// ── AI Chat Service ─────────────────────────────────────────────────

/// Singleton [AiChatService] provider.
final aiChatServiceProvider = Provider<AiChatService>((ref) {
  return AiChatService();
});

// ── Chat Messages ───────────────────────────────────────────────────

/// Notifier that manages the list of chat messages in memory.
class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super(<ChatMessage>[]);

  /// Append a message to the conversation.
  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  /// Clear all messages and reset the conversation.
  void clearMessages() {
    state = <ChatMessage>[];
  }
}

/// Provider for [ChatMessagesNotifier].
final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});

// ── Loading State ───────────────────────────────────────────────────

/// Tracks whether the AI is currently generating a response.
final chatLoadingProvider = StateProvider<bool>((ref) => false);

// ── AI Disclaimer Acceptance (Hive-backed) ──────────────────────────

const _aiChatBoxName = 'ai_chat_preferences';
const _aiDisclaimerKey = 'disclaimer_accepted';

/// Persisted provider that tracks whether the user accepted the AI disclaimer.
final aiDisclaimerAcceptedProvider =
    StateNotifierProvider<AiDisclaimerNotifier, bool>((ref) {
  return AiDisclaimerNotifier();
});

/// Notifier for the AI disclaimer acceptance state, persisted via Hive.
class AiDisclaimerNotifier extends StateNotifier<bool> {
  AiDisclaimerNotifier() : super(_readFromHive());

  static bool _readFromHive() {
    try {
      final box = Hive.box(_aiChatBoxName);
      return box.get(_aiDisclaimerKey, defaultValue: false) as bool;
    } catch (_) {
      return false;
    }
  }

  /// Mark the disclaimer as accepted and persist the value.
  Future<void> accept() async {
    state = true;
    final box = Hive.box(_aiChatBoxName);
    await box.put(_aiDisclaimerKey, true);
  }
}
