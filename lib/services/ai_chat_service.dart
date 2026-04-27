import 'package:easypedv3/utils/platform_support.dart';
import 'package:firebase_ai/firebase_ai.dart';

/// Service that wraps Firebase Vertex AI (Gemini 2.0 Flash) for pediatric
/// medical chat assistance.
class AiChatService {
  AiChatService();

  static const String _systemPrompt =
      'És um assistente médico pediátrico. Responde a perguntas sobre '
      'medicamentos, doenças pediátricas, doses, diagnóstico diferencial '
      'e sinais vitais.\n\n'
      'Regras:\n'
      '- Responde sempre em Português\n'
      '- As tuas respostas são exclusivamente para fins educacionais\n'
      '- Inclui sempre a nota: '
      "'Esta informação deve ser validada pelo médico responsável'\n"
      '- Não faças diagnósticos definitivos\n'
      '- Se não tiveres certeza, indica que o médico deve consultar '
      'fontes adicionais\n'
      '- Sê conciso e objetivo';

  late final GenerativeModel? _model = kSupportsAiChat
      ? FirebaseAI.vertexAI().generativeModel(
          model: 'gemini-2.5-flash-lite',
          systemInstruction: Content.system(_systemPrompt),
        )
      : null;
  ChatSession? _chatSession;

  /// Whether the AI chat service is available on the current platform.
  bool get isAvailable => kSupportsAiChat && _model != null;

  /// Start a new chat session, resetting any previous conversation context.
  void startNewChat() {
    final model = _model;
    if (model == null) return;
    _chatSession = model.startChat();
  }

  /// Send a user message and return the AI-generated response text.
  ///
  /// Automatically starts a new chat session if none exists.
  /// Throws a user-friendly [String] message on failure.
  Future<String> sendMessage(String prompt) async {
    final model = _model;
    if (model == null) {
      return 'O assistente de IA não está disponível nesta plataforma.';
    }
    _chatSession ??= model.startChat();

    try {
      final response = await _chatSession!.sendMessage(Content.text(prompt));
      final text = response.text;

      if (text == null || text.isEmpty) {
        return 'Não foi possível gerar uma resposta. '
            'Por favor, tente novamente.';
      }

      return text;
    } on FirebaseAIException catch (e) {
      return 'Erro do serviço de IA: ${e.message}';
    } catch (e) {
      return 'Ocorreu um erro inesperado. Por favor, tente novamente.';
    }
  }
}
