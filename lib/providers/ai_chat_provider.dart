import 'package:easypedv3/models/chat_message.dart';
import 'package:easypedv3/services/ai_chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
