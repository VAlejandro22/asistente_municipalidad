import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bot_response.dart';
import '../config/chatbot_config.dart';

class ChatbotService {
  static const Duration _timeout = ChatbotConfig.requestTimeout;

  /// Sends a user query to the n8n workflow and returns the bot response
  Future<BotResponse> sendQuery(String userQuery, {String? sessionId}) async {
    try {
      final requestBody = {
        'query': userQuery,
        'session_id': sessionId ?? _generateSessionId(),
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'flutter_app'
      };

      final response = await http.post(
        Uri.parse(ChatbotConfig.chatbotWebhookUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return BotResponse.fromJson(responseData);
      } else {
        throw ChatbotException(
          'Error del servidor: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ChatbotException) {
        rethrow;
      }
      throw ChatbotException(
        'Error de conexión: No se pudo conectar con el asistente municipal. Verifique su conexión a internet.',
        originalError: e,
      );
    }
  }

  /// Escalates a conversation to a human operator
  Future<BotResponse> escalateToHuman(String reason, String conversationContext) async {
    try {
      final requestBody = {
        'action': 'escalate',
        'reason': reason,
        'context': conversationContext,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse(ChatbotConfig.escalationWebhookUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return BotResponse.fromJson(responseData);
      } else {
        throw ChatbotException(
          'Error al escalar la consulta: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ChatbotException(
        'Error al conectar con un funcionario. Intente nuevamente.',
        originalError: e,
      );
    }
  }

  String _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class ChatbotException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ChatbotException(
    this.message, {
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ChatbotException: $message';
}
