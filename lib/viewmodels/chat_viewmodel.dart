import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/bot_response.dart';
import '../services/chatbot_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatbotService _chatbotService = ChatbotService();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _sessionId;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMessages => _messages.isNotEmpty;

  ChatViewModel() {
    _initializeChat();
  }

  void _initializeChat() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: _generateMessageId(),
      content: '''¡Hola! Soy el asistente virtual de la Municipalidad de SAN MIGUEL. 

Puedo ayudarte con:
• Información sobre trámites y documentos necesarios
• Ordenanzas y normativas municipales
• Procedimientos administrativos
• Y mucho más...

¿En qué puedo asistirte hoy?''',
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );

    _messages.add(welcomeMessage);
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    _clearError();

    // Add user message
    final userMessage = ChatMessage(
      id: _generateMessageId(),
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    notifyListeners();

    // Add loading indicator
    _setLoading(true);
    final loadingMessage = ChatMessage(
      id: _generateMessageId(),
      content: 'Escribiendo...',
      type: MessageType.bot,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    _messages.add(loadingMessage);
    notifyListeners();

    try {
      // Send query to n8n workflow
      final botResponse = await _chatbotService.sendQuery(
        content,
        sessionId: _sessionId,
      );

      // Remove loading message
      _messages.removeLast();

      // Add bot response
      final responseMessage = ChatMessage(
        id: _generateMessageId(),
        content: botResponse.response,
        type: botResponse.requiresEscalation ? MessageType.escalation : MessageType.bot,
        timestamp: DateTime.now(),
        metadata: _buildMetadata(botResponse),
      );

      _messages.add(responseMessage);

      // Add escalation options if needed
      if (botResponse.requiresEscalation) {
        _addEscalationMessage(botResponse.escalationReason);
      }

    } catch (e) {
      // Remove loading message
      _messages.removeLast();

      // Add error message
      final errorMessage = ChatMessage(
        id: _generateMessageId(),
        content: _getErrorMessage(e),
        type: MessageType.system,
        timestamp: DateTime.now(),
      );

      _messages.add(errorMessage);
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _addEscalationMessage(String? reason) {
    final escalationMessage = ChatMessage(
      id: _generateMessageId(),
      content: '''No pude encontrar una respuesta específica para tu consulta.
      
${reason ?? 'Tu consulta requiere atención personalizada.'}

¿Te gustaría que conecte tu consulta con un funcionario municipal? Responde "Sí" para ser derivado a atención humana.''',
      type: MessageType.escalation,
      timestamp: DateTime.now(),
    );

    _messages.add(escalationMessage);
    notifyListeners();
  }

  Future<void> escalateToHuman() async {
    _setLoading(true);

    try {
      final conversationContext = _buildConversationContext();
      final response = await _chatbotService.escalateToHuman(
        'Usuario solicitó escalación',
        conversationContext,
      );

      final escalationResponse = ChatMessage(
        id: _generateMessageId(),
        content: response.response,
        type: MessageType.system,
        timestamp: DateTime.now(),
      );

      _messages.add(escalationResponse);

    } catch (e) {
      final errorMessage = ChatMessage(
        id: _generateMessageId(),
        content: 'No se pudo conectar con un funcionario en este momento. Por favor, intenta más tarde o visita nuestras oficinas.',
        type: MessageType.system,
        timestamp: DateTime.now(),
      );

      _messages.add(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  void clearChat() {
    _messages.clear();
    _clearError();
    _initializeChat();
  }

  String _buildMetadata(BotResponse response) {
    final metadata = <String, dynamic>{};

    if (response.confidence != null) {
      metadata['confidence'] = response.confidence;
    }

    if (response.documentReference != null) {
      metadata['document'] = response.documentReference;
    }

    if (response.suggestedActions != null) {
      metadata['suggestions'] = response.suggestedActions;
    }

    return metadata.isNotEmpty ? metadata.toString() : '';
  }

  String _buildConversationContext() {
    return _messages
        .where((m) => m.type == MessageType.user || m.type == MessageType.bot)
        .map((m) => '${m.type.name}: ${m.content}')
        .join('\n\n');
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('conexión')) {
      return 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
    } else if (error.toString().contains('timeout')) {
      return 'La consulta está tardando más de lo esperado. Por favor, intenta con una pregunta más específica.';
    } else {
      return 'Ocurrió un error inesperado. Por favor, intenta nuevamente o contacta con soporte técnico.';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  String _generateMessageId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_messages.length}';
  }
}
